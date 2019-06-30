-module(p06).
-export([is_palindrome/1]).
-import('p05', [reverse/1]).

%% Определить, является ли список палиндромом:
is_palindrome(L)->
	%L == p05:reverse(L).
	L == reverse(L).
