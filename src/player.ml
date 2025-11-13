open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World

(** [keyboard_direction ()] attend un évènement dans le terminal.
    Si ECHAP est pressée, arrête le jeu.
    Si une touche directionnelle est pressée, renvoie le changement à appliquer sur les coordonnées
    du chameau pour aller dans la direction correspondante.*)
let keyboard_direction () : int * int =
  match Term.event terminal with
  | `Key (`Escape,       _) -> exit 0   (* press <escape> to quit *)
  | `Key (`Arrow `Left,  _) -> (- 1, 0)
  | `Key (`Arrow `Right, _) -> (+ 1, 0)
  | `Key (`Arrow `Down,  _) -> (0, + 1)
  | `Key (`Arrow `Up,    _) -> (0, - 1)
  | _                       -> (0, 0)

(** [camel current_position] effectue tous les prochains tours du chameau à partir de la position
    [current_position] (attendre une entrée, se déplacer en conséquence, recommencer)
    [vision] (donne la largeur du champ de vision du camel)*)
let rec camel (current_position : int * int) (vision : int) : unit =
  (* Enregistrer la position et vision du camel *)
  register_camel current_position vision;
  let new_position = current_position ++ keyboard_direction () in
  match get new_position with
  |Cookie -> 
    (
      set new_position Empty;
      let new_position = move current_position new_position in
      register_camel new_position (vision + 1);
      render ();
      perform End_of_turn;
      camel new_position (vision+1)
    )
  | _ -> 
    (
      let new_position = move current_position new_position in
      register_camel new_position vision;
      render ();
      perform End_of_turn;
      camel new_position vision
    )