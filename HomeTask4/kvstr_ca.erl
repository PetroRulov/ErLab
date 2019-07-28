-module(kvstr_ca).
-export([average_measure/3]).
-export([map_create/0, map_update/3, map_read_through_pm/1, map_getValue/2]).
-export([prlt_create/0, prlt_update/3, prlt_getValue/2]).
-export([dict_create/0, dict_update/3, dict_getValue/2]).
-export([prodict_create/0, prodict_update/2, prodict_getValue/1]).
-export([ets_create/0, ets_update/3, ets_getValue/2]).

%%% (this module makes comparative time-execution analysys all of key-value methods data storage:
%%% maps, proplist, dict, process dictionary, ets)

%% c(kvstr_ca).

%% MAPS
%% kvstr_ca:average_measure(1000, map_create, []).
%% Map = kvstr_ca:map_create().
%% maps:put(b, 152, Map).
%% kvstr_ca:average_measure(1000, map_update, [a, 170, Map]).
%% kvstr_ca:average_measure(1000, map_read_through_pm, [Map]).
%% kvstr_ca:average_measure(1000, map_getValue, [a, Map]).

%% PROPLIST
%% kvstr_ca:average_measure(1000, prlt_create(), []).
%% PL = [{a, 20},{b, "experiment"},{c, true}].
%% kvstr_ca:average_measure(1000, prlt_update, [a, 170, PL]).
%% kvstr_ca:average_measure(1000, prlt_getValue, [a, PL]).

%% DICT
%% Dict_1 = kvstr_ca:dict_create().
%% kvstr_ca:average_measure(1000, dict_create, []).
%% kvstr_ca:average_measure(1000, dict_update, [a, "Ten", Dict_1]).
%% kvstr_ca:average_measure(1000, dict_getValue, [a, Dict_1]).

%% PROCESS DICTIONARY
%% kvstr_ca:average_measure(1000, prodict_create, []).
%% kvstr_ca:average_measure(1000, prodict_update, [a, "Ten"]).
%% kvstr_ca:average_measure(1000, prodict_getValue, [a]).

%% ETS
%% Tab = kvstr_ca:ets_create().
%% kvstr_ca:average_measure(1000, ets_create, []).
%% kvstr_ca:average_measure(1000, ets_update, [a, 170, Tab]).
%% kvstr_ca:average_measure(1000, ets_getValue, [a, Tab]).

%% measure functions
average_measure(N, Foo, List) -> 
	TL = repeater(N, Foo, List), 
	sum(TL)/N.

repeater(0, _, _) -> [];
repeater(N, FooName, []) ->
    {D,_} = timer:tc(?MODULE, FooName, []),
    [D|repeater(N-1, FooName, [])];
repeater(N, FooName, List) ->
    {D,_} = timer:tc(?MODULE, FooName, List),
    [D|repeater(N-1, FooName, List)].

sum([]) -> 0;
sum([H|T]) -> H + sum(T).


%% maps
map_create() ->
	Map = maps:new(),
	maps:put(a, 42, Map).

map_update(Key, Value, Map) ->
	maps:update(Key, Value, Map).

map_read_through_pm(#{a := A}) -> % the correct way would be to fully specify the key
	A.

map_getValue(Key, Map) ->
	maps:get(Key, Map).


%% proplists
prlt_create() ->
	[{a, 5}].

prlt_update(Key, Value, PL) ->
	[{Key, Value} | PL].

prlt_getValue(Key, PL) ->
    proplists:get_value(Key, PL).


%% dicts
dict_create() ->
    Dict = dict:new(), 
    dict:store(a, "Five", Dict).

dict_update(Key, Value, Dict) ->
    dict:store(Key, Value, Dict).
    
dict_getValue(Key, Dict) ->
    dict:fetch(Key, Dict).


%% process dictionary
prodict_create() ->
    put(a, "Five").
    
prodict_update(Key, Value) ->
    put(Key, Value).

prodict_getValue(Key) ->
    get(Key).


%% ets
ets_create() ->
    Tab = ets:new(table, []),
    ets:insert(Tab, {a, 5}),
    Tab.

ets_update(Key, Value, Ets) ->
    ets:insert(Ets, {Key, Value}).

ets_getValue(Key, Ets) ->
	ets:lookup(Ets, Key).

