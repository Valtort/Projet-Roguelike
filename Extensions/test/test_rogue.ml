open Roguelib
open World
open Utils
open Elephant
open Spider
open Sandbox

(** [reset_world ()] reinitialse le monde *)
let reset_world () : unit =
  for i = 0 to width - 1 do
    for j = 0 to height - 1 do
      world.(i).(j) <- Empty;
    done;
  done


(*-------------------------------------------*)
(*------ Test pour le fichier world.ml ------*)
(*-------------------------------------------*)

let test_world () =
  reset_world ();
  set (10,20) Camel;
  assert(get (10,20) = Camel && world.(10).(20) = Camel);
  assert(get (width+1, height+1) = Cactus)

(*-------------------------------------------*)
(*------ Test pour le fichier utils.ml ------*)
(*-------------------------------------------*)

let test_utils () =
  reset_world ();
  assert((2,4) ++ (5,7) = (7,11));
  set (10,20) Camel;
  let _ = move (10,20) (20,20) in
  assert(get (20,20) = Camel);
  assert(get (10,20) = Empty);
  let _ = move (20,20) (width+1, height+1) in
  assert(get (20,20) = Camel);
  assert(correct_coordinates (10,20));
  assert(not (correct_coordinates (width+1, height+1)));
  let directions = [(- 1, 0);(+ 1, 0);(0, + 1);(0, - 1);] in
  assert(List.mem (random_direction ()) directions);
  assert(is_camel (20,20))

(*-------------------------------------------*)
(*-----Test pour le fichier elephant.ml------*)
(*-------------------------------------------*)

let test_elephant () =
  reset_world ();
  set (10,20) Camel;
  assert(dir_to_camel (10,10) = (0,1));
  set (10, 15) Cactus;
  assert(dir_to_camel (10,10) = (0,0));
  assert(cactus_front (10,14) (0,1) = true);
  assert(cactus_front (9,15) (1,0) = true);
  assert(cactus_front (10,15) (1,0) = false)

(*-------------------------------------------*)
(*----- Test pour le fichier spider.ml ------*)
(*-------------------------------------------*)

let test_spider () =
  reset_world ();
  set (10,10) Cactus;
  set (8,10) Cactus;
  assert(adjacent_empty_cells (9,10) = [|(9,9); (9,11)|]);
  set (8,10) Empty;
  assert(adjacent_empty_cells (9,10) = [|(9,9); (8,10);(9,11)|]);
  set (10,10) Empty;
  assert(adjacent_empty_cells (9,10) = [|(10,10);(9,9); (8,10);(9,11)|])


(*-------------------------------------------*)
(*-----Test pour le fichier snake.ml------*)
(*-------------------------------------------*)


let _: cell array array =
  [|
    [|Empty; Empty; Empty; Empty; Empty; Empty|];
    [|Empty; Cactus; Cactus; Cactus; Cactus; Empty|];
    [|Empty; Empty ; Empty ; Snake ; Cactus; Empty|];
    [|Empty; Cactus; Cactus; Cactus; Cactus; Empty|];
    [|Empty; Empty ; Empty ; Empty ; Empty ; Empty|];
    [|Empty; Empty ; Empty ; Camel ; Empty ; Empty|];
  |];;

(*-------------------------------------------*)
(*----- Test pour le fichier sandbox.ml------*)
(*-------------------------------------------*)
(*               Extension 3                 *)
let test_sandbox () =
  reset_world ();
  current_position := (0,0);
  set (0,0) Cross;
  last_seen := Empty;
  move_cross (10,10);
  assert(get (0,0) = Empty);
  assert(get (10,10) = Cross);
  set (20,20) Cactus;
  move_cross (20,20);
  assert(get (20,20) = Cross);
  move_cross (25,25);
  assert(get (25,25) = Cross);
  assert(get (20,20) = Cactus);;

(*-------------------------------------------*)
(*----- Test pour les fichiers utils.ml -----*)
(*-----          et world.ml            -----*)
(*-------------------------------------------*)
(*               Extension 2                 *)

let test_ext2 () =
  (* Fonctions de utils.ml *)
  reset_world ();
  set (10,10) Cactus;
  set (11,11) Camel;
  set (11,12) Camel;
  set (11,13) Camel;
  set (0,12) Camel;
  set (1,12) Cookie;
  let pos_l = get_camel_pos () in
  assert (List.mem (11,11) pos_l);
  assert (List.mem (11,12) pos_l);
  assert (List.mem (11,13) pos_l);
  assert (List.mem (0,12) pos_l);
  assert (not (List.mem (10,10) pos_l));

  (* Fonctions de world.ml *)
  reset_world ();
  assert(get_camels_info () = []);
  set (10,10) Camel;
  register_camel (10,10) 2;
  assert(get_camels_info () = [{ position = (10,10); vision = 2 }]);
  update_seen_map ();;


let () =
  test_world();
  print_string"Test world : réussi !\n";
  test_utils();
  print_string"Test utils : réussi !\n";
  test_elephant();
  print_string"Test elephant : réussi !\n";
  test_spider();
  print_string"Test spider : réussi !\n";
  test_sandbox();
  print_string"Test sandbox (extension 3) : réussi !\n";
  test_ext2();
  print_string"Test extension 2 : réussi !\n";
  print_string"Tous les tests ont réussis !\n";;
