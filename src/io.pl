/**
 * write_str(+Str)
 * 
 * Writes a (quoted) string.
 */
write_str("").
write_str([Code | T]) :- char_code(Char, Code), write(Char), write_str(T).

/**
 * write_n(+Char, +N)
 * 
 * Writes an atom N times.
 */
write_n(_, 0) :- !.
write_n(C, L) :-
    L1 is L - 1,
    write(C),
    write_n(C, L1).

/**
 * clear/0
 * 
 * Clears the terminal.
 */
clear :- write_str("\e[2J").

/**
 * write_framed(+Lines)
 * 
 * Writes a list of (quoted) strings centered inside a frame.
 */
write_framed(Lines) :-
    max_length(Lines, Len),
    write_frame_top(Len),
    write_framed_lines(Lines, Len),
    write_frame_bottom(Len).

/**
 * write_frame_top(+Length)
 *
 * Writes the top portion of a frame which is Length chars wide.
 */
write_frame_top(Length) :-
    L2 is Length + 2,
    write('╭'), write_n('─', L2), write('╮'), nl.

/**
 * write_frame_bottom(+Length)
 *
 * Writes the bottom portion of a frame which is Length chars wide.
 */
write_frame_bottom(Length) :-
    L2 is Length + 2,
    write('╰'), write_n('─', L2), write('╯'), nl.

/**
 * write_framed_lines(+Lines, +Size)
 *
 * Writes the given Lines framed in a frame with width equal to Size
 */
write_framed_lines([], _) :- !.
write_framed_lines([H | T], Len) :-
    length(H, LineLen),
    HalfLen is (Len - LineLen)/2,
    LeftLen is floor(HalfLen),
    RightLen is ceiling(HalfLen),

    write('│ '),
    write_n(' ', LeftLen),
    write_str(H),
    write_n(' ', RightLen),
    write(' │'), nl,
    write_framed_lines(T, Len).

/**
 * read_number(-X)
 * 
 * Reads a non-negative base 10 number and unifies it with X.
 */
read_number(X) :- read_number(0, X).

/**
 * read_number(+Curr, -Out)
 *
 * Reads a non-negative base 10 number digit by digit and unifies it with Out.
 */
read_number(X, X) :- peek_code(10), get_code(10), !.
read_number(Curr, Out) :-
    get_code(C),
    C >= 48,
    C =< 57,
    NewCurr is Curr * 10 + (C - 48),
    read_number(NewCurr, Out).

/**
 * str_to_number(+Str, -X)
 *
 * Converts Str into a non-negative base 10 number and unifies it with X.
 */
str_to_number(Str, X) :- str_to_number(Str, 0, X).

/**
 * str_to_number(+Str, +Curr, -Out)
 *
 * Converts Str into a non-negative base 10 number digit by digit and unifies it with X.
 */   
str_to_number([], X, X) :- !.
str_to_number([C | Rest], Curr, Out) :-
    C >= 48,
    C =< 57,
    NewCurr is Curr * 10 + (C - 48),
    str_to_number(Rest, NewCurr, Out).

/**
 * read_number_until(+Prompt, +Condition(+X), -X)
 * 
 * Reads a non negative base 10 number that satisfies Condition(X).
 */
read_number_until(Prompt, Condition, Out) :-
    repeat,
    write(Prompt),
    read_number(Out),
    call(Condition, Out), !.

/**
 * read_str(-Str)
 * 
 * Reads a (quoted) string.
 */
read_str([]) :- peek_code(10), get_code(10), !.
read_str([Code | T]) :-
    get_code(Code),
    read_str(T).

read_null_terminated([]) :- peek_char('␄'), get_char('␄'), !.
read_null_terminated([Code | T]) :-
    get_code(Code),
    read_null_terminated(T).

/**
 * read_str_until(+Condition(+Str), -Str)
 * 
 * Reads a (quoted) string that satisfies Condition(Str).
 */
read_str_until(Prompt, Condition, Out) :-
    repeat,
    write(Prompt), flush_output,
    read_str(Out),
    call(Condition, Out), !.
