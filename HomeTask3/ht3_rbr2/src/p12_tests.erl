-module(p12_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p12', [decode_modified/1]).

decode_modified_test_() ->
	[
		?_assert(decode_modified([]) =:= []),
		?_assert(decode_modified([1]) =:= [1]),
		?_assertException(error, function_clause, decode_modified(5)),
		?_assertException(error, function_clause, decode_modified(atom)),
		?_assertException(error, function_clause, decode_modified({1, 2, 3, 4})),
		?_assertException(error, function_clause, decode_modified(<<116,114,117,101>>)),
		?_assertException(error, function_clause, decode_modified(#{age => 1054,name => "Santa",sex => male})),
		?_assertException(error, badarith, decode_modified([{a, "b"}, {c, 1054}, {k, 16}])),
		?_assertException(error, badarith, decode_modified([{2,{a,{4,"A"}}},{a,{4,<<"A">>}},<<1>>,4])),
		?_assert(decode_modified([<<44>>, <<44>>, <<44>>, <<32>>, <<44>>]) =:= [<<",">>,<<",">>,<<",">>,<<" ">>,<<",">>]),
		?_assert(decode_modified([{5,1},1243,2,{3,3},4]) =:= [1,1,1,1,1,1243,2,3,3,3,4]),
		?_assert(decode_modified([{2,"a"},{2,a},{2,<<"a">>},<<16>>,<<"16">>]) =:= ["a", "a", a, a, <<"a">>, <<"a">>, <<16>>, <<"16">>]),
		?_assert(decode_modified([{3,115},116,114,105,110,103]) =:= "ssstring")
	].

