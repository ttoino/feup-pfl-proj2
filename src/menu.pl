/**
 * menu(+Lines, +Actions)
 * 
 * Shows a menu with the given Lines on which the given Actions can be performed.
 */
menu(Lines, Actions) :-
    clear,
    write_framed(Lines),
    length(Actions, Len),
    Max is Len - 1,
    read_number_until('Choose option: ', between(0, Max), Choice),
    nth0(Choice, Actions, Action),
    call(Action).

/**
 * main_menu/0
 * 
 * Shows the game's main menu.
 */
main_menu :- repeat, menu([
    " ███  █████ █   █ █████ █████ ████ ",
    "█   █ █     ██  █   █   █     █   █",
    "█     ████  █ █ █   █   ████  ████ ",
    "█   █ █     █  ██   █   █     █   █",
    " ███  █████ █   █   █   █████ █   █",
    "",
    "1        Play        ",
    "2  Join online game  ",
    "3    Instructions    ",
    "",
    "0        Exit        "
], [!, play_menu, join_menu, instructions_menu]).

/**
 * instructions_menu/0
 *
 * Shows the instructions to the game.
 */
instructions_menu :- menu([
    "Instructions",
    "",
    "Center is a 1v1 board game played on an NxN board, where N is an odd ",
    "number, between 5 and 15. The players take turns placing their pieces",
    "anywhere on the board, but with a restriction: the piece must see at ",
    "least as many pieces of the same color as there are cells separating ",
    "it from the edge of the board. The objective is to place your piece  ",
    "in the center of the board.                                          ",
    "",
    "0  Go back  "
], [fail]).

/**
 * player_type/2
 *
 * Associates a player type to a letter to be written in the play_menu.
 */
player_type(human, "P").
player_type(online, "O").
player_type(easy, "E").
player_type(medium, "M").
player_type(hard, "H").

/**
 * play_menu/0
 *
 * Shows the game setup menu
 */
play_menu :-
    read_number_until('Choose board size (odd number between 5 and 15): ', valid_board_size, Size),
    write('Choose players\nP for human player, O for online player, E for easy bot, M for medium bot, H for hard bot'), nl,
    read_str_until('White: ', player_type(White), _),
    read_str_until('Black: ', player_type(Black), _),

    initial_state(Size, GameState),
    open_server(Server),
    wait_for_player(White, Server, WhiteP),
    wait_for_player(Black, Server, BlackP),
    game_cycle(GameState-WhiteP-BlackP),
    socket_server_close(Server), !,
    fail.

join_menu :-
    read_str_until('Enter server address: ', join_server(Stream), _),
    client_loop(Stream).
