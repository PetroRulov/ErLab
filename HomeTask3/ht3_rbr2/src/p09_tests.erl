-module(p09_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p09', [pack/1]).

pack_test_() ->
	[
		?_assertException(error, function_clause, pack(5)),
		?_assertException(error, function_clause, pack(atom)),
		?_assertException(error, function_clause, pack({1, 2, 3, 4})),
		?_assertException(error, function_clause, pack(<<116,114,117,101>>)),
		?_assertException(error, function_clause, pack(#{age => 1054,name => "Santa",sex => male})),
		?_assert(pack([{a, "b"}, {c, 1054}, {k, 16}]) =:= [[{a,"b"}],[{c,1054}],[{k,16}]]),
		?_assert(pack([]) =:= []),
		?_assert(pack([1]) =:= [[1]]),
		?_assert(pack([<<44>>, <<44>>, <<44>>, <<32>>, <<44>>]) =:= [[<<",">>,<<",">>,<<",">>],[<<" ">>],[<<",">>]]),
		?_assert(pack([1,1,1,1,1,1243,2,3,3,3,4]) =:= [[1,1,1,1,1],[1243],[2],[3,3,3],[4]]),
		?_assert(pack(["a", "a", a, a, <<"a">>, <<"a">>, <<16>>, <<"16">>]) =:= [["a","a"],[a,a],[<<"a">>,<<"a">>],[<<16>>],[<<"16">>]]),
		?_assert(pack([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= [[{a,"b"}],[{c,1054}],[{k,16}],[{3,-1}],[{4,z}]]),
		?_assert(pack([{a, {4, "A"}}, {a, {4, "A"}}, {a, {4, <<"A">>}}, <<1>>, 4]) =:= [[{a,{4,"A"}},{a,{4,"A"}}],[{a,{4,<<"A">>}}],[<<1>>],[4]]),
		?_assert(pack("ssstring") =:= ["sss","t","r","i","n","g"]),
		?_assert(pack([1,1,1,-1,2,-2,2,-2,-3,3,-3,3,0,0,0]) =:= [[1,1,1],[-1],[2],[-2],[2],[-2],[-3],[3],[-3],[3],[0,0,0]])
	].

