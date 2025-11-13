open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine


(** [snake current_position] effectue tous les prochains tours du serpent à partir de la position
    [current_position] (se déplacer aléatoirement, recommencer)*)
let rec snake (current_position : int * int) : unit =
  let new_position = current_position ++ random_direction () in
  let new_position = move current_position new_position in
  render ();
  perform (End_of_turn Snake);
  snake new_position
