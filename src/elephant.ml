open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World

(** [dir_to_camel (x,y)] renvoie une direction dans laquelle il y a un chameau
depuis [(x,y)] s'il en existe une, et renvoie [(0,0)] sinon*)
let dir_to_camel (x, y : int * int) : int * int =
  (* Directions à vérifier: seulement Nord, Sud, Est, Ouest *)
  let directions = [
    (1, 0);
    (-1, 0);
    (0, 1);
    (0, -1);
  ] in
  (* Vérifie si on peut voir un chameau dans la direction (dx,dy) depuis la case (pos_x,pos_y) *)
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
  | None -> (0, 0)   (* Aucun camel visible *);;

(** [cactus front (x,y)] *)
let cactus_front (x, y : int * int) (dx, dy : int * int) : bool =
  let cactus_cell = (x+dx, y+dy) in
  (correct_coordinates cactus_cell) && (is_cactus cactus_cell)

(** [elephant] effectue tous les prochains tours de l'éléphant à partir de la position
    [current_position] :
    -> Si on a pas vu de chameau et qu'on est pas stun, on cherche avec [dir_to_camel] une direction
    -> Si on a vu un chameau on charge pendant 10 tours
    -> Si pendant la charge on rencontre un cactus, on est stun pendant 20 tours
    -> On recommence
      *)
let rec elephant (current_position : int * int) : unit =
  let dir = dir_to_camel current_position in
  let can_see = not (dir = (0, 0)) in
  if can_see then begin (* Si on peut voir le chameau *)
    let pos = ref current_position in
    for _=0 to 9 do (* Avancer 10 fois dans la direction du chameau *)
      if cactus_front !pos dir then begin (* Si on voit un cactus, rester stun 20 tours*)
        for _=0 to 19 do
          perform End_of_turn;
        done;
        elephant !pos;
        (* On arrête ici l'éxécution car les appels à elephant ne terminent jamais.
        Donc tout le code ci-dessous ne sera pas considéré si on appelle (elephant !pos)*)
      end;
      pos := move !pos (!pos ++ dir);
      perform End_of_turn;
    done;
    elephant !pos;
  end
  else begin (* Si on ne voit pas le chameau, bouger aléatoirement *)
    let new_position = move current_position (current_position ++ random_direction ()) in
    perform End_of_turn;
    elephant new_position;
  end;;
