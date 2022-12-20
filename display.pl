display_top_line(0) :- !.
display_top_line(N) :-
    NewN is N - 1,
    display_top_line(NewN),
    write('  '), write(N).

display_top_line :-
    display_top_line(9),
    nl.

display_middle_line(N) :-
    (
        mod(N, 2) =:= 0, write('  |##|  |##|  |##|  |##|  |'), !;
        write('  |  |##|  |##|  |##|  |##|')
    ), nl.

display_lines([], _) :- !.
display_lines([Line], Code) :-
    char_code(Char, Code), write(Char), write(' '),
    display_line(Line), nl, !.
display_lines([Line | Rest], Code) :-
    char_code(Char, Code), write(Char), write(' '),
    display_line(Line), nl,
    display_middle_line(Code),
    NewCode is Code + 1, display_lines(Rest, NewCode).

display_play(empty) :- write('+'), !.
display_play(human) :- write('O'), !.
display_play(E) :- write('X').

display_line([E]) :- display_play(E), !.
display_line([E | T]) :- display_play(E), write('--'), display_line(T).

display_game(GameState-Player) :-
    display_top_line,
    display_lines(GameState, 65).
