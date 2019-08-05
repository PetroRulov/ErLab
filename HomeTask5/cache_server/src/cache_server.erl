-module(cache_server).

-export([start_link/3]).
-export([stop/1]).

-export([process_init/3]).

-export([call/2]).
-export([cast/2]).
-export([info/2]).

-record(state, {handler, handler_state}).

-callback init(any(), tuple()) -> {ok, tuple()}.
-callback handle_call(any(), any(), tuple()) -> {ok, any(), tuple()}.
-callback handle_cast(any(), tuple()) -> {ok, tuple()}.
-callback handle_info(any(), tuple()) -> {noreply, tuple()}.

%% c(cache_server).
%% cache_server:start_link(cache_server_handler, passwords, {drop_interval, 15}).

%% INSERT
%% cache_server:cast(cache_server, {insert, {passwords, ivanov, "Russ8a_Vpered", 60}}).
%% cache_server:cast(cache_server, {insert, {passwords, prihodko, "Ukraine@9_ponaduse", 180}}).
%% cache_server:cast(cache_server, {insert, {passwords, roizman, "taki!Goi?", 90}}).
%% ets:tab2list(passwords).

%% LOOKUP
%% cache_server:call(cache_server, {lookup, {passwords, ivanov}}).
%% cache_server:call(cache_server, {lookup, {passwords, prihodko}}).
%% cache_server:call(cache_server, {lookup, {passwords, roizman}}).

%% LOOKUP_BY_DATE
%% cache_server:call(cache_server, {lookup_by_date, {passwords, {{2019, 8, 2},{13, 16, 0}}, {{2019, 8, 2}, {13, 16, 24}}}}).

%% STOP
%% cache_server:stop(cache_server).

%% DELETE_OBSOLETE
%% cache_server:info(cache_server, {delete_obsolete, {passwords, 120}}).

-spec start_link(any(), any(), tuple()) -> {ok, pid()}.
start_link(Module, TableName, {drop_interval, Time}) ->
	State = #state{handler = Module},
	DropInterval = Time * 1000,
	%DropInterval = Time,
	register(cache_server, spawn_link(?MODULE, process_init, [State, TableName, {drop_interval, DropInterval}])),
	{ok, whereis(cache_server), self()}.

process_init(State = #state{handler = Module}, TableName, {drop_interval, DropInterval}) ->
	{ok, HandlerState} = Module:init(TableName, {drop_interval, DropInterval}),
	process_loop(State#state{handler_state = HandlerState}).

stop(Pid) ->
	Pid ! stop.

call(Name, Msg)->
	_ = Name ! {call, self(), Msg},
	receive
		{result, Result} ->
			Result
	after 5000 -> no_reply
	end.

cast(Name, Msg)->
	_ = Name ! {cast, Msg},
	ok.

info(Name, Msg)->
	_ = Name ! {info, Msg},
	ok.

% internal function
process_loop(State = #state{handler = Module, handler_state = HandlerState}) ->
	receive
		{call, From, Msg} ->
			{ok, Result, HandlerState2} = Module:handle_call(Msg, From, HandlerState),
			_ = From ! {result, Result},
			process_loop(State#state{handler_state = HandlerState2});
		{cast, Msg} ->
			{ok, HandlerState2} = Module:handle_cast(Msg, HandlerState),
			process_loop(State#state{handler_state = HandlerState2});
		{info, Msg} ->
			{noreply, HandlerState2} = Module:handle_info(Msg, HandlerState),
			process_loop(State#state{handler_state = HandlerState2});
		stop->
			ok
	end.
