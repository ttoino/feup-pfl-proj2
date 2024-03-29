/**
 * max_length(+List, ?Length)
 * 
 * Returns the length of List, or the length of the largest element in List
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
 * replace(+Index, ?OldList, ?New, ?NewList)
 * 
 * Unifies NewList with OldList with the element at Index equal to New.
 */
replace(0, [H | T], E, [E | T]) :- !.
replace(I, [H | T], E, [H | NewT]) :-
    I > 0,
    NewI is I - 1,
    replace(NewI, T, E, NewT).

/**
 * fill(+Len, +Elem, ?List)
 * 
 * Unifies List with the list of length Len with all elements equal to Elem.
 */
fill(0, _, []) :- !.
fill(Len, Elem, [Elem | Rest]) :-
    NewLen is Len - 1,
    fill(NewLen, Elem, Rest).

/**
 * middle(+List, ?Out)
 *
 * Returns the middle element of List
 * Returns true if Out is the middle element of List.
 */
middle(List, Out) :-
    length(List, Len),
    Middle is floor(Len/2),
    nth0(Middle, List, Out).

/**
 * valid_board_size(+Size)
 *
 * Checks if Size is a valid board size.
 */
valid_board_size(Size) :-
    Size mod 2 =:= 1,
    between(5, 15, Size).

/**
 * dist_to_edge(+Size, +Index, ?Dist)
 * 
 * Unifies Dist with the distance of Index
 * to the edge of a line of length Size.
 */
dist_to_edge(Size, Index, Dist) :-
    Middle is floor(Size/2),
    Dist is (-abs(Index - Middle)) + Middle.

/**
 * count(:Predicate, +Args, ?N)
 * 
 * Returns the number of elements in Args that satisfy Predicate
 */
count(Predicate, [], 0).
count(Predicate, [Value | Rest], N) :-
    call(Predicate, Value), !,
    count(Predicate, Rest, M),
    N is M + 1.
count(Predicate, [Value | Rest], N) :-
    count(Predicate, Rest, N).
