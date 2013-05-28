-module(metatron_game_server).
-behavior(gen_server).

-export([start_link/1, init/1, handle_call/3, handle_cast/2,
    handle_info/2, terminate/2, code_change/3]).

-export([start_game/3]).

-record(game_options, {height, width, rounds}).
-record(game_state, {supervisor, options = #game_options{}}). 

start_link(Sup) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Sup], []).

init([Sup]) -> {ok, #game_state{supervisor = Sup}}.

start_game(Height, Width, Rounds) ->
    gen_server:cast(?MODULE, {start_game, Height, Width, Rounds}).

% Callbacks
handle_call(_, _From, _State) ->
    {reply, []}.

handle_cast({start_game, Height, Width, Rounds}, State) ->
    NewGameState = State#game_state{
        options = #game_options{height = Height, width = Width, rounds = Rounds}},
    BoardSpec = {metatron_game_board_sup, 
        {metatron_game_board_sup, start_link, [Height, Width]},
            transient, 5000, supervisor, [metatron_game_board_sup]},
    supervisor:start_child(State#game_state.supervisor, BoardSpec),
    {noreply, NewGameState};

handle_cast(_Msg, _State) ->
    {noreply, []}.

handle_info(_Msg, _State) ->
    {noreply, []}.

terminate(_, _State) -> ok.

code_change(_OldVsn, _State, _Extra) ->
    {ok, []}.

