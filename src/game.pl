/**
 * initial_state(+Size, -GameState)
 *
 * Sets the game's initial state.
 */
initial_state(Size, Board-white) :-
    fill(Size, empty, Line),
    fill(Size, Line, Board).

/**
 * display_game(+GameState)
 *
 * Prints the current game state to the screen.
 */
display_game(Board-P-White-Black) :-
    clear,
    show_board(Board),
    show_board_to(Board, White),
    show_board_to(Board, Black).

show_board_to(Board, online-Stream) :-
    set_output(Stream),
    write('!'),
    write(Board),
    write('.\n'),
    flush_output(Stream),
    set_output(user_output).
show_board_to(_Board, _Player).

/**
 * tie(+GameState)
 *
 * Returns true if there are no more valid moves in the given game state.
 */
tie(GameState) :- valid_moves(GameState, []).

/**
 * game_over(+GameState, -Winner)
 *
 * Unifies Winner with the winner of the game in the given game state.
 */
game_over(Board-P-W-B, Winner) :-
    middle(Board, Line),
    middle(Line, Winner),
    Winner \= empty.

/**
 * congratulate(+Color)
 *
 * Displays a winning message to the player that won.
 */
congratulate(white, W, B) :-
    write('White wins! Press enter to continue '),
    write_to(W, 'White wins! Press enter to continue '),
    write_to(B, 'White wins! Press enter to continue '),
    read_str(_).
congratulate(black, W, B) :-
    write('Black wins! Press enter to continue '),
    write_to(W, 'Black wins! Press enter to continue '),
    write_to(B, 'Black wins! Press enter to continue '),
    read_str(_).

write_to(online-Stream, Str) :-
    set_output(Stream),
    write('.'),
    write(Str),
    write('\n'),
    flush_output(Stream),
    set_output(user_output).
write_to(_P, _S).

/**
 * game_cycle(+GameState)
 *
 * Calculates one cycle of the game from the given game state.
 */
game_cycle(Board-P-W-B) :-
    game_over(Board-P-W-B, Winner), !,
    display_game(Board-P-W-B),
    congratulate(Winner, W, B).
game_cycle(Board-P-W-B) :-
    tie(Board-P-W-B), !,
    display_game(Board-P-W-B),
    write('Out of moves! It\'s a tie! Press enter to continue '),
    write_to(W, 'Out of moves! It\'s a tie! Press enter to continue '),
    write_to(B, 'Out of moves! It\'s a tie! Press enter to continue '),
    read_str(_).
game_cycle(GameState) :-
    display_game(GameState),
    choose_move(GameState, NewGameState), !,
    game_cycle(NewGameState).

/**
 * choose_move(+OldGameState, -NewGameState)
 *
 * Chooses the next move according to the player that moves in the current turn.
 */
choose_move(Board-white-White-Black, NewGameState) :-
    choose_move(Board-white-White-Black, White, NewGameState).
choose_move(Board-black-White-Black, NewGameState) :-
    choose_move(Board-black-White-Black, Black, NewGameState).

/**
 * choose_move(+GameState, human, -NewGameState)
 *
 * Prompts a human player for a move code.
 */
choose_move(GameState, human, NewGameState) :-
    read_str_until('Choose move: ', move_str(GameState, NewGameState), _).

choose_move(GameState, online-Stream, NewGameState) :-
    set_input(Stream), set_output(Stream),
    read_str_until('?Choose move: \n', move_str(GameState, NewGameState), _),
    set_input(user_input), set_output(user_output).

/**
 * choose_move(+GameState, easy, -NewGameState)
 *
 * Chooses a new move for the easy AI to perform.
 */
choose_move(GameState, easy, NewGameState) :-
    valid_moves(GameState, Moves),
    random_select(Move-NewGameState, Moves, _).

/**
 * choose_move(+GameState, medium, -NewGameState)
 *
 * Chooses a new move for the medium AI to perform.
 */
choose_move(GameState, medium, NewGameState) :-
    minimax(GameState, 1, NewGameState).

/**
 * choose_move(+GameState, hard, -NewGameState)
 *
 * Chooses a new move for the hard AI to perform.
 */
choose_move(GameState, hard, NewGameState) :-
    minimax(GameState, 2, NewGameState).

/**
 * move_str(+GameState, -NewGameState, +Move)
 *
 * Calculates the game's new state according to Move and unifies it with NewGameState.
 */
move_str(Board-P-W-B, NewGameState, [ColIndexCode | LineIndexStr]) :-
    length(Board, Size),
    str_to_number(LineIndexStr, LineIndex1),
    ColIndex is ColIndexCode - 65, LineIndex is LineIndex1 - 1,
    move(Board-P-W-B, (LineIndex, ColIndex), NewGameState).

/**
 * minimax(+GameState, +Depth, -NewGameState)
 *
 * Performs the MiniMax algorithm on the current game state to calculate the best possible move.
 */
minimax(GameState, Depth, NewGameState) :-
    minimax(GameState, Depth, _, false, NewGameState).

/**
 * minimax(+GameState, +Depth, ?Value, :Max, -NewGameState)
 *
 * Performs the MiniMax algorithm on the current game state to calculate the best possible move.
 */
minimax(GameState, 0, Value, _, _) :-
    value(GameState, Value), !.
minimax(GameState, Depth, Value, Max, NewGameState) :-
    valid_moves(GameState, Moves),
    (
        length(Moves, 0) -> value(GameState, Value);
        NewDepth is Depth - 1,
        setof(Val-Move-MovedGameState, (
            member(Move-MovedGameState, Moves),
            minimax(MovedGameState, NewDepth, V, \+(Max), _)
        ), [V-M-GS | Rest]),
        findall(V-_M-_GS, member(V-_M-_GS, [V-M-GS | Rest]), BestMoves),
        random_select(V-_Move-NewGameState, BestMoves, _),
        (call(Max) -> Value is -V; Value is V)
    ).

/**
 * next_player/2
 *
 * Returns the player that plays after the current one.
 */
next_player(white, black).
next_player(black, white).

/**
 * visible_piece(+Board, +Player, +Position, +Direction)
 *
 * Checks if there is a visible piece of the same color as Player in the Direction given from the given Position.
 */
visible_piece(Board, Player, (LineIndex, ColIndex), _) :-
    nth0(LineIndex, Board, Line),
    nth0(ColIndex, Line, Player), !.
visible_piece(Board, Player, (LineIndex, ColIndex), (LineDelta, ColDelta)) :-
    nth0(LineIndex, Board, Line),
    nth0(ColIndex, Line, empty),
    NewLineIndex is LineIndex + LineDelta,
    NewColIndex is ColIndex + ColDelta,
    visible_piece(Board, Player, (NewLineIndex, NewColIndex), (LineDelta, ColDelta)).

/**
 * visible_pieces(+Board, +Player, +Pos, -N)
 *
 * Counts the number of pieces of the same color as Player visible from the given Position.
 */
visible_pieces(Board, Player, Pos, N) :-
    count(visible_piece(Board, Player, Pos), [
        (-1, 1),  (0, 1),  (1, 1),
        (-1, 0),           (1, 0),
        (-1, -1), (0, -1), (1, -1)
    ], N).

/**
 * move(+GameState, +Move, -NextGameState)
 *
 * Performs the given Move 
 */
move(Board-Player-W-B, (LineIndex, ColIndex), NewBoard-NextPlayer-W-B) :-
    length(Board, Size),
    cell(LineIndex, ColIndex, Board, empty),
    dist_to_edge(Size, LineIndex, YDist), dist_to_edge(Size, ColIndex, XDist),
    visible_pieces(Board, Player, (LineIndex, ColIndex), VisiblePieces),
    VisiblePieces >= min(XDist, YDist),
    replace_cell(LineIndex, ColIndex, Board, Player, NewBoard),
    next_player(Player, NextPlayer).

/**
 * value(+Size, +Position, -Value)
 *
 * Calculates the value of the given Position and unifies it with Value.
 */
value(Size, (LineIndex, ColIndex)-GameState, Value) :-
    dist_to_edge(Size, LineIndex, YDist),
    dist_to_edge(Size, ColIndex, XDist),
    Value is YDist * XDist.

/**
 * value(+GameState, -Value)
 *
 * Calculates the value of the given GameState and unifies it with Value.
 */
value(Board-Player-W-B, Value) :-
    next_player(Player, NextPlayer),
    game_over(Board-Player-W-B, NextPlayer), !,
    length(Board, Size),
    Value is -(Size * Size * Size).
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
    Value is OurValue - TheirValue.

/**
 * valid_moves(+GameState, ?Moves)
 *
 * Gets the list of valid moves for the given game state.
 * Returns true if Moves is the current list of valid moves for the given game state.
 */
valid_moves(GameState, Moves) :-
    findall(Move-NewState, move(GameState, Move, NewState), Moves).
