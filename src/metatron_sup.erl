%%%-------------------------------------------------------------------
%%% @doc Main Metatron application supervisor.
%%%
%%% The main application supervisor, responsible for supervising the
%%% game server.
%%% @see metatron_game_server.
%%% @end
%%%-------------------------------------------------------------------

-module(metatron_sup).

-behaviour(supervisor).

%% external API
-export([start_link/0]).

%% supervisor callbacks
-export([init/1]).


%% ===================================================================
%% Public API
%% ===================================================================

%% @doc Start the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


%% ===================================================================
%% supervisor callbacks
%% ===================================================================

%% @private
%% @doc Supervisor init function.
init([]) ->
    ChildProcess = {metatron_game_server, {metatron_game_server, start_link, []},
        permanent, 5000, worker, [metatron_game_server]},
    Children = [ChildProcess],
    RestartStrategy = {one_for_one, 5, 10},
    {ok, {RestartStrategy, Children}}.

