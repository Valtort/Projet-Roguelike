open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World
open Player

(** [random_position ()] renvoie une position aléatoire dans le monde*)
let random_direction () : int * int = let x = Random.int 4 in 
match x with 
| 0 -> (- 1, 0)
| 1 -> (+ 1, 0)
| 2 -> (0, + 1)
| 3 -> (0, - 1)
| _ -> (0, 0)

(** Renvoie une direction dans laquelle on peut aller pour trouver un chameau depuis [(x,y)]  *)
let dir_to_camel (x, y : int * int) : int * int =
  (* Directions à vérifier: seulement horizontal et vertical *)
  let directions = [
    (1, 0);
    (-1, 0);
    (0, 1);
    (0, -1);
  ] in
  
  (* Vérifie si on peut voir un camel dans la direction [(dx,dy)] depuis [(pos_x,pos_y)]  *)
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


(** [elephant current_pos] effectue tous les prochains tours de l'éléphant à partir de la position 
    [current_pos] 
    ->
    -> 
    -> 
    ->
  *)
let rec elephant (current_position : int * int) (saw_camel : bool) (is_stunned : bool) (nb_turn : int) (camel_dir : int*int) : unit =
  let dir = dir_to_camel current_position in 
  if (not saw_camel && not is_stunned) then (
    if (dir = (0,0)) then (
      (* Situation où on ne peut pas aller vers un chameau *)
      let new_position = current_position ++ random_direction () in
      let new_position = move current_position new_position in
      render ();
      perform End_of_turn;
      elephant new_position false false 0 (0,0)
    )
    else (
      (* On charge pendant 10 tours *)
      if (is_cactus (current_position ++ dir)) then (
        (* On bouge pas et on est stun pendant 20 tours *)
        render ();
        perform End_of_turn;
        elephant current_position false true 20 (0,0)
      )
      else (
        (* On charge dans la direction dir et on garde en mémoire dans l'appel récursif la direction *)
        let new_position = current_position ++ dir in
        let new_position = move current_position new_position in
        render ();
        perform End_of_turn;
        (* Il ne reste plus que 9 tours pendant lesquelles on doit chargé *)
        elephant new_position true false 9 dir 
      ) 
    )
  )
  else (
    if (is_stunned && nb_turn>0) then (
      (* On diminue de 1 le nombre de tour à attendre *)
      render ();
      perform End_of_turn;
      elephant current_position false true (nb_turn-1) (0,0)
    )
    else (
      if (nb_turn == 0) then (
        (* On enlève le stun *)
        elephant current_position false false 0 (0,0)
      )
      else (
        if (saw_camel && nb_turn > 0) then (
           if (is_cactus (current_position ++ camel_dir)) then (
            (* On bouge pas et on est stun pendant 20 tours *)
            render ();
            perform End_of_turn;
            elephant current_position false true 20 (0,0)
          )
          else (
            let new_position = current_position ++ camel_dir in
            let new_position = move current_position new_position in
            render ();
            perform End_of_turn;
            elephant new_position true false (nb_turn-1) camel_dir 
          )
        )
        else (
          (* Si on arrive ici, c'est forcément que nb_turn = 0 *)
          elephant current_position false false 0 camel_dir 
        )
      )
    )
  )