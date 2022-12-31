/**
 * menu(+Lines, +Actions)
 * 
 * Shows a menu with
 */
menu(Lines, Actions) :-
    clear,
    write_framed(Lines),
    nl, write_str("Choose option: "),
    length(Actions, Len),
    read_number_until(between(0, Len), Choice),
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
], [fail, play_menu, instructions_menu]).

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
