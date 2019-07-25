-module(bs03).
-export([split/2, split_coach/2]).

%%BS03: Разделить строку на части, с явным указанием разделителя:
%%Пример:
%%1> BinText = <<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>.
%%<<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>
%%2> bs03:split(BinText, "-:-").
%%[<<"Col1">>, <<"Col2">>, <<"Col3">>, <<"Col4">>, <<"Col5">>]

split(BinText, Sep) ->
    split(BinText, Sep, 0, 0, []).


split(BinText, Sep, Idx, LastSplit, Acc) ->
	Len = Idx - LastSplit,
	BinSep = list_to_binary(Sep),
	SepSize = byte_size(BinSep),
	case BinText of
		<<_:LastSplit/binary, CurrentTerm:Len/binary, Char, _/binary>> ->
		case lists:member(Char, Sep) of
			false ->
                split(BinText, Sep, Idx+1, LastSplit, Acc);
            true ->
            	case is_separ(BinText, Sep, Idx, LastSplit) of
            		false ->
                		split(BinText, Sep, Idx+1, LastSplit, Acc);
                	true ->
                		case CurrentTerm == <<>> of
                			false ->
                				split(BinText, Sep, Idx+SepSize, Idx+SepSize, [CurrentTerm | Acc]);
                			true ->
                				split(BinText, Sep, Idx+SepSize, Idx+SepSize, Acc)
                		end
                end
        end;
		<<_:LastSplit/binary, CurrentTerm:Len/binary>> ->
            lists:reverse([CurrentTerm | Acc]);
        _ ->
            lists:reverse(Acc)
    end.

is_separ(BinText, Sep, Idx, LastSplit)->
	Len = Idx - LastSplit,
	BinSep = list_to_binary(Sep),
	SepSize = byte_size(BinSep),
	<<_:LastSplit/binary, _CurrentTerm:Len/binary, Splitter:SepSize/binary, _/binary>> = BinText,
	Splitter == BinSep.

split_coach(BinText, Sep)->
    BinSep = list_to_binary(Sep),
    Size = byte_size(BinSep),
    split_coach(BinText, BinSep, Size, <<>>, []).

split_coach(Bin, Sep, Size, Word, Acc) ->
    case Bin of
        <<SepSize/binary, Rest/binary>> ->
            split_coach(Rest, Sep, Size, <<>>, [Word | Acc]);
        <<C/utf8, Rest/binary>> ->
            split_coach(Rest, Sep, Size, <<Word/binary, C/utf8>>, Acc);
        <<>> ->
            lists:reverse([Word | Acc])
    end.

