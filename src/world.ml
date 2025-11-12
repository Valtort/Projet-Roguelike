(** Type du contenu d'une case du monde. *)
type cell = Empty | Cactus | Camel

let width, height = 50, 30

(** Le monde [world] est un tableau mutable. *)
let world : cell array array = Array.make_matrix width height Empty

(** [get (x,y)] renvoie le contenu de la case en position [x,y] du monde. 
    Renvoie un cactus pour toutes les cases hors du monde.*)
let get (x, y : int * int) : cell = try world.(x).(y) with _ -> Cactus

(** [set (x,y) v] remplit la case en position [x,y] du monde avec l'entité [v].
    Lève [Exception: Invalid_argument] si la position est hors du monde.*)
let set (x, y : int * int) (v : cell) : unit = world.(x).(y) <- v