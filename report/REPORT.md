# PFL, FEUP 2022/23

## 2<sup>nd</sup> practical work - "Development in Prolog of a board game"

#### Group **Center 2**
- João António Semedo Pereira, up202007145@edu.fe.up.pt (\<percentagem>%)
- Nuno Afonso Anjos Pereira, up202007865@edu.fe.up.pt (\<percentagem>%)

## Installation and Execution

After installing [Sicstus 4.7.1](https://sicstus.sics.se/download4.html), as explained in Moodle, and decompressing the submitted file, play the game by running the Prolog Sicstus interpreter and typing:
```prolog
consult(main).
play.
```

> Note: to support all the characters used in the game, your terminal must use a monospaced font such as Consolas

## Game Description

> Taken from https://boardgamegeek.com/boardgame/360905/center

Center is a game with a deceptively simple goal. It was invented by Alek Erickson and Michael Amundsen in 2022. The game is played on the cells of a hexhex board with sidelength 4 or on the intersections of a 9x9 Go board. A Chess board (which is 8x8 squares) also has 9x9 intersections, and therefore works as a Center board.

Rules:
Players take turns placing one stone at a time.
A placement N steps away from the perimeter must have at least N friendly pieces in sight.
The winner is the player who places a stone on the very center of the board.

On the square board, pieces see in all 8 directions.

## Game Logic

### Internal representation of game state

The internal representation of the game's state is a compound term that includes:
- the board (a square matrix of side N, with N being an odd integer between 5 and 15), whose elements are atoms that are either `white`, `black` or `empty`;
- the current player (an atom whose value is either `white` or `black`);
- the types of both players (`human`, `easy`, `medium`, `hard`, with the last three being for the computer AIs);

Initial State:
```
(
    [ 
        [empty, empty, empty, ...], 
        [empty, empty, empty, ...], 
        [empty, empty, empty, ...], 
        [empty, empty, empty, ...], 
        ...
    ], 
    white
)
```

> Due to the way we implemented the `initial_state` predicate, the "initial game state" is the one described above, which is further extended when actually playing the game.

Intermediate state:
```
(
    [ 
        [white, empty, black, ...], 
        [empty, white, empty, ...], 
        [black, empty, empty, ...], 
        [black, empty, black, ...], 
        ...
    ], 
    black,
    "P",
    "E"
)
```

Final state:

> The representation of the final state is similar, to the intermediate state, so it is not represented here

### Game state view

The predicates for the game's menu and visualization are located in the `menu` and `board` modules, respectively. There are predicates present in `io` which are used by the predicates in `menu` to better print output.

- `menu` is responsible for showing the initial, instructions and game setup menus to the user. It does so using the `menu/2` predicate. The initial menu and the instructions menu make use of `write_framed/1` predicate defined in the `io` module. All input is correctly validated;
- `board` contains predicates responsible for taking the game's board and printing it formatted line by line. This is mainly handled by the `show_lines/3` predicate.
- The game has a flexible NxN board, which must be an odd number between 5 and 15. The initial game state can be obtained with the predicate `initialState/2`. The first player is always `white`.

> Note: due to the way we store the game's state, there is no player variable in the game's predicates. Instead the player is obtained from the game's state.

### Move Execution

Move execution is handled by the `move/3` predicate.

It is responsible for validating the current move according to the game's rule set and, if valid, performing that same move, creating the game's new state in the process. If the new move is not valid, the predicate will fail. 

### List of valid moves

Obtaining a list of valid moves is done using the `valid_moves/2` predicate, which tries every move possible and if it is valid adds it to the resulting list. It does so using Prolog's builtin `findall/3`.

### End of Game

The verification of the game's termination is done by means of the `game_cycle/1` predicate, which has, in order, definitions for a win, a tie, and a "normal" situation (one where the game can still continue).

First we check if the game was a win for someone, using the `game_over/2` predicate, which checks, in the context of our game, if the position in the middle of the board has a piece in it, and returns the winner in the process (in case it wasn't instantiated).

If this check fails, we then check if the game ended in a tie, using the `tie/1` predicate: if it succeeds, a message indicating that the game result was a tie is shown and, after user input, the game exits.

If none of the aforementioned checks succeed, it means that the game did not end, and so the game loop continues normally.

### Board Evaluation

Evaluation of the state of the game is done using the `value/3` predicate. 

The logic of this predicate is as follows:
- See if the other player has won: if they have, the value of the current state is a large negative number (the symmetric of the size of the board's side cubed);
- See if we won: if we have, the value of the current state is a large positive number (the size of the board's side cubed);
- If neither player won, Get the effective value of our current valid moves and the other player's valid moves; the value of the current game state, for the current player, is the difference between their moves' value and the other player's moves' value.

### Computer Move

There were 2 strategies implemented for the computer's move selection, each using the `choose_move/3` predicate:
- **Easy** uses a random selection strategy of the valid moves that can be taken;
- **Medium** and **Hard** both use the [*minmax*](https://en.wikipedia.org/wiki/Minimax) algorithm, with only the search depth being different between them (1 for Medium, 2 for Hard). This strategy makes use of `setof/3` and `value/3` for picking a list of best possible moves and then picks a random move out of that list (this was made in order to decrease the level of determinism in the move selection);

Both predicates make use of the `valid_moves/2` predicate.

## Conclusions

The board game Center was successfully implemented in the SicStus Prolog 4.7 language. The game can be played Player vs Player, Player vs Computer or Computer vs Computer (with the Computer having three different levels of difficulty).

One of the main difficulties in the development of this project was the fact that Prolog as a language only supports source code files encoded in UTF-16, which lead to weird errors when writing the code initially.

Another limitation of our implementation of the game is the computer move selection algorithm: we implemented the naïve approach of the *minmax* algorithm, which on large boards can be slow to compute the computer's next move. We tried to implement [*alpha-beta pruning*](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning) as an optimization to this algorithm but due to the nature of Prolog this was proving to be quite difficult and was not done.

## Bibliography
- https://boardgamegeek.com/boardgame/360905/center
- https://en.wikipedia.org/wiki/Minimax
- https://sicstus.sics.se/documentation.html