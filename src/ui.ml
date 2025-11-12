open Notty
open World

(** Affichage du contenu d'une cellule.*)
let string_of_cell : cell -> string = function
  | Empty      -> "  "
  | Cactus     -> "\u{1F335}"
  | Camel      -> "\u{1F42A}"

(* Codes des emojis pour les animaux pertinents
   serpent : "\u{1F40D}"
   éléphant : "\u{1F418}"
   araignée : "\u{1F577} "
   oeuf : "\u{1F95A}"
   Des sites comme l'emojipedia peuvent vous donner plus de codes.
*)

(** Fonctions de création de l'image correspondant à l'état actuel du monde.*)
let draw_cell (c : cell) : image = I.string A.empty (string_of_cell c)

let draw_world () : image =
  I.hcat
  @@ Array.to_list
  @@ Array.map
       (fun column -> I.vcat @@ Array.to_list @@ Array.map draw_cell column)
       world


open Notty_unix

(** [terminal] est une constante qui correspond au terminal où le jeu est joué*)
let terminal : Term.t = Term.create ()

(** [render ()] met à jour l'affichage courant dans le terminal*)
let render () : unit = Term.image terminal (draw_world ())
let () = render ()