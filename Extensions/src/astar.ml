open World
open Utils

(* Implémentation de la file de priorité avec *)
type file_prio = (((int*int) * int) list) ref;;

let fp_vide () = ref [];;

let file_is_empty (fp: file_prio) = !fp = [];;

let enfile (ele: (int*int)) (prio: int) (fp: file_prio)=
  let rec aux (li: ((int*int) * int) list) = match li with
    |[]                             -> [(ele, prio)]
    |(e, p)::q when p < prio        -> (e, p)::(aux q)
    |(e, p)::q (* when p >= prio *) -> (ele, prio)::(e,p)::q
  in fp := aux !fp;;

let defile (fp: file_prio) = match !fp with
  | []   -> failwith "Une file vide ne peut pas être défilé"
  | x::t -> fp := t; x;;

let h ((x, y): int*int) =
  let caml_li = !camels_info in
  let rec aux (c_li: camel_info list) : int = match c_li with
    |[]    -> max_int
    |ci::q ->
      let x_c, y_c = ci.position in
      let d = (x_c - x)*(x_c - x) + (y_c - y)*(y_c - y) in
      min d (aux q)
  in aux caml_li;;


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

let a_star current_position =
  let deja_traite = Array.make_matrix width height false
  and pred = Array.make_matrix width height (0, 0) (* predecesseur du plus court chemin de current_position à x y *)
  and dist = Array.make_matrix width height max_int; (* distance du plus court chemin de current_position à x y *)
  and camel_found = ref false
  and target = ref (0, 0) (* sert à stocker ou est le chameau une fois dijsktra fini *)
  and q = fp_vide () in (* file pour dijkstra (ici pas besoin de file de file de prio (expliqué dans le rapport)) *)
  enfile current_position 0 q;

  (* Boucle principale de Dijkstra*)
  while (not !camel_found) && not (file_is_empty q) do
    let s, _ = defile q in
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
          enfile v (dist.(x_v).(y_v)) q;
        end;
      done;
      deja_traite.(x_s).(y_s) <- true;
    end;
    if is_camel s then ( camel_found := true; target := s )
  done;
  !camel_found, pred, target;;
