open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World
open Engine
open Player

(** [random_position ()] renvoie une position aléatoire dans le monde*)
let random_direction () : int * int = let x = Random.int 4 in 
match x with 
| 0 -> (- 1, 0)
| 1 -> (+ 1, 0)
| 2 -> (0, + 1)
| 3 -> (0, - 1)
| _ -> (0, 0)

(** [caml current_pos] effectue tous les prochains tours du chameau à partir de la position 
    [current_pos] (attendre une entrée, se déplacer en conséquence, recommencer)*)
let rec snake (current_position : int * int) : unit =
  let new_position = current_position ++ random_direction () in
  let new_position = move current_position new_position in
  render ();
  perform End_of_turn;
  snake new_position