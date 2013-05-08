-module(metatron_game).

-export([create/0]).

-record(game, {clients = []}).

create() ->
    #game{}.
