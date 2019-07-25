-module(ht2_tests).
-include_lib("eunit/include/eunit.hrl").
-import('bs01', [first_word/1]).
-import('bs02', [words/1]).
-import('bs03', [split/2]).

first_word_test_() ->
	[
		?_assertEqual(<<>>, first_word(<<>>)),
		?_assertEqual(<<58>>, first_word(<<58>>)),
		?_assertEqual(<<>>, first_word(<<" ">>)),
		?_assertEqual(<<>>, first_word(<<"  ">>)),
		?_assertEqual(<<>>, first_word(<<"     ">>)),
		?_assertEqual(<<"Some">>, first_word(<<"Some text">>)),
		?_assertEqual(<<"Some">>, first_word(<<" Some text">>)),
		?_assertEqual(<<"Some">>, first_word(<<"  Some text">>)),
		?_assertEqual(<<"Some">>, first_word(<<"     Some text">>)),
		?_assertEqual(<<49,50>>, first_word(<<49,50,32,58,32,116>>)),
		?_assertEqual(<<49,50>>, first_word(<<32,49,50,32,58,32,116>>)),
		?_assertEqual(<<49>>, first_word(<<32,49,32,50,32,58,32,116>>)),
		?_assertEqual(<<49>>, first_word(<<49,32,50,32,58,32,116>>))
	].

words_test_() ->
	[
		?_assertEqual([], words(<<>>)),
		?_assertEqual([], words(<<" ">>)),
		?_assertEqual([], words(<<32,32,32>>)),
		?_assertEqual([<<116,114,117,101>>], words(<<32,32,32,116,114,117,101>>)),
		?_assertEqual([<<116,114,117,101>>], words(<<32,32,32,116,114,117,101,32>>)),
		?_assertEqual([<<116>>], words(<<116>>)),
		?_assertEqual([<<116,116>>], words(<<116,116>>)),
		?_assertEqual([<<116>>, <<116>>], words(<<116,32,116>>)),
		?_assertEqual([<<116>>, <<116>>], words(<<116,32,116,32>>)),
		?_assertEqual([<<116>>], words(<<32,116,32>>)),
		?_assertEqual([<<116>>, <<116>>], words(<<32,116,32,116>>)),
		?_assertEqual([<<116>>], words(<<32,32,32,32,32,116,32,32,32,32,32>>)),
		?_assertEqual([<<"Text">>, <<"with">>, <<"four">>, <<"words">>], words(<<"Text with four words">>)),
		?_assertEqual([<<"Text">>, <<"with">>, <<"four">>, <<"words">>], words(<<"Text with four words     ">>)),
		?_assertEqual([<<"Text">>, <<"with">>, <<"four">>, <<"words">>], words(<<" Text    with   four words">>)),
		?_assertEqual([<<"Text">>, <<"with">>, <<"|">>, <<"four">>, <<"words">>], words(<<" Text    with |  four words">>)),
		?_assertEqual([<<"Text">>, <<"with,">>, <<"|">>, <<"four">>, <<"words">>], words(<<" Text    with, |  four words">>))
	].

split_test_() ->
	[
		?_assertEqual([<<>>], split(<<>>, "")),
		?_assertEqual([<<>>], split(<<>>, "-:-")),
		?_assertEqual([<<" ">>], split(<<" ">>, "")),
		?_assertEqual([<<"   ">>], split(<<32,32,32>>, "")),
		?_assertEqual([<<32,32,32,116,114,117,101>>], split(<<32,32,32,116,114,117,101>>, "")),
		?_assertEqual([<<116,114>>,<<117,101>>], split(<<116,114,45,58,45,117,101>>, "-:-")),
		?_assertEqual([<<"tr-:-ue">>], split(<<116,114,45,58,45,117,101>>, "--")),
		?_assertEqual([<<>>], split(<<45,58,45,45,58,45,45,58,45,45,58,45,45,58,45>>, "-:-")),
		?_assertEqual([<<"true, false">>,<<>>], split(<<116,114,117,101,44,32,102,97,108,115,101,45,58,45>>, "-:-")),
		?_assertEqual([<<"true, false">>], split(<<45,58,45,116,114,117,101,44,32,102,97,108,115,101>>, "-:-")),
		?_assertEqual([<<"Col1">>,<<"Col2">>,<<"Col3">>,<<"Col4">>,<<"Col5">>], split(<<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>, "-:-")),
		?_assertEqual([<<"Text">>, <<"with">>, <<"four">>, <<"words">>], split(<<"Text with four words">>, " "))
	].

