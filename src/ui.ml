open Notty
open World

(** Affichage du contenu d'une cellule.*)
let string_of_cell : cell -> string = function
  | Empty      -> "  "
  | Cactus     -> "\u{1F335}"
  | Camel      -> "\u{1F42A}"
  | Snake      -> "\u{1F40D}"
  | Elephant   -> "\u{1F418}"
  | Cookie   -> "\u{1F36A}"

(* Codes des emojis pour les animaux pertinents
   serpent : "\u{1F40D}"
   éléphant : "\u{1F418}"
   araignée : "\u{1F577} "
   oeuf : "\u{1F95A}"
   cookie : "\u{1F36A}"
   Des sites comme l'emojipedia peuvent vous donner plus de codes.
*)

(** Vérifie si une case (x, y) est actuellement visible depuis au moins un camel *)
let is_currently_visible (x : int) (y : int) : bool =
  let camels = get_camels_info () in
  List.exists (fun camel ->
    let (cx, cy) = camel.position in
    let vision_range = increase_vision * camel.vision in
    abs (x - cx) <= vision_range && abs (y - cy) <= vision_range
  ) camels

(** Fonctions de création de l'image correspondant à l'état actuel du monde.*)
let draw_cell (x : int) (y : int) : image =
  if not use_vision then
    (* Mode sans vision : afficher tout le monde *)
    I.string A.empty (string_of_cell world.(x).(y))
  else if is_currently_visible x y then
    (* Case actuellement visible : afficher ce qui est vraiment là *)
    I.string A.empty (string_of_cell world.(x).(y))
  else
    (* Case hors de vue : afficher ce qui a été vu (fog of war) *)
    let seen_cell = get_seen (x, y) in
    match seen_cell with
    | Cactus -> 
        (* Seuls les cactus (éléments statiques) sont affichés en fog of war *)
        I.string A.(fg lightblack) (string_of_cell seen_cell)
    | _ -> 
        (* Les animaux et cookies (éléments mobiles) ne sont pas affichés hors de la vision *)
        I.string A.empty "  "

let draw_world () : image =
  let width = Array.length world in
  let height = Array.length world.(0) in
  I.hcat
  @@ List.init width (fun x ->
         I.vcat
         @@ List.init height (fun y -> draw_cell x y))



open Notty_unix

(** [terminal] est une constante qui correspond au terminal où le jeu est joué*)
let terminal : Term.t = Term.create ()

(** [render ()] met à jour l'affichage courant dans le terminal*)
let render () : unit = 
  update_seen_map ();
  Term.image terminal (draw_world ())
let () = render ()
