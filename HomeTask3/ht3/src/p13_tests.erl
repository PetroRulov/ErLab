-module(p13_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p13', [decode/1]).

decode_test_() ->
	[
		?_assert(decode([]) =:= []),
		?_assert(decode([1]) =:= [1]),
		?_assertException(error, function_clause, decode(5)),
		?_assertException(error, function_clause, decode(atom)),
		?_assertException(error, function_clause, decode({1, 2, 3, 4})),
		?_assertException(error, function_clause, decode(<<116,114,117,101>>)),
		?_assertException(error, function_clause, decode(#{age => 1054,name => "Santa",sex => male})),
		?_assertException(error, badarith, decode([{a, "b"}, {c, 1054}, {k, 16}])),
		?_assertException(error, badarith, decode([{2,{a,{4,"A"}}},{a,{4,<<"A">>}},{1,<<1>>},{1,4}])),
		?_assert(decode([{2,{a,{4,"A"}}},{1,{4,<<"A">>}},{1,<<1>>},{1,4}]) =:= [{a,{4,"A"}},{a,{4,"A"}},{4,<<"A">>},<<1>>,4]),
		?_assert(decode([{3, <<44>>}, {1,<<32>>}, {1,<<44>>}]) =:= [<<",">>,<<",">>,<<",">>,<<" ">>,<<",">>]),
		?_assert(decode([{5,1},{1,1243},{1,2},{3,3},{1,4}]) =:= [1,1,1,1,1,1243,2,3,3,3,4]),
		?_assert(decode([{2,"a"},{2,a},{2,<<"a">>},{1,<<16>>},{1,<<"16">>}]) =:= ["a", "a", a, a, <<"a">>, <<"a">>, <<16>>, <<"16">>]),
		?_assert(decode([{3,115},{1,116},{1,114},{1,105},{1,110},{1,103}]) =:= "ssstring")
	].

