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
decode([{N,X} | L], Acc, 1)->
	decode([X], decode(L, Acc, 1), N) ;
decode([Lel], Acc, C) ->
	decode([Lel], [Lel | Acc], C-1).