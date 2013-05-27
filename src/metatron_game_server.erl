-module(metatron_game_server).
-behavior(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2,
    handle_info/2, terminate/2, code_change/3]).

-export([start_game/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) -> {ok, []}.

start_game(Height, Width, Rounds) ->
    gen_server:cast(?MODULE, {start_game, Height, Width, Rounds}).

% Callbacks
handle_call(_, _From, _State) ->
    {reply, []}.

handle_cast({start_game, Height, Width, Rounds}, State) ->
    {noreply, State};

handle_cast(_Msg, _State) ->
    {noreply, []}.

handle_info(_Msg, _State) ->
    {noreply, []}.

terminate(_, _State) -> ok.

code_change(_OldVsn, _State, _Extra) ->
    {ok, []}.
