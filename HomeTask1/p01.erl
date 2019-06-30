-module(p01).
-export([last/1]).

%% Найти последний элемент списка:

last([Lel]) ->
	Lel;
last([_|Xs]) ->
	last(Xs). %-tail recursion
