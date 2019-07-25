-include_lib("eunit/include/eunit.hrl").
-module(p01_tests).
-import('p01', [last/1]).

last_test_() ->
	[?_assertException(error, function_clause, last([])),
	?_assertException(error, function_clause, last(1)),
	?_assertException(error, function_clause, last(a)),
	?_assertException(error, function_clause, last({})),
	?_assertException(error, function_clause, last({3})),
	?_assertException(error, function_clause, last({"A", "B"})),
	?_assert(last([1]) =:= 1),
	?_assert(last([1, 2]) =:= 2),
	?_assert(last([1, -4, 7, 0]) =:= 0),
	?_assert(last([<<"A">>, "B"]) =:= "B"),
	?_assert(last([{"a", "b"}]) =:= {"a", "b"}),
	?_assert(last([{a,b}, <<1>>, {7, -2, k}, 4]) =:= 4)
	].
