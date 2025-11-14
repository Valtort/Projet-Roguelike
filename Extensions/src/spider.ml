open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World

let proba_pondre = 1 (* 1/ 100 *)

(** [adjacent_empty_cells (x,y)] renvoie un tableau de coordonnées accessibles et vides depuis [(x,y)]*)
let adjacent_empty_cells (current_position : int * int) : (int * int) array =
  let shifts = [(1, 0); (0, -1); (-1, 0); (0, 1)] in
  (* Fonction auxiliaire qui sélectionne les coordonnées possibles (cases vides et accessibles)*)
  let rec aux sh = match sh with
    |[] -> []
    |dX::r -> if (correct_coordinates (current_position ++ dX) && is_empty (current_position ++ dX))
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
  if r < proba_pondre then pond_oeuf new_position; (* pondre oeuf avec probabilité proba_pondre/100 *)
  perform (End_of_turn Spider);
  spider new_position;
(* [pond_oeuf] pond un oeuf sur la case pos et ajoute l'entitée egg à la file *)
and pond_oeuf pos =
  let aec = adjacent_empty_cells pos in
  let n = Array.length aec in
  if n > 0 then begin (* Si il y a un voisin vide *)
    let k = Random.int n in
    (* Placer un oeuf aléatoirement sur une des cases voisine et ajouter l'oeuf à la queue*)
    let egg_pos = aec.(k) in
    set egg_pos Egg;
    Queue.add ((fun () -> player (fun () -> egg egg_pos)), Egg) queue;
  end;
(* [egg current_position] effectue tous les prochains tours de l'oeuf à partir de la position
    [current_position] et cause un appel à appear_spider tous les 20 tours*)
and egg (current_position : int * int) : unit =
  for i=1 to 60 do
    (* tous les 20 tours faire apparaitre une araignée *)
    if ((i mod 20) = 0) then appear_spider current_position;
    perform (End_of_turn Egg);
  done;
  set current_position Empty;
and appear_spider (egg_pos : int * int) =
  let aec = adjacent_empty_cells egg_pos in
  let n =  Array.length aec in
  if n > 0 then begin
    (* Placer une araignée  aléatoirement sur une des cases voisine et ajouter l'araignée à la queue*)
    let k = Random.int n in
    let spider_pos = aec.(k) in
    set spider_pos Spider;
    Queue.add ((fun () -> player (fun () -> spider spider_pos)), Spider) queue
  end;
