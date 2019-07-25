-module(p11).
-export([encode_modified/1]).

%% (**) Закодировать список с использованием модифицированого алгоритма RLE:
%% (RLE - Run Length Encoded)
%%1> p11:encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e]).
%%[{4,a},b,{2,c},{2,a},d,{4,e}]

encode_modified([])->
	[];
encode_modified(L)->
	encode(L, [], 1).

encode([], Acc, _)->
	Acc;
encode([Lel], [], _)->
	[Lel | []]; % one element
encode([Lel], _, 1)->
	[Lel | []]; % last one element
encode([Lel], _, N)->
	[{N, Lel} | []]; % last element
encode([X|L=[X|_]], [], N)->
	encode(L, X, N + 1);
encode([X|L=[Y|_]], [], _)->
	[X | encode(L, Y, 1)];
encode([X|L=[X|_]], _Acc, N)->
	encode(L, [{N+1, X}], N + 1);
encode([X|L=[Y|_]], _Acc, 1)->
	[X | encode(L, [{1, Y}], 1)];
encode([X|L=[Y|_]], _Acc, N)->
	[{N, X} | encode(L, [{1, Y}], 1)].