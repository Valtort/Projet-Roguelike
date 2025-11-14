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
open Globals


let current_position = ref (width/2, height/2)
and last_seen = ref world.(width/2).(height/2)

(** [move_Cross old_pos new_pos] déplace le contenu de la case en [old_pos] vers la case [new_pos].
    Peu importe qu'il y ai une entitée ou non, on vérifie dans la fonction [cross] du fichier cross.ml
    si la case est dans le plateau de jeu ou non*)
let move_cross (new_position : int * int) : unit =
  let tmp = get new_position in
  set !current_position !last_seen ;
  set new_position Cross;
  current_position := new_position;
  last_seen := tmp;;
  (*Modification pour que le tour d'un joueur ne soit pas skip si on touche une mauvaise touche*)

(** [sandbox_write_mode ()] permet de déplacer la croix et de placer des entitées
    [last_seen] permet de se souvenir de la dernière entitée que l'on a vue,
    car quand la croix passe par dessus une entitée,
    cette entitée est temporairement écrasé par la croix*)
let rec sandbox_write_mode () =
  let pos = !current_position in
  match Term.event terminal with
  (* Cas où on veut quitter/ déplacer la croix *)
    | `Key (`Escape,       _) -> exit 0   (* press <escape> to quit *)
    | `Key (`Arrow `Left,  _) ->
      let new_position = !current_position ++ (-1, 0) in
      if (correct_coordinates new_position) then begin
        move_cross new_position;
        render ();
      end;
      sandbox ()

    | `Key (`Arrow `Right, _) ->
      let new_position = !current_position ++ (+1, 0) in
      if (correct_coordinates new_position) then begin
        move_cross new_position;
        render ();
      end;
      sandbox ()
    | `Key (`Arrow `Down,  _) ->
      let new_position = !current_position ++ (0, +1) in
      if (correct_coordinates new_position) then begin
        move_cross new_position;
        render ();
      end;
      sandbox ()
    | `Key (`Arrow `Up,    _) ->
      let new_position = !current_position ++ (0, -1) in
      if (correct_coordinates new_position) then begin
        move_cross new_position;
        render ();
      end;
      sandbox ()

    (* Cas où on veut placer une entitée *)
    | `Key (`ASCII 'c', _)  when !last_seen = Empty ->
      last_seen := Cactus;
      sandbox ()
    | `Key (`ASCII 's', _) when !last_seen = Empty   ->
      Queue.add ((fun () -> player (fun () -> snake pos)), Snake) queue;
      last_seen := Snake;
      sandbox ()
    | `Key (`ASCII 'e', _)  when !last_seen = Empty  ->
      Queue.add ((fun () -> player (fun () -> elephant pos)), Elephant) queue;
      last_seen := Elephant;
      sandbox ()
    | `Key (`ASCII 'a', _)  when !last_seen = Empty  ->
      Queue.add ((fun () -> player (fun () -> spider pos)), Spider) queue;
      last_seen := Spider;
      sandbox ();
    | `Key (`ASCII 'k', _)  when !last_seen = Empty  ->
      last_seen := Cookie;
      sandbox ();
    | `Key (`ASCII 'o', _)  when !last_seen = Empty  ->
        Queue.add ((fun () -> player (fun () -> egg pos)), Egg) queue;
        last_seen := Egg;
        sandbox ()
    | `Key (`ASCII 'g', _)  when !last_seen = Empty  ->
        Queue.add ((fun () -> player (fun () -> camel pos initial_vision)), Camel) queue;
        register_camel pos initial_vision;
        last_seen := Camel;
        sandbox ()
    (* On quitte le cross mode et on y revient JAMAIS, permet de jouer sur le terrain crée *)
    | `Key (`ASCII 'q', _)  ->
      set !current_position !last_seen;
      game_mode := Play;
      run_queue ();

    (* On quitte le cross mode mais on peut y revenir, permet de jouer sur le terrain crée
    puis de le modifier *)
    | `Key (`Tab , _)       ->
      set !current_position !last_seen;
      game_mode := SandboxExec;
      sandbox ()
    | _                       -> sandbox_write_mode ()

(** [sandbox_exec_mode ()] permet de faire disparaitre la croix et de jouer au jeu étapes par étapes,
on contrôle chaques avancé dans la queue en appuyant sur Enter*)
and sandbox_exec_mode () =
  match Term.event terminal with
  | `Key (`Escape,       _)  -> exit 0   (* press <escape> to quit *)
  | `Key (`Enter,  _) ->
    run_one_step ();
    render ();
    sandbox ()
  | `Key (`ASCII 'q', _) ->
    set !current_position !last_seen;
    game_mode := Play;
    run_queue ();
  | `Key (`Tab , _)          ->
    game_mode := SandboxWrite;
    last_seen := get !current_position;
    set !current_position Cross;
    sandbox()
  | _                        -> sandbox_exec_mode ()

(** [sandbox ()] permet de jouer au jeu en mode sandbox et de jouer soit au write mode ou exec mode *)
and sandbox () : unit =
  if !game_mode = SandboxWrite then begin
    render();
    sandbox_write_mode () ;
  end
  else begin
    render();
    sandbox_exec_mode ();
  end;
