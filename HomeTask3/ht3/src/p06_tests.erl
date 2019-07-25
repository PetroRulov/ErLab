-include_lib("eunit/include/eunit.hrl").
-module(p06_tests).
-import('p06', [is_palindrome/1]).

is_palindrome_test_() ->
	[
		?_assertException(error, function_clause, is_palindrome(5)),
		?_assertException(error, function_clause, is_palindrome(atom)),
		?_assertException(error, function_clause, is_palindrome({1, 2, 3, 4})),
		?_assertException(error, function_clause, is_palindrome(<<116,114,117,101>>)),
		?_assertException(error, function_clause, is_palindrome(#{age => 1054,name => "Santa",sex => male})),
		?_assert(is_palindrome([{a, "b"}, {c, 1054}, {k, 16}]) =:= false),
		?_assert(is_palindrome([]) =:= true),
		?_assert(is_palindrome([1]) =:= true),
		?_assert(is_palindrome([<<44>>, <<32>>, <<58>>, <<32>>, <<44>>]) =:= true),
		?_assert(is_palindrome([1,2,3]) =:= false),
		?_assert(is_palindrome([<<"A">>, "B", <<"C">>, <<16>>]) =:= false),
		?_assert(is_palindrome([{a, "b"}, {c, 1054}, {k, 16}, {3, -1}, {4, z}]) =:= false),
		?_assert(is_palindrome([{a,b, {4, "A"}}, <<1>>, {7, -2, k}, 4]) =:= false),
		?_assert(is_palindrome("string") =:= false),
		?_assert(is_palindrome("topot") =:= true)
	].

