-module(p14).
-export([duplicate/1]).

%% (*) Написать дубликатор всех элементов входящего списка:
%%1> p14:duplicate([a,b,c,c,d]).
%%[a,a,b,b,c,c,c,c,d,d]

duplicate([])->
	[];
duplicate([H|T])->
	[H, H|duplicate(T)].