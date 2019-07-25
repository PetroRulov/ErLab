-module(bs02).
-export([words/1]).

%%BS02: Разделить строку на слова:
%%Пример:
%%1> BinText = <<"Text with four words">>.
%%<<"Text with four words">>
%%2> bs02:words(BinText).
%%[<<"Text">>, <<"with">>, <<"four">>, <<"words">>]

words(BinText) when is_binary(BinText) ->
    words(BinText, <<>>, []).

words(<<$ :8, Rest/binary>>, <<>>, Acc) -> %% Buffer is empty, binary is NOT empty
    words(Rest, <<>>, Acc);
words(<<$ :8, Rest/binary>>, Buffer, Acc) -> %% Buffer is NOT empty, binary is NOT empty
    words(Rest, <<>>, [Buffer|Acc]);
words(<<Char:8, Rest/binary>>, Buffer, Acc) -> %% one char (not a space)
    words(Rest, <<Buffer/binary, Char>>, Acc);
words(<<>>, <<>>, Acc) -> %% Buffer IS empty, binary IS empty
    lists:reverse(Acc);
words(<<>>, Buffer, Acc) -> %% Buffer is NOT empty, binary IS empty
    lists:reverse([Buffer|Acc]).

