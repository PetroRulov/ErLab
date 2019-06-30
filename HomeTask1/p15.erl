-module(p15).
-export([replicate/2]).

%%(**) Написать функцию-репликатор всех элементов входящего списка:
%%1> p15:replicate([a,b,c], 3).
%%[a,a,a,b,b,b,c,c,c]

replicate([], _)->
	[];
replicate(L, N)->
	replicate(L, N, []).

replicate(_, 0, Acc)->
	Acc;
replicate([El], N, Acc)->
	replicate([El], N-1, [El|Acc]);
replicate([H|T], N, Acc)->
	replicate([H], N, replicate(T, N, Acc)).