-module(p11_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p11', [encode_modified/1]).

encode_modified_test_() ->
	[
		?_assert(encode_modified([]) =:= []),
		?_assert(encode_modified([1]) =:= [1]),
		?_assertException(error, function_clause, encode_modified(5)),
		?_assertException(error, function_clause, encode_modified(atom)),
		?_assertException(error, function_clause, encode_modified({1, 2, 3, 4})),
		?_assertException(error, function_clause, encode_modified(<<116,114,117,101>>)),
		?_assertException(error, function_clause, encode_modified(#{age => 1054,name => "Santa",sex => male})),
		?_assert(encode_modified([{a, "b"}, {c, 1054}, {k, 16}]) =:= [{a,"b"},{c,1054},{k,16}]),
		?_assert(encode_modified([<<44>>, <<44>>, <<44>>, <<32>>, <<44>>]) =:= [{3,<<",">>},<<" ">>,<<",">>]),
		?_assert(encode_modified([1,1,1,1,1,1243,2,3,3,3,4]) =:= [{5,1},1243,2,{3,3},4]),
		?_assert(encode_modified(["a", "a", a, a, <<"a">>, <<"a">>, <<16>>, <<"16">>]) =:= [{2,"a"},{2,a},{2,<<"a">>},<<16>>,<<"16">>]),
		?_assert(encode_modified([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= [{a,"b"},{c,1054},{k,16},{3,-1},{4,z}]),
		?_assert(encode_modified([{a, {4, "A"}}, {a, {4, "A"}}, {a, {4, <<"A">>}}, <<1>>, 4]) =:= [{2,{a,{4,"A"}}},{a,{4,<<"A">>}},<<1>>,4]),
		?_assert(encode_modified("ssstring") =:= [{3,115},116,114,105,110,103])
	].

