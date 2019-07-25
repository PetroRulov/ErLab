-module(p09).
-export([pack/1]).

%% (**) Запаковать последовательно следующие дубликаты во вложеные списки:
%%1> p09:pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e]).
%%[[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]

pack([])->
	[];
pack(L)->
	pack(L, [], []).

pack([X|Xs], [], Acc) -> 
	pack(Xs, [X], Acc);
pack([X|Xs], [X|L], Acc) -> 
	pack(Xs, subpack(X, L), Acc);
pack([X|Xs], [Y|L], Acc) -> 
	pack(Xs, [X], subpack(Y, L, Acc));
pack([], Y, Acc) -> 
	lists:reverse(subpack([], Y, Acc)).

subpack(X, L)->
	[X| [X|L]]. 

subpack([], L, Acc)->
	[L| Acc];
subpack(Y, L, Acc)->
	[[Y|L]| Acc].
