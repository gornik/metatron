-module(metatron_server).
-behavior(gen_server).
-export([start_link/0, run_game/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, []}.

run_game() ->
    gen_server:call(?MODULE, run_game).

% gen_server callbacks
handle_call(run_game, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsc, State, _Extra) ->
    {ok, State}.
