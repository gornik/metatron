%%%-------------------------------------------------------------------
%%% @doc Metatron game server.
%%% 
%%% Main game server responsible for starting and stoping games.
%%% @end
%%%-------------------------------------------------------------------

-module(metatron_game_server).

-behavior(gen_server).

%% Public API
-export([
         start_link/0,
         sync_msg/1,
         async_msg/1,
         start_game/3
        ]).

%% gen_server callbacks
-export([
         init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3
        ]).

-define(SERVER, ?MODULE).

-record(game_options, {height, width, rounds}).
-record(game_state, {supervisor, options = #game_options{}}). 

%% ===================================================================
%% Public API
%% ===================================================================

%% @doc Starts the server
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% @doc Tests sync calls
sync_msg(Msg) ->
    gen_server:call(?SERVER, {test, Msg}).

%% @doc Tests async calls
async_msg(Msg) ->
    gen_server:cast(?SERVER, {test, Msg}).

%% @doc Starts a new game with specified parameters.
start_game(Height, Width, Rounds) ->
    gen_server:cast(?MODULE, {start_game, Height, Width, Rounds}).

%% ===================================================================
%% gen_server callbacks
%% ===================================================================

%% @private
%% @doc Server init
init([Sup]) -> {ok, #game_state{supervisor = Sup}}.

%% @private
%% @doc Handles call messages
handle_call(_, _From, _State) ->
    {noreply, _State}.

%% @private
%% @doc Handles cast messages
handle_cast({start_game, Height, Width, Rounds}, State) ->
    NewGameState = State#game_state{
        options = #game_options{height = Height, width = Width, rounds = Rounds}},
    BoardSpec = {metatron_game_board_sup, 
        {metatron_game_board_sup, start_link, [Height, Width]},
            transient, 5000, supervisor, [metatron_game_board_sup]},
    {ok, _} = supervisor:start_child(State#game_state.supervisor, BoardSpec),
    {noreply, NewGameState};
handle_cast(_Msg, _State) ->
    {noreply, []}.

%% @private
%% @doc Handles all non call/cast messages
handle_info(_Msg, _State) ->
    {noreply, []}.

%% @private
%% @doc It is called when the server is going to terminate
terminate(_, _State) -> ok.

%% @private
%% @doc Converts process state when code is changed
code_change(_OldVsn, _State, _Extra) ->
    {ok, []}.

