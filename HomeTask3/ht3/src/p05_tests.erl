-include_lib("eunit/include/eunit.hrl").
-module(p05_tests).
-import('p05', [reverse/1, reverserr/1]).

reverse_test_() ->
	[
		?_assertException(error, function_clause, reverse(5)),
		?_assertException(error, function_clause, reverse(atom)),
		?_assertException(error, function_clause, reverse({1, 2, 3, 4})),
		?_assertException(error, function_clause, reverse(<<116,114,117,101>>)),
		?_assertException(error, function_clause, reverse(#{age => 1054,name => "Santa",sex => male})),
		?_assert(reverse([{a, "b"}, {c, 1054}, {k, 16}]) =:= [{k,16},{c,1054},{a,"b"}]),
		?_assert(reverse([]) =:= []),
		?_assert(reverse([1]) =:= [1]),
		?_assert(reverse([1,2,3]) =:= [3,2,1]),
		?_assert(reverse([<<"A">>, "B", <<"C">>, <<16>>]) =:= [<<16>>,<<"C">>,"B",<<"A">>]),
		?_assert(reverse([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= [{4,z},{3,-1},{k,16},{c,1054},{a,"b"}]),
		?_assert(reverse([{a,b, {4, "A"}}, <<1>>, {7, -2, k}, 4]) =:= [4,{7,-2,k},<<1>>,{a,b,{4,"A"}}]),
		?_assert(reverse("string") =:= "gnirts")
	].

reverserr_test_() ->
	[
		?_assertException(error, function_clause, reverserr(5)),
		?_assertException(error, function_clause, reverserr(atom)),
		?_assertException(error, function_clause, reverserr({1, 2, 3, 4})),
		?_assertException(error, function_clause, reverserr(<<116,114,117,101>>)),
		?_assertException(error, function_clause, reverserr(#{age => 1054,name => "Santa",sex => male})),
		?_assert(reverserr([{a, "b"}, {c, 1054}, {k, 16}]) =:= [{k,16},{c,1054},{a,"b"}]),
		?_assert(reverserr([]) =:= []),
		?_assert(reverserr([1]) =:= [1]),
		?_assert(reverserr([1,2,3]) =:= [3,2,1]),
		?_assert(reverserr([<<"A">>, "B", <<"C">>, <<16>>]) =:= [<<16>>,<<"C">>,"B",<<"A">>]),
		?_assert(reverserr([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= [{4,z},{3,-1},{k,16},{c,1054},{a,"b"}]),
		?_assert(reverserr([{a,b, {4, "A"}}, <<1>>, {7, -2, k}, 4]) =:= [4,{7,-2,k},<<1>>,{a,b,{4,"A"}}]),
		?_assert(reverserr("string") =:= "gnirts")
	].

