-module(p04).
-export([len/1, lentc/1]).

%% Посчитать количество элементов списка:

len([_|T]) ->
	1 + len(T); %-regular recursion
len([]) ->
	0.

lentc(L)->
	lentc(L, 0).

lentc([], Acc)->
	Acc;
lentc([_|Xs], Acc)->
	lentc(Xs, Acc+1). %-tail recursion


