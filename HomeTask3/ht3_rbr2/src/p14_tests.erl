-module(p14_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p14', [duplicate/1]).

duplicate_test_() ->
	[
		?_assert(duplicate([]) =:= []),
		?_assert(duplicate([1]) =:= [1,1]),
		?_assertException(error, function_clause, duplicate(5)),
		?_assertException(error, function_clause, duplicate(atom)),
		?_assertException(error, function_clause, duplicate({1, 2, 3, 4})),
		?_assertException(error, function_clause, duplicate(<<116,114,117,101>>)),
		?_assertException(error, function_clause, duplicate(#{age => 1054,name => "Santa",sex => male})),
		?_assert(duplicate([{a, "b"}, {c, 1054}, {k, 16}]) =:= [{a,"b"},{a,"b"},{c,1054},{c,1054},{k,16},{k,16}]),		
		?_assert(duplicate([<<44>>,"A",<<32>>,<<44>>]) =:= [<<",">>,<<",">>,"A","A",<<" ">>,<<" ">>, <<",">>,<<",">>]),
		?_assert(duplicate([1,1,1,1243,2,3,3,4]) =:= [1,1,1,1,1,1,1243,1243,2,2,3,3,3,3,4,4]),
		?_assert(duplicate("ssstring") =:= "ssssssttrriinngg")
	].

