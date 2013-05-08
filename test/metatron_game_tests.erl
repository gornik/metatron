-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-module(metatron_game_tests).

create_game_creates_game_with_no_clients_test() ->
    Game = metatron_game:create(),
    ?assertEqual({game, []}, Game).
-endif.
