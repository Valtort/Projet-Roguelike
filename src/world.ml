(** Type du contenu d'une case du monde. *)
type cell = Empty | Cactus | Camel | Snake | Elephant | Spider | Egg | Cross

type mode = Write | Exec

let width, height = 50, 30

let sandbox_mode = ref Write;;

(** Le monde [world] est un tableau mutable. *)
let world : cell array array = Array.make_matrix width height Empty

(** [get (x,y)] renvoie le contenu de la case en position [x,y] du monde.
    Renvoie un cactus pour toutes les cases hors du monde.*)
let get (x, y : int * int) : cell = try world.(x).(y) with _ -> Cactus

(** [set (x,y) v] remplit la case en position [x,y] du monde avec l'entité [v].
    Lève [Exception: Invalid_argument] si la position est hors du monde.*)
let set (x, y : int * int) (v : cell) : unit = world.(x).(y) <- v


(** File de threads
   [queuePlayer] contient toutes les entités en attente de leur prochain tour,
   sous forme de fonctions [ia]. Pour chaque entité, [ia ()] va jouer le code de l'entité
   correspondant à son prochain tour. *)
let queuePlayer : ((unit -> unit) * cell) Queue.t = Queue.create ()

(** File de threads
   [queueCross] contient une seule entitée, la croix. *)
let queueCross : ((unit -> unit) * cell) Queue.t = Queue.create ()
