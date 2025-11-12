open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine


(** [random_direction ()] renoie un déplacement aléatoire.**)

let () = Random.self_init ()

(* fonction pour choisir un déplacement aléatoire parmi les quatre directions *)

let random_direction () : int * int = 
  match Random.int 4 with
  | 0 -> (-1, 0)
  | 1 -> (1, 0)
  | 2 -> (0, -1)
  | _ -> (0, 1)
  

(** [caml current_pos] effectue tous les prochains tours du chameau à partir de la position 
    [current_pos] (attendre une entrée, se déplacer en conséquence, recommencer)*)
let rec snake (current_position : int * int) : unit =
  let new_position = current_position ++ random_direction () in
  let new_position = move current_position new_position in
  render ();
  perform End_of_turn;
  snake new_position