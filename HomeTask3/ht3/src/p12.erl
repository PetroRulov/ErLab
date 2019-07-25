-module(p12).
-export([decode_modified/1]).

%% (**) Написать декодер для модифицированого алгоритма RLE:
%% RLE - Run Length Encoded
%1> p12:decode_modified([{4,a},b,{2,c},{2,a},d,{4,e}]).
%[a,a,a,a,b,c,c,a,a,d,e,e,e,e]

decode_modified([])->
	[];
decode_modified(L)->
	decode_modified(L, [], 1).

decode_modified([], Acc, _)->
	Acc;
decode_modified(_, Acc, 0)->
	Acc;
decode_modified([{N,X} | L], Acc, 1)->
	decode_modified([X], decode_modified(L, Acc, 1), N);
decode_modified([X | L], Acc, 1)->
	[X | decode_modified(L, Acc, 1)];
decode_modified([Lel], Acc, C) ->
	decode_modified([Lel], [Lel | Acc], C-1).

