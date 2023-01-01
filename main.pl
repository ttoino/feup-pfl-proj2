:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(random)).

:- consult('src/board').
:- consult('src/game').
:- consult('src/io').
:- consult('src/menu').
:- consult('src/utils').

/**
 * play/0
 * 
 * Start the game in the main menu.
 */
play :- main_menu.
