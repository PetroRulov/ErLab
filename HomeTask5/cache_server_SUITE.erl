-module(cache_server_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_group/2, end_per_group/2, groups/0]).
-export([ivanov/1, roizman/1, prihodko/1, old_dropped/1]).

%% ct_run -suite cache_server_SUITE 			% in terminal or
%% ct:run_test([suite, cache_server_SUITE]). 	% in erlang shell

all() -> [{group, session}].

groups() -> [{session, []
			, [{group, users}
			, old_dropped]}
			,{users, [parallel, {repeat, 1}], [ivanov, prihodko, roizman]}
			].

init_per_group(session, Config) ->
	cache_server:start_link(cache_server_handler, passwords, {drop_interval, 90}),
	Config;
init_per_group(_, Config) ->
	Config.

end_per_group(session, _Config) ->
	cache_server:stop(cache_server);
end_per_group(_, _Config) ->
	ok.

ivanov(_Config) ->
	cache_server:cast(cache_server, {insert, {passwords, ivanov, "Russ8a_Vpered", 55}}).
	
prihodko(_Config) ->
	cache_server:cast(cache_server, {insert, {passwords, prihodko, "Ukraine@9_ponaduse", 200}}).

roizman(_Config) ->
	cache_server:cast(cache_server, {insert, {passwords, roizman, "taki!Goi?", 120}}).



old_dropped(_Config) ->
	[{prihodko,"Ukraine@9_ponaduse",_,_},
 	{ivanov,"Russ8a_Vpered",_,_},
 	{roizman,"taki!Goi?",_,_}] = ets:tab2list(passwords),
	timer:sleep(100000),
	[{prihodko, "Ukraine@9_ponaduse",_, _}, {roizman, "taki!Goi?", _, _}] = ets:tab2list(passwords).
	

