-module(p03).
-export([element_at/2]).

%% Найти N-й элемент списка:

element_at([H|_], 1) ->
	H;
element_at([_|T], N) ->
	element_at(T, N - 1); %-tail recursion
element_at([], _) ->
	undefined.

