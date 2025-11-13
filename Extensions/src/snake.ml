open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World

(** [adjacent_empty_cells (x,y)] renvoie un tableau de coordonnées accessibles et vides depuis [(x,y)]*)
let adjacent_empty_or_camel_cells (current_position : int * int) : (int * int) array =
  let shifts = [(1, 0); (0, -1); (-1, 0); (0, 1)] in
  (* Fonction auxiliaire qui sélectionne les coordonnées possibles (cases vides et accessibles)*)
  let rec aux sh = match sh with
    |[] -> []
    |dX::r -> if (correct_coordinates (current_position ++ dX) && (is_empty (current_position ++ dX) || is_camel(current_position ++ dX)) )
                then (current_position ++ dX)::(aux r)
              else
                aux r
  in Array.of_list (aux shifts);;


(** [snake current_position] effectue tous les prochains tours du serpent à partir de la position
    [current_position] (essaie de suivre le chameau en utilisant Dijjkstra)*)
let rec snake (current_position : int * int) : unit =
  let deja_traite = Array.make_matrix width height false
  and pred = Array.make_matrix width height (0, 0) (* predecesseur du plus court chemin de current_position à x y *)
  and dist = Array.make_matrix width height max_int; (* distance du plus court chemin de current_position à x y *)
  and camel_found = ref false
  and target = ref (0, 0) (* sert à stocker ou est le chameau une fois dijsktra fini *)
  and q = Queue.create () in (* file pour dijkstra (ici pas besoin de file de file de prio (expliqué dans le rapport)) *)
  Queue.add current_position q;

  (* Boucle principale de Dijkstra*)
  while (not !camel_found) && not (Queue.is_empty q) do
    let s =Queue.pop q in
    let (x_s, y_s) = s in
    if (not deja_traite.(x_s).(y_s)) then begin
      let aec = adjacent_empty_or_camel_cells s in
      let n = Array.length aec in
      for i=0 to (n-1) do
        let v = aec.(i) in
        let (x_v, y_v) = v in
        if (not deja_traite.(x_v).(y_v)) && (dist.(x_s).(y_s) + 1 < dist.(x_v).(y_v)) then begin
          dist.(x_v).(y_v) <- dist.(x_s).(y_s) + 1;
          pred.(x_v).(y_v) <- s;
          Queue.add v q;
        end;
      done;
      deja_traite.(x_s).(y_s) <- true;
    end;
    if is_camel s then ( camel_found := true; target := s )
  done;

  (* Si on a trouvé la chameau on veut connaitre la case voisine à *)
  if (!camel_found) then begin
    while (pred.(fst !target).(snd !target) != current_position) do
      target := pred.(fst !target).(snd !target);
    done;
    let new_position = move current_position !target in
    perform (End_of_turn Snake);
    snake new_position;
  end
  else begin
    let new_position = move current_position (current_position ++ random_direction ()) in
    perform (End_of_turn Snake);
    snake new_position;
  end;
