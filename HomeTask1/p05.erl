-module(p05).
-export([reverse/1, reverserr/1]).

%% Перевернуть список:

reverse([]) ->
	[];
reverse(L) ->
	aux(L, []).

aux([H|T], Acc) ->
	aux(T, [H|Acc]); %-tail recursion
aux([], Acc) ->
	Acc.

reverserr([X|Xs])->
	reverserr(Xs) ++ [X]; %-regular recursion
reverserr([])->
	[].


