-module(p10_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p10', [encode/1]).

encode_test_() ->
	[
		?_assert(encode([]) =:= []),
		?_assert(encode([1]) =:= [{1,1}]),
		?_assertException(error, function_clause, encode(5)),
		?_assertException(error, function_clause, encode(atom)),
		?_assertException(error, function_clause, encode({1, 2, 3, 4})),
		?_assertException(error, function_clause, encode(<<116,114,117,101>>)),
		?_assertException(error, function_clause, encode(#{age => 1054,name => "Santa",sex => male})),
		?_assert(encode([{a, "b"}, {c, 1054}, {k, 16}]) =:= [{1,{a,"b"}},{1,{c,1054}},{1,{k,16}}]),
		?_assert(encode([<<44>>, <<44>>, <<44>>, <<32>>, <<44>>]) =:= [{3,<<",">>},{1,<<" ">>},{1,<<",">>}]),
		?_assert(encode([1,1,1,1,1,1243,2,3,3,3,4]) =:= [{5,1},{1,1243},{1,2},{3,3},{1,4}]),
		?_assert(encode(["a", "a", a, a, <<"a">>, <<"a">>, <<16>>, <<"16">>]) =:= [{2,"a"},{2,a},{2,<<"a">>},{1,<<16>>},{1,<<"16">>}]),
		?_assert(encode([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= [{1,{a,"b"}},{1,{c,1054}},{1,{k,16}},{1,{3,-1}},{1,{4,z}}]),
		?_assert(encode([{a, {4, "A"}}, {a, {4, "A"}}, {a, {4, <<"A">>}}, <<1>>, 4]) =:= [{2,{a,{4,"A"}}},{1,{a,{4,<<"A">>}}},{1,<<1>>},{1,4}]),
		?_assert(encode("ssstring") =:= [{3,115},{1,116},{1,114},{1,105},{1,110},{1,103}])
	].

