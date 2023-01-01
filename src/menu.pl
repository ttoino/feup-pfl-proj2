/**
 * menu(+Lines, +Actions)
 * 
 * Shows a menu with
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
    "1      Play       ",
    "2  Instructions   ",
    "",
    "0      Exit       "
], [!, play_menu, instructions_menu]).

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

player_type(human, "P").
player_type(easy, "E").
player_type(hard, "H").

play_menu :-
    read_number_until('Choose board size (odd number between 5 and 15): ', valid_board_size, Size),
    write('Choose players (P for human player, E for easy bot, H for hard bot)'), nl,
    read_str_until('White: ', player_type(White), _),
    read_str_until('Black: ', player_type(Black), _),

    initial_state(Size, GameState),
    game_cycle(GameState-White-Black),
    fail.
