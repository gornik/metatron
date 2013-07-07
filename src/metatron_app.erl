%%%-------------------------------------------------------------------
%%% @doc Metatron - main application module
%%%
%%% This is the starting module for the Metatron application.
%%% @end
%%%-------------------------------------------------------------------

-module(metatron_app).

-behaviour(application).

%% application callbacks
-export([
         start/2,
         stop/1
        ]).

%% external API
-export([start/0]).


%% ===================================================================
%% application callbacks
%% ===================================================================

%% @private
%% @doc Configures cowboy routes, starts main application supervisor.
start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", metatron_toppage_handler, []},
            {"/websocket", metatron_ws_handler, []},
            {"/static/[...]", cowboy_static, [
                {directory, {priv_dir, metatron_app, [<<"static">>]}},
                {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            ]}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 7777}],
        [{env, [{dispatch, Dispatch}]}]),
    metatron_sup:start_link().

%% @private
%% @doc Stops the application.
stop(_State) ->
    ok.


%% ===================================================================
%% external API
%% ===================================================================

%% @doc Starts the Metatron application and all necessary dependecies.
-spec start() -> ok.
start() ->
    start(metatron).

%% @private
start(App) ->
    case application:start(App) of
        ok -> ok;
        {error, {not_started, Dependency}} ->
            start(Dependency),
            start(App)
    end.


