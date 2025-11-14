open Roguelib
open World
open Ui
open Utils
open Player
open Snake
open Engine
open Player
open Elephant
open Spider
open Globals
(* Initialisation du monde *)

(* Initialisation du module Random*)
let () = Random.self_init ()

(** [random_position ()] renvoie une position aléatoire dans le monde*)
let random_position () : int * int = (Random.int width, Random.int height)

(* Place les cactus, le chameau, l'éléphant initialement.*)

let () =
  for _ = 0 to 200 do set (random_position ()) Cactus   done

let () =
  for _ = 1 to nb_cookies do set (random_position ()) Cookie done

let camel_initial_position = random_position ();;
let () = set camel_initial_position Camel;;
let () = register_camel camel_initial_position initial_vision;;

let snake_initial_position = random_position ()
let () = set snake_initial_position Snake

let elephant_initial_position = random_position ()
let () = set elephant_initial_position Elephant

let spider_initial_position = random_position ()
let () = set spider_initial_position Spider


(* La file d'exécution *)
let () =
  Queue.add ((fun () -> player (fun () -> camel camel_initial_position initial_vision)), Camel) queue;
  Queue.add ((fun () -> player (fun () -> snake snake_initial_position)), Snake) queue;
  Queue.add ((fun () -> player (fun () -> elephant elephant_initial_position)), Elephant) queue;
  Queue.add ((fun () -> player (fun () -> spider spider_initial_position)), Spider) queue;;


(* Début du jeu *)
let () =
  game_mode := Play;
  render ();
  run_queue ();;
