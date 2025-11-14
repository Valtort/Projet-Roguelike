open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World
open Astar


(** [adjacent_empty_cells (x,y)] renvoie un tableau de coordonnées accessibles et vides depuis [(x,y)]*)
let adjacent_empty_or_camel_cells (current_position : int * int) : (int * int) array =
  let shifts = [(1, 0); (0, -1); (-1, 0); (0, 1)] in
  (* Fonction auxiliaire qui sélectionne les coordonnées possibles (cases vides et accessibles)*)
  let rec aux sh = match sh with
    |[] -> []
    |dX::r -> if (correct_coordinates (current_position ++ dX) && (is_empty (current_position ++ dX) ||
      is_camel(current_position ++ dX)) )
                then (current_position ++ dX)::(aux r)
              else
                aux r
  in Array.of_list (aux shifts);;

(** [snake current_position] effectue tous les prochains tours du serpent à partir de la position
    [current_position] (essaie de suivre le chameau en utilisant Dijjkstra)*)
let rec snake (current_position : int * int) : unit =
    let camel_found, pred, t = a_star current_position in
    let target = ref t in

  (* Si on a trouvé un chameau on veut connaitre la case voisine au serpent sur laquelle
    il faut aller pour atteindre le chameau *)
  if (camel_found) then begin
    while (pred.(fst !target).(snd !target) != current_position) do
      target := pred.(fst !target).(snd !target);
    done;
    let new_position = move current_position !target in
    perform (End_of_turn Snake);
    (* On attend un tour avant de rejouer sinon le serpent harcèle le Camel *)
    perform (End_of_turn Snake);
    snake new_position;
  end
  else begin
    let new_position = move current_position (current_position ++ random_direction ()) in
    perform (End_of_turn Snake);
    snake new_position;
  end;
