-module(metatron_board_cell).
-behaviour(gen_fsm).

-export([start_link/2, init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

start_link(Row, Col) -> 
    gen_fsm:start_link(?MODULE, [Row, Col], []).

init([_Row, _Col]) -> 
    {ok, free, [], hibernate}.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    {reply, ok, StateName, State}.

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) -> ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.
