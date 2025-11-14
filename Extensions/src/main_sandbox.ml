open Roguelib
open World
open Ui
open Utils
open Player
open Snake
open Engine
open Elephant
open Spider
open Sandbox
open Snake
open Globals
(* Initialisation du monde *)
let () = set (width/2, height/2) Cross

(* Début du jeu *)
let () =
  game_mode := SandboxWrite;
  sandbox ()
