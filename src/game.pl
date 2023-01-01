initial_state(Size, Board-white) :-
    fill(Size, empty, Line),
    fill(Size, Line, Board).

display_game(Board-P-W-B) :-
    clear,
    show_board(Board).

tie(GameState) :- valid_moves(GameState, []).

game_over(Board-P-W-B, Winner) :-
    middle(Board, Line),
    middle(Line, Winner),
    Winner \= empty.

congratulate(white) :-
    write('White wins! Press enter to continue '),
    read_str(_).
congratulate(black) :-
    write('Black wins! Press enter to continue '),
    read_str(_).
    
game_cycle(GameState) :-
    tie(GameState), !,
    display_game(GameState),
    write('Out of moves! It\'s a tie! Press enter to continue '),
    read_str(_).
game_cycle(GameState) :-
    game_over(GameState, Winner), !,
    display_game(GameState),
    congratulate(Winner).
game_cycle(GameState) :-
    display_game(GameState),
    choose_move(GameState, NewGameState),
    game_cycle(NewGameState).

choose_move(Board-white-White-Black, NewGameState) :-
    choose_move(Board-white-White-Black, White, NewGameState).
choose_move(Board-black-White-Black, NewGameState) :-
    choose_move(Board-black-White-Black, Black, NewGameState).

choose_move(GameState, human, NewGameState) :-
    read_str_until('Choose move: ', move_str(GameState, NewGameState), _).

choose_move(GameState, easy, NewGameState) :-
    valid_moves(GameState, Moves),
    random_select(Move, Moves, _),
    move(GameState, Move, NewGameState).

choose_move(GameState, hard, NewGameState) :-
    valid_moves(GameState, Moves),
    setof(Value-Move, MovedGameState^(
        member(Move, Moves),
        move(GameState, Move, MovedGameState),
        value(MovedGameState, Value)
    ), [BestValue-Mv | Rest]),
    findall(Move, member(BestValue-Move, [BestValue-Mv | Rest]), BestMoves),
    random_select(BestMove, BestMoves, _),
    move(GameState, BestMove, NewGameState).

move_str(Board-P-W-B, NewGameState, [ColIndexCode | LineIndexStr]) :-
    length(Board, Size),
    str_to_number(LineIndexStr, LineIndex1),
    ColIndex is ColIndexCode - 65, LineIndex is LineIndex1 - 1,
    move(Board-P-W-B, (LineIndex, ColIndex), NewGameState).

next_player(white, black).
next_player(black, white).

visible_piece(Board, Size, Player, (LineIndex, ColIndex), _) :-
    nth0(LineIndex, Board, Line),
    nth0(ColIndex, Line, Player), !.
visible_piece(Board, Size, Player, (LineIndex, ColIndex), (LineDelta, ColDelta)) :-
    nth0(LineIndex, Board, Line),
    nth0(ColIndex, Line, empty),
    NewLineIndex is LineIndex + LineDelta,
    NewColIndex is ColIndex + ColDelta,
    visible_piece(Board, Size, Player, (NewLineIndex, NewColIndex), (LineDelta, ColDelta)).

visible_pieces(Board, Size, Player, Pos, N) :-
    count(visible_piece(Board, Size, Player, Pos), [
        (-1, 1),  (0, 1),  (1, 1),
        (-1, 0),           (1, 0),
        (-1, -1), (0, -1), (1, -1)
    ], N).

move(Board-Player-W-B, (LineIndex, ColIndex), NewBoard-NextPlayer-W-B) :-
    length(Board, Size),
    cell(LineIndex, ColIndex, Board, empty),
    replace_cell(LineIndex, ColIndex, Board, Player, NewBoard),
    dist_to_edge(Size, LineIndex, YDist), dist_to_edge(Size, ColIndex, XDist),
    visible_pieces(Board, Size, Player, (LineIndex, ColIndex), VisiblePieces),
    VisiblePieces >= min(XDist, YDist),
    next_player(Player, NextPlayer).

value(Size, (LineIndex, ColIndex), Value) :-
    dist_to_edge(Size, LineIndex, YDist),
    dist_to_edge(Size, ColIndex, XDist),
    Value is YDist * XDist.

value(Board-Player-W-B, Value) :-
    next_player(Player, NextPlayer),
    game_over(Board-Player-W-B, NextPlayer), !,
    Value is 0.
value(Board-Player-W-B, Value) :-
    game_over(Board-Player-W-B, Player), !,
    length(Board, Size),
    Value is Size * Size * Size.
value(Board-Player-W-B, Value) :-
    length(Board, Size),
    next_player(Player, NextPlayer),
    valid_moves(Board-Player-W-B, OurMoves),
    maplist(value(Size), OurMoves, OurValues),
    sumlist(OurValues, OurValue),
    valid_moves(Board-NextPlayer-W-B, TheirMoves),
    maplist(value(Size), TheirMoves, TheirValues),
    sumlist(TheirValues, TheirValue),
    Value is (Size * Size * Size) - TheirValue + OurValue.

valid_moves(GameState, Moves) :-
    findall(Move, move(GameState, Move, NewState), Moves).
