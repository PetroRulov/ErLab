-module(cache_solo_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-export([test_creation/1, test_shutdown/1, test_insertion/1, test_lookup/1, test_lookup_by_date/1, test_drop_interval/1]).

%% ct_run -suite cache_solo_SUITE 			% in terminal or
%% ct:run_test([suite, cache_solo_SUITE]). 	% in erlang shell

all() ->
	[
        test_creation,
		test_shutdown,
		test_insertion,
		test_lookup,
		test_lookup_by_date,
		test_drop_interval
    ].

test_creation(_Config) ->
	{ok, _} = cache_solo:start_link(passwords, [{drop_interval, 3600}]),
	[] = ets:tab2list(passwords).

test_shutdown(_Config) ->
	cache_solo:start_link(passwords, [{drop_interval, 3600}]),
	ok = gen_server:cast(passwords, stop).
	
test_insertion(_Config) ->
	cache_solo:start_link(passwords, [{drop_interval, 3600}]),
	gen_server:cast(passwords, {insert, {passwords, ivanov, "Russ?a_vpered", 25}}),
	gen_server:cast(passwords, {insert, {passwords, roizman, "!Taki_Goy&", 60}}),
	gen_server:cast(passwords, {insert, {passwords, prihodko, "Ukra8ne_ponad_use@", 45}}),
	timer:sleep(1000),
	[{prihodko,"Ukra8ne_ponad_use@",_,_},     
 	{ivanov,"Russ?a_vpered",_,_},
 	{roizman,"!Taki_Goy&",_,_}] = ets:tab2list(passwords).


test_lookup(_Config) ->
	cache_solo:start_link(passwords, [{drop_interval, 3600}]),
	ok = gen_server:cast(passwords, {insert, {passwords, prihodko, "Ukra8ne_ponad_use@", 45}}),
	{ok,"Ukra8ne_ponad_use@"} = gen_server:call(passwords, {lookup, {passwords, prihodko}}).

test_lookup_by_date(_Config) ->
	cache_solo:start_link(passwords, [{drop_interval, 3600}]),
	ok = gen_server:cast(passwords, {insert, {passwords, ivanov, "Russ?a_vpered", 25}}),
	ok = gen_server:cast(passwords, {insert, {passwords, roizman, "!Taki_Goy&", 60}}),
	ok = gen_server:cast(passwords, {insert, {passwords, prihodko, "Ukra8ne_ponad_use@", 45}}),
	DateFrom = {{2019,01,01},{00,00,00}},
	DateTo = calendar:local_time(),
	{ok,[{prihodko,"Ukra8ne_ponad_use@",_,_},
     {ivanov,"Russ?a_vpered",_,_},
     {roizman,"!Taki_Goy&",_,_}]} = gen_server:call(passwords, {lookup_by_date, {passwords, DateFrom, DateTo}}).	

test_drop_interval(_Config) ->
	cache_solo:start_link(passwords, [{drop_interval, 15}]),
	ok = gen_server:cast(passwords, {insert, {passwords, ivanov, "Russ?a_vpered", 25}}),
	ok = gen_server:cast(passwords, {insert, {passwords, roizman, "!Taki_Goy&", 60}}),
	ok = gen_server:cast(passwords, {insert, {passwords, prihodko, "Ukra8ne_ponad_use@", 45}}),
	timer:sleep(35000),
	[{prihodko,"Ukra8ne_ponad_use@",_,_},     
 	{roizman,"!Taki_Goy&",_,_}] = ets:tab2list(passwords).
