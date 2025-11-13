open Notty_unix
open World
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open Player
open Elephant
open Spider
open Snake


(** [keyboard_direction ()] attend un évènement dans le terminal.
    Si ECHAP est pressée, arrête le jeu.
    Si une touche directionnelle est pressée, renvoie le changement à appliquer sur les coordonnées
    du chameau pour aller dans la direction correspondante.*)
let rec keyboard_direction () : int * int =
  match Term.event terminal with
  | `Key (`Escape,       _) -> exit 0   (* press <escape> to quit *)
  | `Key (`Arrow `Left,  _) -> (- 1, 0)
  | `Key (`Arrow `Right, _) -> (+ 1, 0)
  | `Key (`Arrow `Down,  _) -> (0, + 1)
  | `Key (`Arrow `Up,    _) -> (0, - 1)
  | `Key (`ASCII 'c', _)    -> (2, 0) (*2 correspond au cactus*)
  | `Key (`ASCII 'C', _)    -> (2, 0) 
  | `Key (`ASCII 's', _)    -> (3, 0) (*3 correspond au serpent*)
  | `Key (`ASCII 'S', _)    -> (3, 0) 
  | `Key (`ASCII 'e', _)    -> (4, 0) (*4 correspond a l'éléphant*)
  | `Key (`ASCII 'E', _)    -> (4, 0) 
  | `Key (`ASCII 'a', _)    -> (5, 0) (*5 correspond a l'araignée*)
  | `Key (`ASCII 'A', _)    -> (5, 0)
  | `Key (`ASCII 'o', _)    -> (6, 0) (*6 correspond a l'oeuf*)
  | `Key (`ASCII 'O', _)    -> (6, 0)
  | `Key (`ASCII 'g', _)    -> (7, 0) (*7 correspond au chameau*)
  | `Key (`ASCII 'G', _)    -> (7, 0) (*g comme Goat*)
  | `Key (`Enter , _)       -> (10, 0) (*Enter pour jouer un tour*)
  | _                       -> keyboard_direction () 
  (*Modification pour que le tour d'un joueur ne soit pas skip si on touche une mauvaise touche*)

(** [cross current_position (last_seen,coord)] effectue tous les prochains tours de la croix à partir de la position
    [current_position] 
    (attendre une entrée, se déplacer en conséquence/placer une entitées/jouer un tour, recommencer)
    [last_seen] permet de se souvenir de la dernière entitée que l'on a vue à la coordonnée [coord], 
    car quand la croix passe par dessus une entitée, elle est temporairement écrasé par la croix*)
let rec cross (current_position : int * int) ((last_seen) : cell ) : unit =
  let directions = [
    (1, 0);
    (-1, 0);
    (0, 1);
    (0, -1);
  ] in
  let dir = keyboard_direction () in 
  if (List.mem dir directions) then (
    (* Si on demande un mouvement de la croix *)
    let new_position = current_position ++ dir in
    let old_entity = get new_position in
    
    if (old_entity = Outofindex) then (
      render ();
      perform Sandbox;
      cross current_position last_seen
    )
    else (
      let new_position = move_Cross current_position new_position in
      set current_position last_seen; (* On affiche que lorsqu'on bouge*)
      render ();
      perform Sandbox;
      cross new_position old_entity
    )
  )
  else (
    begin 
      match dir with 
      | (2, _) -> 
        cross current_position Cactus
      | (3, _) -> 
        Queue.add (fun () -> player (fun () -> snake current_position)) queuePlayer;
        cross current_position Snake
      | (4, _) -> 
        Queue.add (fun () -> player (fun () -> elephant current_position)) queuePlayer;
        cross current_position Elephant
      | (5, _) -> 
        Queue.add (fun () -> player (fun () -> spider current_position)) queuePlayer;
        cross current_position Spider
      | (6, _) -> 
        Queue.add (fun () -> player (fun () -> egg current_position)) queuePlayer;
        cross current_position Egg
      | (7, _) -> 
        Queue.add (fun () -> player (fun () -> camel current_position)) queuePlayer;
        cross current_position Camel
      | (10, _) -> 
        run_one_step ()

      | _ -> failwith""
    end
  )
  
