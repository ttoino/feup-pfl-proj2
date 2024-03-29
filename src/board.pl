/**
 * show_piece(+Piece)
 * 
 * Displays a piece.
 */
show_piece(empty) :- write('   ').
show_piece(white) :- write(' ○ ').
show_piece(black) :- write(' ● ').

/**
 * show_columns(+Collumn)
 *
 * Prints the board collums.
 */
show_columns(0) :- !.
show_columns(N) :-
    N1 is N - 1, C is 64 + N,
    show_columns(N1),
    char_code(Char, C),
    write(' '), write(Char), write(' │').

/**
 * show_columns_line(+N)
 *
 * Prints the board collum header.
 */
show_columns_line(N) :-
    N1 is N - 1,
    write_n(' ', 5), write('│'), show_columns(N), nl,
    write_n(' ', 5), write('╰'), write_n('───┴', N1), write('───╯'), nl.

/**
 * show_cells(+Line)
 *
 * Prints the given Line.
 */
show_cells([]) :- !.
show_cells([Cell | Rest]) :-
    show_piece(Cell), write('│'), show_cells(Rest).

/**
 * show_lines(+Size, +Curr, +Board)
 *
 * Prints the board.
 */
show_lines(N, N, Board) :-
    N1 is N - 1,
    write('───╯ ╰'), write_n('───┴', N1), write('───╯'), nl, !.
show_lines(N, 0, [Line | Rest]) :-
    N1 is N - 1,
    write('───╮ ╭'), write_n('───┬', N1), write('───╮'), nl,
    write(' 1 │ │'), show_cells(Line), nl,
    show_lines(N, 1, Rest), !.
show_lines(N, L, [Line | Rest]) :-
    N1 is N - 1, L1 is L + 1, C is 65 + L, char_code(Char, C),
    write('───┤ ├'), write_n('───┼', N1), write('───┤'), nl,
    format('~t~d~2|', L1), write(' │ │'), show_cells(Line), nl,
    show_lines(N, L1, Rest), !.

/**
 * show_board(+Board)
 * 
 * Displays the current board state.
 */
show_board(Board) :-
    length(Board, N),
    show_columns_line(N),
    show_lines(N, 0, Board).

/**
 * cell(+LineIndex, +ColIndex, +Board, ?Value)
 *
 * Gets the value at (LineIndex, ColIndex) and unifies it with Value.
 * If Value is instantiated, checks if its value is the same as the value at (LineIndex, ColIndex).
 */
cell(LineIndex, ColIndex, Board, Value) :-
    nth0(LineIndex, Board, Line),
    nth0(ColIndex, Line, Value).

/**
 * replace_cell(+LineIndex, +ColIndex, +Board, +Value, -NewBoard)
 *
 * Replaces the value at (LineIndex, ColIndex) with Value and unifies the resulting new board with NewBoard.
 */
replace_cell(LineIndex, ColIndex, Board, Value, NewBoard) :-
    nth0(LineIndex, Board, Line),
    replace(ColIndex, Line, Value, NewLine),
    replace(LineIndex, Board, NewLine, NewBoard).
