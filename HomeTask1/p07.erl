-module(p07).
-export([flatten/1]).
-import('p05', [reverse/1]).

%% P07 (**) Выровнять структуру с вложеными списками:
%% Пример:
%% 1> p07:flatten([a,[],[b,[c,d],e],[a,b,[],[k],[c,[d,j,[k,l]]],e]]).
%% [a,b,c,d,e]

flatten([])->
	[];
flatten(L)->
	reverse(flatten(L, [])).

flatten([HL=[_|_]|T], Acc)->
	flatten(T, flatten(HL, Acc));
flatten([[]|T], Acc)->
	flatten(T, Acc);
flatten([H|T], Acc)->
	%L1 = reverse(Acc),
	%L2 = [H|L1],
	%flatten(T, reverse(L2));
	flatten(T, [H|Acc]);
flatten([], Acc) -> 
	Acc.


%flatten([], Acc) ->
%	Acc;
%flatten( [H|T], Acc) -> 
%	flatten( H, flatten(T, Acc));
%flatten(H, Acc) -> 
%	[H|Acc];
%flatten([], Acc) ->
%	Acc.