-module(p07).
-export([flatten/1]).

%% P07 (**) Выровнять структуру с вложеными списками:
%% Пример:
%% 1> p07:flatten([a,[],[b,[c,d],e],[a,b,[],[k],[c,[d,j,[k,l]]],e]]).
%% [a,b,c,d,e]

flatten([])->
	[];
flatten(L)->
	flatten(L, []).

flatten([H|T], Acc) -> 
	flatten(H, flatten(T, Acc));
flatten([], Acc) ->
	Acc;
flatten(H, Acc) -> 
	[H|Acc].
