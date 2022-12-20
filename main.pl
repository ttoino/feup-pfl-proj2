:- use_module(library(random)).
:- use_module(library(lists)).
:- consult(display).
:- consult(lists).

fill_line(0, []) :- !.
fill_line(N, [empty | Rest]) :-
    NewN is N - 1,
    fill_line(NewN, Rest).

fill_board(0, []) :- !.
fill_board(N, [Line | Rest]) :-
    NewN is N - 1,
    fill_line(9, Line),
    fill_board(NewN, Rest).

initial_state(GameState-Player) :-
    random_member(Player, [human, computer-1, computer-2]),
    fill_board(9, GameState).

play_game :-
    initial_state(GameState-Player),
    display_game(GameState-Player),
    game_cycle(GameState-Player).

game_over(GameState, Winner) :-
    nth0(4, GameState, Line),
    nth0(4, Line, Winner),
    Winner \= empty.

game_cycle(GameState-Player) :-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState-Player) :-
    choose_move(GameState, Player, Move),
    move(GameState, Player, Move, NewGameState),
    next_player(Player, NextPlayer),
    display_game(GameState-NextPlayer), !,
    game_cycle(NewGameState-NextPlayer).

game_cycle(G) :- game_cycle(G).

next_player(human, computer-X).
next_player(computer-X, humang).

move(GameState, Player, Line-Col, NewGameState) :-
    replace(Line, GamesState, OldLine, NewLine, NewGameState),
    replace(Col, OldLine, Old, Player, NewLine),
    Old \= Player.

choose_move(GameState, human, Line-Col) :-
    repeat,
    write('What\'s your next move? '),
    get_code(L),
    get_code(C),
    (
        L >= 65, L =< 73, C >= 49, C =< 57,
        Line is L - 65,
        Col is C - 31,
        skip_line, !;
        skip_line
    ).
    % interaction to select move

choose_move(GameState, computer-Level, Move) :-
    valid_moves(GameState, Moves),
    choose_move(Level, GameState, Moves, Move).

valid_moves(GameState, Player, Moves) :-
    findall(Move, move(GameState, Player, Move, NewState), Moves).

choose_move(1, _GameState, Moves, Move) :-
    random_select(Move, Moves, _Rest).

choose_move(2, GameState, Moves, Move) :-
    setof(Value-Mv, NewState^( member(Mv, Moves),
    move(GameState, Mv, NewState),
    evaluate_board(NewState, Value) ), [_V-Move|_]).
