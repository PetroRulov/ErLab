-module(p02).
-export([but_last/1]).

%% Найти два последних элемента списка:

but_last(L=[_|[_]]) ->
	L;
but_last([_|T]) ->
	but_last(T). %-tail recursion
