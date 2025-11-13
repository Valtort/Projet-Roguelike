open World
open Ui
open Utils
open Player
open Snake
open Engine
open Player
open Elephant
open Spider
open Cross
open Snake
(* Initialisation du monde *)

let () = set (width/2, height/2) Cross

(* La file d'exécution *)
let () =
  Queue.add (fun () -> player (fun () -> cross (width/2, height/2) (Empty))) queueCross;;


(* Début du jeu *)
let () = run_queue (queueCross)
