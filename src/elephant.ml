open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World
  
let dir_to_camel (x, y : int * int) : int * int =
  (* Directions à vérifier: seulement horizontal et vertical *)
  let directions = [
    (1, 0);
    (-1, 0);
    (0, 1);
    (0, -1);
  ] in
  
  (* Vérifie si on peut voir un camel dans une direction donnée *)
  let rec check_direction (pos_x, pos_y : int * int) (dx, dy : int * int) : bool =
    let next_x, next_y = pos_x + dx, pos_y + dy in
    match get (next_x, next_y) with
    | Camel -> true
    | Empty -> check_direction (next_x, next_y) (dx, dy)
    | _     -> false
  in
  
  (* Trouve la première direction où on voit un camel *)
  match List.find_opt (check_direction (x, y)) directions with
  | Some dir -> dir  (* Retourne la direction du camel *)
  | None -> (0, 0)   (* Aucun camel visible *)

(** [caml current_pos] effectue tous les prochains tours du chameau à partir de la position 
    [current_pos] (attendre une entrée, se déplacer en conséquence, recommencer)*)
let rec elephant (current_position : int * int) : unit =
  let direction = dir_to_camel current_position in
  let new_position = match direction with
  |(0, 0) -> move current_position (current_position ++ (random_direction ()))
  |_ -> move current_position (current_position ++ direction)
  in
  render ();
  perform End_of_turn;
  elephant new_position
