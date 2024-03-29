:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(sockets)).

:- consult('src/board').
:- consult('src/game').
:- consult('src/io').
:- consult('src/menu').
:- consult('src/online').
:- consult('src/utils').

/**
 * play/0
 * 
 * Start the game in the main menu.
 */
play :- main_menu.
