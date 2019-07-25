-include_lib("eunit/include/eunit.hrl").
-module(p08_tests).
-import('p08', [compress/1]).

compress_test_() ->
	[
		?_assertException(error, function_clause, compress(5)),
		?_assertException(error, function_clause, compress(atom)),
		?_assertException(error, function_clause, compress({1, 2, 3, 4})),
		?_assertException(error, function_clause, compress(<<116,114,117,101>>)),
		?_assertException(error, function_clause, compress(#{age => 1054,name => "Santa",sex => male})),
		?_assert(compress([{a, "b"}, {a, b}, {"a", b}, {"a", "b"}, {"a", "b"}]) =:= [{a, "b"}, {a, b}, {"a", b}, {"a", "b"}]),
		?_assert(compress([]) =:= []),
		?_assert(compress([1]) =:= [1]),
		?_assert(compress([<<44>>, <<44>>, <<44>>, <<32>>, <<44>>]) =:= [<<44>>, <<32>>, <<44>>]),
		?_assert(compress([1,1,1,1,1,12,2,3,3,3,4]) =:= [1,12,2,3,4]),
		?_assert(compress(["a", "a", "a", a, a, <<"a">>, <<"a">>, <<16>>, <<"16">>]) =:= ["a",a,<<"a">>,<<16>>,<<"16">>]),
		?_assert(compress([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= [{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]),
		?_assert(compress([{a, {4, "A"}}, {a, {4, "A"}}, {a, {4, <<"A">>}}, <<1>>, 4]) =:= [{a,{4,"A"}},{a,{4,<<"A">>}},<<1>>,4]),
		?_assert(compress("ssstring") =:= "string"),
		?_assert(compress("ttTTopPPPoTTtt") =:= "tTopPoTt"),
		?_assert(compress([1,1,1,-1,2,-2,2,-2,-3,3,-3,3,0,0,0]) =:= [1,-1,2,-2,2,-2,-3,3,-3,3,0])
	].

