-include_lib("eunit/include/eunit.hrl").
-module(p07_tests).
-import('p07', [flatten/1]).

flatten_test_() ->
	[
		
		?_assert(flatten(atom) =:= [atom]),
		?_assert(flatten({1,2,3,4}) =:= [{1,2,3,4}]),
		?_assert(flatten(<<116,114,117,101>>) =:= [<<116,114,117,101>>]),
		?_assert(flatten(#{age => 1054,name => "Santa",sex => male}) =:= [#{age => 1054,name => "Santa",sex => male}]),
		?_assert(flatten(5) =:= [5]),
		?_assert(flatten([{a, "b"}, {c, 1054}, {k, 16}]) =:= [{a, "b"}, {c, 1054}, {k, 16}]),
		?_assert(flatten([]) =:= []),
		?_assert(flatten([1]) =:= [1]),
		?_assert(flatten([a,[],[b,[c,d],e],[a,b,[],[k],[c,[d,j,[k,l]]],e]]) =:= [a,b,c,d,e,a,b,k,c,d,j,k,l,e]),
		?_assert(flatten([a, [b, c, [d, e, f, [g, h, [k, l, [m, n, [o, p, r, [q, [s]]]]]]]]]) =:= [a,b,c,d,e,f,g,h,k,l,m,n,o,p,r,q,s]),
		?_assert(flatten([a,{b,c,{d,e,f,{g,h,{k,l,{m,n,{o,p,r,{q,{s}}}}}}}}]) =:=[a,{b,c,{d,e,f,{g,h,{k,l,{m,n,{o,p,r,{q,{s}}}}}}}}]),
		?_assert(flatten([1, [2, 3, 4, {a, true, {c, 16}}, 45]]) =:= [1, 2, 3, 4, {a, true, {c, 16}}, 45])
	].

