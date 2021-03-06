-module(my_cache).
-export([create/1, insert/4, lookup/2, lookup_by_date/3, delete_obsolete/1]).
-export([to_timestamp/1]).

%%% This module is a library for ets-cache creation
%%% c(my_cache).

%% my_cache:create(persons). 						Result: ok
%% my_cache:insert(persons, rulov, "Petro", 600). 	Result: ok
%% my_cache:lookup(persons, rulov).					Result: {ok, Value}
%% my_cache:
%% my_cache:delete_obsolete(persons). 				Result: ok

%% my_cache:insert(passwords, ivanov, "Russia,GoAhead!", 600).
%% my_cache:insert(passwords, golovko, "!Ukraine@Ponad_use", 600).
%% my_cache:insert(passwords, roizman, "?Usi_Goyi@", 600).
%% my_cache:lookup_by_date(passwords, {{2019, 7, 31},{12, 59, 0}}, {{2019, 7, 31},{13, 0, 0}}).



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

lookup(TableName, Key) ->
	try
		{_, Value, _, LifeTime} = hd(ets:lookup(TableName, Key)),
		CurrentTime = element(2, erlang:timestamp()),
		if
			CurrentTime =< LifeTime ->
    	        {ok, Value};
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
				{ok, LookupContent}
			catch
				error:badarg -> 
					io:format("Bad TableName argument: \"~p\"!~n", [TableName])
			end;
		_ ->
			io:format("DateFrom:Date or DateTo:Date is/are NOT valid!")
	end;
lookup_by_date(_TableName, _={_={_,_,_},{_,_,_}}, _={_={_,_,_},{_,_,_}}) ->
	io:format("Wrong DateFrom:Time or DateTo:Time arguments!").


delete_obsolete(TableName) ->
    try
        OldContent = ets:tab2list(TableName),
        NewContent = lists:filter(fun({_, _, _, LifeTime}) ->
        	LifeTime >= element(2, erlang:timestamp()) end, OldContent),
        ets:delete_all_objects(TableName),
        ets:insert(TableName, NewContent),
        ok
    catch
        error:badarg ->
            io:format("Bad TableName argument: there is no ets-table with the name \"~p\"!~n", [TableName])
    end.


%% internal
%msToDate(Milliseconds) ->
%   BaseDate      = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
%   Seconds       = BaseDate + (Milliseconds div 1000),
%   { Date, Time } = calendar:gregorian_seconds_to_datetime(Seconds),
%   { Date, Time }.

to_timestamp({{Year,Month,Day},{Hours,Minutes,Seconds}}) ->
	calendar:datetime_to_gregorian_seconds({{Year,Month,Day},{Hours,Minutes,Seconds}}).



































    
    


        
%delete_obsolete(TableName) ->
%    try
%        OldContent = ets:tab2list(TableName),
%        NewContent = lists:filter(fun({_, _, LifeTime}) -> LifeTime >= curr_time() end, OldContent),
%        ets:delete_all_objects(TableName),
%        ets:insert(TableName, NewContent),
%        ok
%    catch
%        error:badarg ->
%            {error, tableName_is_incorrect}
%    end.

