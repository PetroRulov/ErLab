-module(bs01).
-export([first_word/1]).

%%BS01: Извлечь из строки первое слово:
%%1> BinText = <<"Some text">>.
%%2> bs01:first_word(BinText).

first_word(<<>>) ->
	<<>>;
first_word(BinText)->
	first_word(BinText, <<>>).

first_word(<<32, Rest/binary>>, <<>>) ->
	first_word(Rest, <<>>);
first_word(<<32, _/binary>>, Acc) ->
	Acc;
first_word(<<FW/utf8, Rest/binary>>, Acc) ->
	first_word(Rest, <<Acc/binary, FW/utf8>>);
first_word(<<>>, Acc)->
	Acc.