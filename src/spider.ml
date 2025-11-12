open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World

let proba_pondre = 1 (* 1/ 100 *)

let adjacent_empty_cells (current_position : int * int) =
  let shifts = [(1, 0); (0, -1); (-1, 0); (0, 1)] in
  let rec aux sh = match sh with
    |[] -> []
    |dX::r -> if (correct_coordinates (current_position ++ dX)  && is_empty (current_position ++ dX))
                then (current_position ++ dX)::(aux r)
              else
                aux r
  in Array.of_list (aux shifts);;

(** [spider current_position] effectue tous les prochains tours de l'araignée à partir de la position
    [current_position] *)
let rec spider (current_position : int * int) : unit =
  let new_position = current_position ++ random_direction () in
  let new_position = move current_position new_position in (* Déplacer l'araigné *)
  let r = Random.int 100 in
  if r < proba_pondre then pond_oeuf new_position; (* pondre oeuf avec probabilité r/100 *)
  render ();
  perform End_of_turn;
  spider new_position;
and pond_oeuf pos =
  let aec = adjacent_empty_cells pos in
  let n = Array.length aec in
  if n > 0 then begin (* Si il y a un voisin vide *)
    let k = Random.int n in
    (* Placer un oeuf aléatoirement sur une des cases voisine et ajouter l'oeuf à la queue*)
    let egg_pos = aec.(k) in
    set egg_pos Egg;
    Queue.add (fun () -> player (fun () -> egg egg_pos)) queue;
  end;
and egg (current_position : int * int) : unit =
  for i=1 to 60 do
    if ((i mod 20) = 0) then appear_spider current_position; (* tous les 20 tours fair apparaitre une araignée *)
    render ();
    perform End_of_turn;
  done;
  set current_position Empty;
and appear_spider egg_pos =
  let aec = adjacent_empty_cells egg_pos in
  let n =  Array.length aec in
  if n > 0 then begin
    (* Placer une araignée  aléatoirement sur une des cases voisine et ajouter l'araignée à la queue*)
    let k = Random.int n in
    let spider_pos = aec.(k) in
    set spider_pos Spider;
    Queue.add (fun () -> player (fun () -> spider spider_pos)) queue
  end;
