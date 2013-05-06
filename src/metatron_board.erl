-module(metatron_board).

-export([create/2, get/3, set/4]).
-record(board, {sizeX = 0, sizeY = 0, cells = []}).

create(SizeX, SizeY) ->
    #board{sizeX = SizeX, sizeY = SizeY, cells = []}.

get(X, Y, Board) ->
    case orddict:find({X, Y}, Board#board.cells) of
        error -> empty;
        {ok, Value} -> Value
    end.

set(X, Y, Value, Board) ->
    Board#board{cells = orddict:store({X, Y}, Value, Board#board.cells)}.
