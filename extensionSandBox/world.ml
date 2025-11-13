(** Type du contenu d'une case du monde. *)
type cell = Empty | Cactus | Camel | Snake | Elephant | Spider | Egg | Cross 

let width, height = 50, 30

(* Taille de l'affichage en dessous du plateau de joue pour montrer les commandes *)
let width_j,height_j = width + 20, 20


let width_p,height_p = 20, height + 20

(** Le monde [world] est un tableau mutable. *)
let world : cell array array = Array.make_matrix width height Empty
(* 
(** [pretty_printer] et [affichage_under] sont des tableaus mutables. *)
let affichage_under : cell array array = Array.make_matrix width_j height_j Empty

let pretty_printer : cell array array = Array.make_matrix width_p height_p Empty *)

(** [get (x,y)] renvoie le contenu de la case en position [x,y] du monde.
    Renvoie un cactus pour toutes les cases hors du monde.*)
let get (x, y : int * int) : cell = try world.(x).(y) with _ -> Cactus

(** [set (x,y) v] remplit la case en position [x,y] du monde avec l'entité [v].
    Lève [Exception: Invalid_argument] si la position est hors du monde.*)
let set (x, y : int * int) (v : cell) : unit = world.(x).(y) <- v
