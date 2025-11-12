open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World




(**[check_possible_egg (x,y)] vérifie si une des cases adjacentes à [(x,y)] est libre pour poser un oeuf, 
si c'est le cas, renvoie la direction, sinon renvoie [(0,0)]*)
let check_possible_egg (x,y : int * int) : int * int =
  (* Directions à vérifier: seulement Nord, Sud, Est, Ouest *)
  let directions = [
    (1, 0);
    (-1, 0);
    (0, 1);
    (0, -1);
  ] in
  
  let possible_direction = List.filter (fun dir -> is_empty ((x,y) ++ dir)) directions in 

  let array_direction = Array.of_list possible_direction in 
  let n = Array.length array_direction in 
  let random_index = Random.int n in 
  array_direction.(random_index)

(** [spider current_position] effectue tous les prochains tours de l'araignée à partir de la position
    [current_position] (se déplacer aléatoirement, poser un oeuf avec 1% de chance, recommencer)*)
let rec spider (current_position : int * int) : unit =
  let new_position = current_position ++ random_direction () in
  let new_position = move current_position new_position in
  let random_int = Random.int 100 in 
  if (random_int = 0) then (
    let (dx,dy) = check_possible_egg current_position in 
    if (correct_coordinates (current_position ++ (dx,dy))) then (
      assert(current_position ++ (dx,dy))
      set (current_position ++ (dx,dy)) Egg
    )
    else (
      
    );
  )
  else ();
  render ();
  perform End_of_turn;
  spider new_position