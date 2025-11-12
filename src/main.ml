open World
open Ui
open Utils
open Player
open Engine
open Player
open Snake
open Elephant

(* Initialisation du monde *)

(* Initialisation du module Random*)
let () = Random.self_init ()

(** [random_position ()] renvoie une position aléatoire dans le monde*)
let random_position () : int * int = (Random.int width, Random.int height)

(* Place les cactus, le chameau, l'éléphant initialement.*)

let () =
  for _ = 0 to 200 do set (random_position ()) Cactus   done 

let camel_initial_position1 = random_position ()
let snake_initial_position = random_position ()
let elephant_initial_position = random_position ()
let () = set camel_initial_position1 Camel; 
         (* On place le serpent*)
         set snake_initial_position Snake;
         set elephant_initial_position Elephant



(* La file contient uniquement le tour du chameau *)

let () = Queue.add (fun () -> player (fun () -> camel camel_initial_position1)) queue;
         (* Queue.add (fun () -> player (fun () -> camel camel_initial_position2)) queue; *)
         Queue.add (fun () -> player (fun () -> snake snake_initial_position)) queue;
         Queue.add (fun () -> player (fun () -> (elephant elephant_initial_position false false 0 (0,0)))) queue


(* Début du jeu *)
let () = run_queue ()


