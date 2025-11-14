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
  | Cookie     -> "\u{1F36A}"

(* Codes des emojis pour les animaux pertinents
   serpent : "\u{1F40D}"
   éléphant : "\u{1F418}"
   araignée : "\u{1F577} "
   oeuf : "\u{1F95A}"
   croix :  "\u{274C}"
   cookie : "\u{1F36A}"
   Des sites comme l'emojipedia peuvent vous donner plus de codes.
*)

(** [is_currently_visible (x,y)] vérifie si une case [(x, y)] est actuellement visible depuis au moins un camel *)
let is_currently_visible (x : int) (y : int) : bool =
  let camels = get_camels_info () in
  List.exists (fun camel ->
    let (cx, cy) = camel.position in
    let vision_range = increase_vision * camel.vision in
    (x - cx)*(x - cx) + (y - cy)*(y - cy) <= vision_range*vision_range
  ) camels

(* Fonctions de création de l'image correspondant à l'état actuel du monde.*)
let draw_cell (c : cell) : image = I.string A.empty (string_of_cell c);;

let vertical_bar : image = I.string A.empty "│";;
let horizontal_bar : image = I.string A.empty "─";;
let big_horizontal_bar : image = I.vcat @@ List.init (height + 2) (fun _ -> vertical_bar);;

(** [draw_coord (x,y)] affiche la case [(x,y)] de world en s'adaptant en fonction de l'extension 2*)
let draw_coord (x , y : int * int) : image =
  if not !use_vision || !game_mode <> Play || get_camels_info () = [] then
    (* Mode sans vision (!use_vison = false) : afficher tout le monde *)
    (* ou alors !game_mode n'est pas Play, c'est à dire: on est dans le mode sandbox*)
    (* ou alors il n'y a pas de chameaux sur le terrain *)
    draw_cell world.(x).(y)
  else if is_currently_visible x y then
    (* Case actuellement visible : afficher ce qui est vraiment là *)
    draw_cell world.(x).(y)
  else
    (* Case hors de vue : afficher un nuage *)
    I.string A.empty "\u{2601} "

(** Merci ChatGPT *)
let draw_world () : image =
  I.hcat
  @@
  big_horizontal_bar
  :: (Array.to_list
      @@ Array.mapi
           (fun x column ->
             I.vcat
             @@ horizontal_bar
             :: (Array.to_list
                 @@ Array.mapi
                      (fun y _cell -> draw_coord (x, y))
                      column)
             @ [ horizontal_bar ])
           world)
  @ [ big_horizontal_bar ]

(** [queue_nth q n] renvoie le n-ieme élément de la file *)
let queue_nth (q : 'a Queue.t) (n : int) : 'a  =
  if (n < 0) || (n >= Queue.length q) then failwith"queue_nth";
  let q_copy = Queue.copy q in
  (* Fonction auxiliaire qui parcourt la file *)
  let rec aux (i : int) : 'a =
    let x = Queue.take q_copy in
    if i = n then x else aux (i + 1)
  in
  aux 0

(** [draw_queue q] crée une image de la file [q]*)
let draw_queue (q : 'a Queue.t) : image =
  (* Choix arbitraire de taille de file *)
  let max_size = 25 in
  let text = "File d'exec" in
  let arrow_up = I.string A.empty "↑" in
  let title = I.string A.empty text in
  let q_copy = Queue.copy q in
  (* Fonction auxiliaire qui crée une liste d'éléments de type Cell (Camel, Elephant, Spider etc...)
  de taille maximal k*)
  let rec aux1 (k : int) : cell list =
    if (Queue.is_empty q_copy) || k = 0 then []
    else
      let _, c = Queue.pop q_copy in
      c :: aux1 (k-1)
  in
  let l = aux1 (max_size) in
  let cells = List.map draw_cell l in
  let images = title :: arrow_up :: cells @ [arrow_up] in

  (* Calcule de la largeur maximal pour pouvoir tout centrer*)
  let max_w =
    (* acc garde le max qu'on a vu parmis la liste de toutes les images *)
    List.fold_left (fun acc img -> max acc (I.width img)) 0 images
  in
  let centered_images =
    (* Centre chacunes des images en mettant du padding à gauche et à droite de l'image *)
    List.map
      (fun img ->
         let pad = (max_w - I.width img) / 2 in
         I.hpad pad pad img)
      images
  in
  I.vcat centered_images

(* Affiche les instructions en bas de l'écran *)
let instruction () =
  I.string A.empty @@
  match !game_mode with
    |SandboxWrite -> "c:\u{1F335} | a:\u{1F577} | g:\u{1F42A} | s:\u{1F40D} | e:\u{1F418} | o:\u{1F95A} | k: \u{1F36A} | arrows: move \u{274C} | q : play game (no going back) | TAB: switch to exec mode "
    |SandboxExec  -> "       ENTER : play one game step | q : play game (no going back) | TAB: switch to write mode"
    |Play         -> "                        Pour bouger les chameaux, utilisez les flèches";;

open Notty_unix

(** [terminal] est une constante qui correspond au terminal où le jeu est joué*)
let terminal : Term.t = Term.create ()

(** [render_sandbox ()]  met à jour l'affichage courant dans le terminal quand on est en mode sandbox
en affichant l'état de la file*)
let render_sandbox () = Term.image terminal (
  I.(<->)
    (I.(<|>)
        (draw_world ())
        (draw_queue queue))
    (instruction ())
  )

(** [render_play ()]  met à jour l'affichage courant dans le terminal quand on est en mode sandbox*)
let render_play () = Term.image terminal (
  I.(<->)
    (draw_world ())
    (instruction ())
  )

(** [render ()] met à jour l'affichage courant dans le terminal*)
let render () : unit = match !game_mode with
  | SandboxExec | SandboxWrite -> render_sandbox ()
  | Play                       -> render_play ();;


let () = render ()
