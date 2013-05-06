-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-module(metatron_board_tests).

new_board_contains_empty_cells_test() ->
    Board = metatron_board:create(10, 10),
    ?assertEqual(empty, metatron_board:get(1, 1, Board)).

new_board_sets_sizes_in_correct_order_test() ->
    Board = metatron_board:create(10, 1),
    ?assertEqual(empty, metatron_board:get(9, 0, Board)).

set_function_uses_correct_indices_test() ->
    Board = metatron_board:create(10, 1),
    NewBoard = metatron_board:set(9, 0, wall, Board),
    io:write(NewBoard),
    ?assertEqual(wall, metatron_board:get(9, 0, NewBoard)).

-endif.
