open Roguelib
open World
open Utils
open Elephant
open Spider

(*-------------------------------------------*)
(*------ Test pour le fichier world.ml ------*)
(*-------------------------------------------*)

let test_world () =
  set (10,20) Camel;
  assert(get (10,20) = Camel && world.(10).(20) = Camel);
  assert(get (width+1, height+1) = Cactus)

(*-------------------------------------------*)
(*------ Test pour le fichier utils.ml ------*)
(*-------------------------------------------*)

let test_utils () =
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
  set (10,10) Cactus;
  set (8,10) Cactus;
  assert(adjacent_empty_cells (9,10) = [|(9,9); (9,11)|]);
  set (8,10) Empty;
  assert(adjacent_empty_cells (9,10) = [|(9,9); (8,10);(9,11)|]);
  set (10,10) Empty;
  assert(adjacent_empty_cells (9,10) = [|(10,10);(9,9); (8,10);(9,11)|])

let () =
  test_world();
  print_string"Test world : réussi !\n";
  test_utils();
  print_string"Test utils : réussi !\n";
  test_elephant();
  print_string"Test elephant : réussi !\n";
  test_spider();
  print_string"Test spider : réussi !\n";
  print_string"Tous les tests ont réussis !\n"
