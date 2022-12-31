initial_state(Size, GameState) :-
    fill(Size, empty, Line),
    fill(Size, Line, GameState).
