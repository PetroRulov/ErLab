-module(p10).
-export([encode/1]).

%% (**) Закодировать список с использованием алгоритма RLE:
%% RLE - Run Length Encoded
%1> p10:encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e]).
%[{4,a},{1,b},{2,c},{2,a},{1,d},{4,e}]

encode([])->
	[];
encode(L)->
	encode(L, [], 1).

encode([], Acc, _)->
	Acc;
encode([Lel], _, N)->
	[{N, Lel} | []];
encode([X|L=[X|_]], [], N)->
	encode(L, X, N + 1);
encode([X|L=[Y|_]], [], _)->
	[{1, X} | encode(L, [{1, Y}], 1)];
encode([X|L=[X|_]], _Acc, N)->
	encode(L, [{N+1, X}], N + 1);
encode([X|L=[Y|_]], _Acc, N)->
	[{N, X} | encode(L, [{1, Y}], 1)].