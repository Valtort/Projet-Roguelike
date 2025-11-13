open Notty
open World

(** Affichage du contenu d'une cellule.*)
let string_of_cell : cell -> string = function
  | Empty      -> "  "
  | Cactus     -> "\u{1F335}"
  | Camel      -> "\u{1F42A}"
  | Snake      -> "\u{1F40D}"
  | Elephant   -> "\u{1F418}"
  | Spider     -> "\u{1F577}"
  | Egg        -> "\u{1F95A}"
  | Cross      -> "\u{274C}"

(* Codes des emojis pour les animaux pertinents
   serpent : "\u{1F40D}"
   éléphant : s"\u{1F418}"
   araignée : "\u{1F577} "
   oeuf : "\u{1F95A}"
   croix :  "\u{274C}"
   Des sites comme l'emojipedia peuvent vous donner plus de codes.
*)

(** Fonctions de création de l'image correspondant à l'état actuel du monde.*)
let draw_cell (c : cell) : image = I.string A.empty (string_of_cell c);;

let vertical_bar : image = I.string A.empty "│";;
let horizontal_bar : image = I.string A.empty "─";;
let big_horizontal_bar : image = I.vcat @@ List.init (height + 2) (fun _ -> vertical_bar);;


let draw_world () : image =
  I.hcat
  @@
  big_horizontal_bar::(
  Array.to_list
  @@ Array.map
       (fun column -> I.vcat @@ horizontal_bar::(Array.to_list @@ Array.map draw_cell column)@[horizontal_bar])
       world)@[big_horizontal_bar]

let queue_nth q n =
  if n < 0 || n >= Queue.length q then invalid_arg "queue_nth";
  let q_copy = Queue.copy q in
  let rec aux i =
    let x = Queue.take q_copy in
    if i = n then x else aux (i + 1)
  in
  aux 0

let draw_queue q =
  let text = "File de Prio" in
  let arrow_up = I.string A.empty "↑" in
  let title = I.string A.empty text in
  let q_copy = Queue.copy q in
  let rec aux1 () =
    if Queue.is_empty q_copy then []
    else
      let _, c = Queue.pop q_copy in
      c :: aux1 ()
  in
  let l = aux1 () in
  let cells = List.map draw_cell l in
  let images = title :: arrow_up :: cells @ [arrow_up]in

  (* Compute max width to center everything *)
  let max_w =
    List.fold_left (fun acc img -> max acc (I.width img)) 0 images
  in
  let centered_images =
    List.map
      (fun img ->
         let pad = (max_w - I.width img) / 2 in
         I.hpad pad pad img)
      images
  in
  I.vcat centered_images

let instruction () =
  I.string A.empty @@
  match !sandbox_mode with
    |Write -> "       c:\u{1F335} | a:\u{1F577} | g:\u{1F42A} | s:\u{1F40D} | e:\u{1F418} | o:\u{1F95A} | arrows: move \u{274C} | TAB: switch to exec mode"
    |Exec -> "          ENTER : one step | q : play game (no going back) | TAB: switch to write mode"

open Notty_unix

(** [terminal] est une constante qui correspond au terminal où le jeu est joué*)
let terminal : Term.t = Term.create ()

(** [render ()] met à jour l'affichage courant dans le terminal*)
let render () : unit = Term.image terminal (
  I.(<->)
    (I.(<|>)
        (draw_world ())
        (draw_queue queue))
    (instruction ())
  )

let () = render ()
