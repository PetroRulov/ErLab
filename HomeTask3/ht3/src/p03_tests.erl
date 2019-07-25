-include_lib("eunit/include/eunit.hrl").
-module(p03_tests).
-import('p03', [element_at/2]).

element_at_test_() ->
	[
		?_assertException(error, function_clause, element_at({"A", "B", "C", "D"}, 3)),
		?_assertException(error, function_clause, element_at(<<116,114,117,101>>, 3)),
		?_assertException(error, badarith, element_at([1],"A")),
		?_assert(element_at([], 7) =:= undefined),
		?_assert(element_at([1], 1) =:= 1),
		?_assert(element_at([1,2,3], -2) =:= undefined),
		?_assert(element_at([1,2,3,4,5], 7) =:= undefined),
		?_assert(element_at([1,-4, 7, 0], 2) =:= -4),
		?_assert(element_at([<<"A">>, "B", <<"C">>, <<16>>], 3) =:= <<"C">>),
		?_assert(element_at([{"a", "b"}, {"c", "d"}, {k, 16}, {3, -1}, {4, z}], 2) =:= {"c", "d"}),
		?_assert(element_at([{a,b}, <<1>>, {7, -2, k}, 4], 4) =:= 4)
	].
