-module(metatron_ws_handler).

-behaviour(cowboy_websocket_handler).

-export([init/3, websocket_init/3, websocket_handle/3, websocket_info/3,
    websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
    {ok, Req, undefined_state}.

websocket_handle({text, Msg}, Req, State) ->
    Json = jsx:decode(Msg),
    Response = handle_json_command(Json),
    {reply, {text, Response}, Req, State};

websocket_handle(_Data, Req, State) ->
    {reply, {text, <<"Unknown command">>}, Req, State}.

websocket_info(_Info, Req, State) ->
    {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.

%% @TODO validate input
handle_json_command([{ <<"start_game">>, Options }]) ->
    OptionsDict = dict:from_list(Options),    
    metatron_game_server:start_game(
        dict:fetch(<<"height">>, OptionsDict),
        dict:fetch(<<"width">>, OptionsDict),
        dict:fetch(<<"rounds">>, OptionsDict)),
    <<"Game started">>;

handle_json_command(_) ->
    <<"Unrecognized command">>.

