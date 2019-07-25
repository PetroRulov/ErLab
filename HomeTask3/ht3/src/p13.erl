-module(p13).
-export([decode/1]).

%% (**) Написать декодер для стандартного алгоритма RLE:
%% RLE - Run Length Encoded
%%1> p13:decode([{4,a},{1,b},{2,c},{2,a},{1,d},{4,e}]).
%%[a,a,a,a,b,c,c,a,a,d,e,e,e,e]

decode([])->
	[];
decode(L)->
	decode(L, [], 1).

decode([], Acc, _)->
	Acc;
decode(_, Acc, 0)->
	Acc;
decode([{1,X} | L], Acc, _)->
	[ X| decode(L, Acc, 1) ];
decode([{N,X} | L], Acc, _)->
	[ X| decode([{N-1, X}| L], Acc, 1)];
decode([Lel], Acc, N) ->
	decode([Lel], [Lel | Acc], N-1).