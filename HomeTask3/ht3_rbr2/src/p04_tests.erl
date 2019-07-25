-include_lib("eunit/include/eunit.hrl").
-module(p04_tests).
-import('p04', [len/1, lentc/1]).

len_test_() ->
	[
		?_assertException(error, function_clause, len(5)),
		?_assertException(error, function_clause, len(atom)),
		?_assertException(error, function_clause, len({1, 2, 3, 4})),
		?_assertException(error, function_clause, len(<<116,114,117,101>>)),
		?_assertException(error, function_clause, len(#{age => 1054,name => "Santa",sex => male})),
		?_assert(len([{a, "b"}, {c, 1054}, {k, 16}]) =:= 3),
		?_assert(len([]) =:= 0),
		?_assert(len([1]) =:= 1),
		?_assert(len([1,2,3]) =:= 3),
		?_assert(len([<<"A">>, "B", <<"C">>, <<16>>]) =:= 4),
		?_assert(len([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= 5),
		?_assert(len([{a,b, {4, "A"}}, <<1>>, {7, -2, k}, 4]) =:= 4),
		?_assert(len("string") =:= 6)
	].

lentc_test_() ->
	[
		?_assertException(error, function_clause, lentc(5)),
		?_assertException(error, function_clause, lentc(atom)),
		?_assertException(error, function_clause, lentc({1, 2, 3, 4})),
		?_assertException(error, function_clause, lentc(<<116,114,117,101>>)),
		?_assertException(error, function_clause, lentc(#{age => 1054,name => "Santa",sex => male})),
		?_assert(lentc([{a, "b"}, {c, 1054}, {k, 16}]) =:= 3),
		?_assert(lentc([]) =:= 0),
		?_assert(lentc([1]) =:= 1),
		?_assert(lentc([1,2,3]) =:= 3),
		?_assert(lentc([<<"A">>, "B", <<"C">>, <<16>>]) =:= 4),
		?_assert(lentc([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= 5),
		?_assert(lentc([{a,b, {4, "A"}}, <<1>>, {7, -2, k}, 4]) =:= 4),
		?_assert(lentc("string") =:= 6)
	].