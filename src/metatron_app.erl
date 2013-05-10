-module(metatron_app).

-behaviour(application).

-export([start/0, start/2, stop/1]).

start() ->
    start(metatron).

start(App) ->
    case application:start(App) of
        ok -> ok;
        {error, {not_started, Dependency}} ->
            start(Dependency),
            start(App)
    end.

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", metatron_toppage_handler, []},
            {"/websocket", metatron_ws_handler, []},
            {"/static/[...]", cowboy_static, [
                {directory, {priv_dir, websocket, [<<"static">>]}},
                {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            ]}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 7777}],
        [{env, [{dispatch, Dispatch}]}]),
    metatron_sup:start_link().

stop(_State) ->
    ok.
