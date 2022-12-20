replace(0, [H | T], H, E, [E | T]) :- !.
replace(I, [H | T], O, E, [H | NewT]) :-
    I > 0,
    NewI is I - 1,
    replace(NewI, T, O, E, T2).
