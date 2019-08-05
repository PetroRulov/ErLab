-module(cache_solo).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([start_link/2]).
-export([]).

%% c(cache_solo).
%% cache_solo:start_link(passwords, [{drop_interval, 90}]).
%% gen_server:cast(passwords, {insert, {passwords, ivanov, "Russ?a_vpered", 55}}).
%% gen_server:cast(passwords, {insert, {passwords, roizman, "!Taki_Goy&", 120}}).
%% gen_server:cast(passwords, {insert, {passwords, prihodko, "Ukra8ne_ponad_use@", 200}}).

%% gen_server:call(passwords, {lookup, {passwords, prihodko}}).
%% gen_server:call(passwords, {lookup_by_date, {passwords, {{2019, 8, 5},{21, 15, 0}}, {{2019, 8, 5},{21, 16, 0}}}}).

%% STOP
%% gen_server:call(passwords, stop).

handle_call({lookup_by_date, {TableName, DateFrom, DateTo}}, _From, State) ->
	Value = lookup_by_date(TableName, DateFrom, DateTo),
	{reply, {ok, Value}, State};
handle_call({lookup, {TableName, Key}}, _From, State) ->
	Value = lookup(TableName, Key),
	{reply, {ok, Value}, State};
handle_call(stop, _From, State) ->
	{reply, {stop, normal}, State};
handle_call(_, _From, State) ->
	{noreply, State}.

handle_cast({insert, {TableName, Key, Value, LifeTime}}, _State) ->
	NewState = insert(TableName, Key, Value, LifeTime),
	{noreply, NewState};
handle_cast(_, State) ->
	{noreply, State}.

handle_info({delete, {TableName, Key}}, _State) ->
	NewState = ets:delete(TableName, Key),
	{noreply, NewState};
handle_info({delete_obsolete, {TableName, DropInterval}}, _State) ->	
	NewState = delete_obsolete(TableName),
	erlang:send_after(DropInterval, self(), {info, {delete_obsolete, {TableName, DropInterval}}}),
	{noreply, NewState};
handle_info(_, State) ->
	{noreply, State}.

terminate(normal, _State) ->
	ok;
terminate(Reason, _State) ->
	Reason.



%% LAUNCH SERVER
start_link(TableName, [{drop_interval, Time}]) ->
	DropInterval = Time * 1000, 
	gen_server:start_link({local, TableName}, ?MODULE, [TableName, DropInterval], [timeout, 5000]).

init([TableName, DropInterval]) ->
	create(TableName),
	erlang:send_after(DropInterval, whereis(TableName), {delete_obsolete, {TableName, DropInterval}}),
	State = ets:tab2list(TableName),
	{ok, State}.



%% - a u x i l i a r y   f u n c t i o n s -
create(TableName) ->
	case lists:member(TableName, ets:all()) of
		false ->
			ets:new(TableName, [protected, named_table, set]),
			ok;
		true ->
			io:format("Bad argument (ets with the name \"~p\" exists already!", [TableName])
	end.

insert(TableName, Key, Value, LifeTime) when is_integer(LifeTime) ->
	try 
		ets:insert(TableName, {Key, Value, erlang:localtime(), (element(2, erlang:timestamp()) + LifeTime)}), 
		ok
	catch
		error:badarg -> 
			io:format("Bad TableName argument: \"~p\"!~n", [TableName])
	end;
insert(_, _, _, LifeTime) ->
	io:format("Bad LifeTime argument (\"~p\": must be type of integer!", [LifeTime]).

delete_obsolete(TableName) ->
    try
        OldContent = ets:tab2list(TableName),
        CurrentTime = element(2, erlang:timestamp()),
        NewContent = lists:filter(fun({_, _, _, LifeTime}) ->
        	LifeTime >= CurrentTime end, OldContent),
        ets:delete_all_objects(TableName),
        ets:insert(TableName, NewContent),
        ok
    catch
        error:badarg ->
            io:format("Bad TableName argument: there is no ets-table with the name \"~p\"!~n", [TableName])
    end.

lookup(TableName, Key) ->
	try
		{_, Value, _, LifeTime} = hd(ets:lookup(TableName, Key)),
		CurrentTime = element(2, erlang:timestamp()),
		if
			CurrentTime =< LifeTime ->
				Value;
        	true ->
        		io:format("There is no actual Value by the key: \"~p\"!~n", [Key])
    	end
	catch
		error:badarg -> 
			io:format("Bad TableName or Key argument: \"~p\", \"~p\"!~n", [TableName, Key])
	end.

lookup_by_date(TableName, DateFrom={FrDate,{FrH,FrMin,FrSec}}, DateTo={TDate,{TH,TMin,TSec}})
when is_integer(FrH), is_integer(FrMin), is_integer(FrSec), is_integer(TH), is_integer(TMin), is_integer(TSec) ->
	case calendar:valid_date(FrDate) andalso calendar:valid_date(TDate) of
		true ->
			try
				Content = ets:tab2list(TableName),
				LookupContent = lists:filter(fun({_, _, CreationDate, _}) ->
        			calendar:datetime_to_gregorian_seconds(CreationDate) >= calendar:datetime_to_gregorian_seconds(DateFrom) andalso 
        			calendar:datetime_to_gregorian_seconds(CreationDate) =< calendar:datetime_to_gregorian_seconds(DateTo) end, 
        			Content),
				LookupContent
			catch
				error:badarg -> 
					io:format("Bad TableName argument: \"~p\"!~n", [TableName])
			end;
		_ ->
			io:format("DateFrom:Date or DateTo:Date is/are NOT valid!")
	end;
lookup_by_date(_TableName, _={_={_,_,_},{_,_,_}}, _={_={_,_,_},{_,_,_}}) ->
	io:format("Wrong DateFrom:Time or DateTo:Time arguments!").
