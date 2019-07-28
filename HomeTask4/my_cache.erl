-module(my_cache).
-export([create/1, insert/4, lookup/2, delete_obsolete/1]).

%%% This module is a library for ets-cache creation
%%% c(my_cache).

%% my_cache:create(persons). 						Result: ok
%% my_cache:insert(persons, rulov, "Petro", 600). 	Result: ok
%% my_cache:lookup(persons, rulov).					Result: {ok, Value}
%% my_cache:delete_obsolete(persons). 				Result: ok

create(TableName) ->
	case lists:member(TableName, ets:all()) of
		false ->
			ets:new(TableName, [protected, named_table, set]),
			ok;
		true ->
			io:format("Bad argument (ets with the name \"~p\" exists already!", [TableName])
	end.
 
insert(TableName, Key, Value, LifeTime) when is_integer(LifeTime) ->
	ets:insert(TableName, {Key, Value, (element(2, erlang:timestamp()) + LifeTime)}), 
    ok;
insert(_, _, _, LifeTime) ->
	io:format("Bad LifeTime argument (\"~p\" must be type of integer!", [LifeTime]).

lookup(TableName, Key) ->
	try
		{_, Value, LifeTime} = hd(ets:lookup(TableName, Key)),
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

delete_obsolete(TableName) ->
    try
        OldContent = ets:tab2list(TableName),
        NewContent = lists:filter(fun({_, _, LifeTime}) ->
        	LifeTime >= element(2, erlang:timestamp()) end, OldContent),
        ets:delete_all_objects(TableName),
        ets:insert(TableName, NewContent),
        ok
    catch
        error:badarg ->
            io:format("Bad TableName argument: there is no ets-table with the name \"~p\"!~n", [TableName])
    end.











































    
    


        
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

