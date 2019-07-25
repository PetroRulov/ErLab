-module(bs04).
-export([decode/2]).

%% bs04:decode(Json, proplist).
%% Test = <<"{'girl': 'Rada Gaal', 'boy': 'Guy Gaal', 'active': 'true', 'formed': '2011', 'members': [{'name': 'Spider Man', 'age': '29', 'powers': ['abc def', 'ghk lmn', 'opq rs']}, {'name': 'Super Belka', 'age': '39', 'powers': ['tu wz', 'xyz']}]}">>.
%% bs04:decode(Test, proplist).
%% Json = <<"{'squadName': 'Super hero squad', 'homeTown': 'Metro City', 'formed': '2016', 'secretBase': 'Super tower', 'active': 'true', 'members': [{'name': 'Molecule Man', 'age': '29', 'secretIdentity': 'Dan Jukes', 'powers': ['Radiation resistance', 'Turning tiny', 'Radiation blast']}, {'name': 'Madame Uppercut', 'age': '39', 'secretIdentity': 'Jane Wilson', 'powers': ['Million tonne punch', 'Damage resistance', 'Superhuman reflexes']}, {'name': 'Eternal Flame', 'age': '1000000', 'secretIdentity': 'Unknown', 'powers': ['Immortality', 'Heat Immunity', 'Inferno', 'Teleportation', 'Interdimensional travel']}]}">>.
%% bs04:decode(Json, proplist).


decode(Json, proplist)->
	parser(Json, [], [], []).

parser(Bin = <<C/utf8, Rest/binary>>, Aux, Parts, Result) ->
	if C /= 123 ->	%"{"
		case C of 
			39 ->	%"'"
				parser(get_rest(Rest, 39), [get_word(Rest, 39)|Aux], Parts, Result);
			91 ->	%"["							
				parser(Rest, [C|Aux], Parts, Result);
			58 ->	%":"
				parser(Rest, [C|Aux], Parts, Result);
			44 ->	%","
				parser(Rest, Aux, Parts, Result);
			32 ->	%" "
				parser(Rest, Aux, Parts, Result);
			93 ->	%"]"
				parser(Rest, rest(Aux, <<91>>), [<<"]">>| extract(Aux, <<91>>)] ++ [<<"[">>|Parts], Result);
			125 ->	%"}" 
				parser(Rest, rest(Aux, <<123>>), [<<"}">>| extract(Aux, <<123>>)] ++ [<<"{">>|Parts], Result);
			_ ->
				parser(get_rest(Rest, 44), [bin_to_term(Bin)|Aux], Parts, Result)
		end;
	true -> 
		aux([C|Aux]),
		parser(Rest, [C|Aux], Parts, Result)
	end;
parser(<<>>, [], [], Result) ->
	Result;
parser(<<>>, [], Parts, Result) ->
	Parts ++ Result.


aux([H|T]) ->
	io:format("~p~n", [H]),
	aux(T);
aux([])->
	io:format("~p~n", ["The end!"]),
	io:format("~p~n", ["\n"]).

get_word(Bin, Sep) ->
	get_word(Bin, Sep, <<>>).
get_word(<<C/utf8, Rest/binary>>, Sep, Acc) ->
	case C of
		Sep -> Acc;
		_ -> get_word(Rest, Sep, <<Acc/binary, C/utf8>>)
	end;
get_word(<<>>, _, Acc) ->
	Acc.

get_rest(Bin, Sep) ->
	get_rest(Bin, Sep, <<>>).
get_rest(<<C/utf8, Rest/binary>>, Sep, Acc) ->
	case C of
		Sep -> Rest;
		_ -> get_rest(Rest, Sep, <<Acc/binary, C/utf8>>)
	end;
get_rest(<<>>, _, Acc) ->
	Acc.

extract(List, Sep) ->
	extract(List, Sep, []).
extract([H|_], H, Acc) ->
	lists:reverse(Acc);
extract([H|T], Sep, Acc) ->
	extract(T, Sep, [H|Acc]);
extract([], _, Acc) ->
	lists:reverse(Acc).

rest(List, Sep) ->
	rest(List, Sep, []).
rest([H|T], H, _) ->
	T;
rest([_H|T], Sep, Acc) ->
	rest(T, Sep, Acc);
rest([], _, Acc) ->
	Acc.

bin_to_term(Bin) ->
	BinTerm = get_word(Bin, 44),
		case binary_become_integer(BinTerm) of
			true ->
				binary_to_integer(BinTerm);
			false ->
				Result = try
					binary_to_existing_atom(BinTerm, utf8)
				catch
					error: badarg -> 
                 		{error, not_atom_or_number}
				end
		end.

binary_become_integer(<<>>) ->
    true;
binary_become_integer(<<C/utf8, Rest/binary>>) -> 
    ((C > 47) and (C < 58)) and binary_become_integer(Rest).