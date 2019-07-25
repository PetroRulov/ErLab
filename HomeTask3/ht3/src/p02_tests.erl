-include_lib("eunit/include/eunit.hrl").
-module(p02_tests).
-import('p02', [but_last/1]).

but_last_test_() ->
	[?_assertException(error, function_clause, but_last([])),
	?_assertException(error, function_clause, but_last(1)),
	?_assertException(error, function_clause, but_last(atom)),
	?_assertException(error, function_clause, but_last({})),
	?_assertException(error, function_clause, but_last({3})),
	?_assertException(error, function_clause, but_last({"A", "B"})),
	?_assertException(error, function_clause, but_last(<<116,114,117,101>>)),
	?_assertException(error, function_clause, but_last([1])),
	?_assert(but_last([1, 2]) =:= [1, 2]),
	?_assert(but_last([1,-4, 7, 0]) =:= [7, 0]),
	?_assert(but_last([<<"A">>, "B", <<"C">>, <<16>>]) =:= [<<"C">>, <<16>>]),
	?_assert(but_last([{"a", "b"}, {"c", "d"}]) =:= [{"a", "b"}, {"c", "d"}]),
	?_assert(but_last([{a,b}, <<1>>, {7, -2, k}, 4]) =:= [{7, -2, k}, 4])
	].
