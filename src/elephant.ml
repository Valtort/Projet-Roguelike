open Notty_unix
open Ui
open Utils
open Effect
open Effect.Deep
open Engine
open World

let can_see_caml ((x_e, y_e) : int * int) : bool * (int * int) =
  let see_caml = ref false
  and dir = ref (0, 0)
  and x = ref x_e and y = ref y_e in
  while (not !see_caml) || (!x) < width || not (is_empty (!x, !y)) do
    if (is_camel (!x, !y)) then (see_caml := true; dir := (1, 0));
    incr x
  done;
  while (not !see_caml) || (!x) >= 0 || not (is_empty (!x, !y)) do
    if (is_camel (!x, !y)) then (see_caml := true; dir := (-1, 0));
    decr x
  done;
  while (not !see_caml) || (!y) < height || not (is_empty (!x, !y)) do
    if (is_camel (!x, !y)) then (see_caml := true; dir := (0, 1));
    incr y
  done;
  while (not !see_caml) || (!y) >= 0 || not (is_empty (!x, !y)) do
    if (is_camel (!x, !y)) then (see_caml := true; dir := (0, -1));
    decr y
  done;
  !see_caml, !dir;;

let rec elephant (current_position : int * int) : unit =
  let see_caml, (dir_x, dir_y) = can_see_caml current_position in
  if see_caml then begin
    for i=0 to 9 do
      let new_position = current_position ++ (dir_x, dir_y) in
      let new_position = move current_position new_position in
      render ();
      perform End_of_turn;
      if (i = 9) then elephant new_position;
    done
  end
  else begin
    let new_position = current_position ++ random_direction () in
    let new_position = move current_position new_position in
    perform End_of_turn;
    render ();
    elephant new_position;
  end
