open_server(Stream) :-
    socket_server_open(6543, Stream, [reuseaddr(true)]).

wait_for_player(online, Server, online-Stream) :-
    socket_server_accept(Server, _, Stream, [type(text), encoding('UTF-8')]).
wait_for_player(P, _, P) :- !.

join_server(Stream, IpStr) :-
    atom_codes(Ip, IpStr),
    socket_client_open(Ip:6543, Stream, [type(text), encoding('UTF-8')]).

client_loop(Stream) :-
    set_input(Stream), set_output(user_output),
    handle_response(Stream),
    client_loop(Stream).

handle_response(Stream) :-
    peek_char('!'), get_char('!'), !,
    read(Board),
    clear,
    show_board(Board).
handle_response(Stream) :-
    peek_char('?'), get_char('?'), !,
    read_str(Str),
    write_str(Str),
    set_input(user_input),
    set_output(Stream),
    read_str(Inp),
    write_str(Inp),
    write('\n'),
    flush_output(Stream).
handle_response(Stream) :-
    peek_char('.'), get_char('.'), !,
    read_str(Str),
    write_str(Str),
    set_input(user_input),
    close(Stream),
    read_str(_),
    fail.
handle_response(Stream) :- get_char(_).
