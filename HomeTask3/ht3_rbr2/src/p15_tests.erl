-module(p15_tests).
-include_lib("eunit/include/eunit.hrl").
-import('p15', [replicate/2]).

replicate_test_() ->
	[
		?_assert(replicate([], 5) =:= []),
		?_assert(replicate([], -5) =:= []),
		?_assert(replicate([], 0) =:= []),
		?_assert(replicate([1], 5) =:= [1,1,1,1,1]),
		?_assertThrow({badarg, "Second argument less than 0"}, replicate([-1], -5)),
		?_assert(replicate([-1], 0) =:= []),
		?_assertException(error, function_clause, replicate(5, 5)),
		?_assertException(error, function_clause, replicate(atom, 5)),
		?_assertException(error, function_clause, replicate({1, 2, 3, 4}, 3)),
		?_assertException(error, function_clause, replicate(<<116,114,117,101>>, 3)),
		?_assertException(error, function_clause, replicate(#{age => 1054,name => "Santa",sex => male}, 2)),
		?_assertThrow({badarg, "Second argument less than 0"}, replicate([-1], -5)),
		?_assert(replicate([atom1, atom2], 3) =:= [atom1,atom1,atom1,atom2,atom2,atom2]),
		?_assertThrow({badarg, "Second argument less than 0"}, replicate([atom1, atom2], -3)),
		?_assert(replicate([{a, "b"}, {c, 1054}, {k, 16}], 2) =:= [{a,"b"},{a,"b"},{c,1054},{c,1054},{k,16},{k,16}]),		
		?_assert(replicate([<<44>>,"A",<<32>>], 3) =:= [<<",">>,<<",">>,<<",">>,"A","A","A",<<" ">>,<<" ">>, <<" ">>]),
		?_assert(replicate([1,1,1243,2,3,3,4], 2) =:= [1,1,1,1,1243,1243,2,2,3,3,3,3,4,4]),
		?_assert(replicate("ssstring", 3) =:= "ssssssssstttrrriiinnnggg"),
		?_assert(replicate("ssstring", 0) =:= [])
	].

