/**
 * max_length(+List, ?Length)
 * 
 * Returns true if Length is the length of the largest list in List.
 */
max_length([], 0).
max_length([T], L) :- length(T, L).
max_length([H | T], ML) :-
    max_length(T, CL),
    length(H, L),
    (
        L >= CL, ML = L, !;
        ML = CL
    ).

/**
 * replace(+Index, ?OldList, ?Old, ?New, ?NewList)
 * 
 * Returns true if the element at Index in OldList is Old
 * and the element at Index in NewList is New.
 */
replace(0, [H | T], H, E, [E | T]) :- !.
replace(I, [H | T], O, E, [H | NewT]) :-
    I > 0,
    NewI is I - 1,
    replace(NewI, T, O, E, T2).

/**
 * fill(+Len, +Elem, ?List)
 * 
 * Unifies List with the list of length Len with all elements equal to Elem.
 */
fill(0, _, []) :- !.
fill(Len, Elem, [Elem | Rest]) :-
    NewLen is Len - 1,
    fill(NewLen, Elem, Rest).
