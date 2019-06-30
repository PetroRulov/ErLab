-module(p08).
-export([compress/1]).

%% (**) Удалить последовательно следующие дубликаты:
compress([])->
	[];
compress(L)->
	compress(L, []).

compress([], Acc)->
	Acc;
compress([Lel], Acc)->
	[Lel|Acc];
compress([X|L=[X|_]], Acc)->
	compress(L, Acc);
compress([X|L=[_Xh|_]], Acc)->
	[X | compress(L, Acc)].

