-module(metatron_game_board_sup).

-behavior(supervisor).
-export([start_link/2]).
-export([init/1]).

-define(CELL(Row, Col),
    {integer_to_list(Row) ++ "_" ++  integer_to_list(Col), 
        { metatron_board_cell, start_link, [Row, Col]},
            transient, brutal_kill, worker, [metatron_board_cell]}
).
        
start_link(Height, Width) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Height, Width]).

init([Height, Width]) ->
    Cells = [?CELL(Row, Col) || 
        Row <- lists:seq(1, Height), 
        Col <- lists:seq(1, Width)],
    {ok, { {one_for_one, 5, 10}, Cells}}.

