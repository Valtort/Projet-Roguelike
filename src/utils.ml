open World

(** Déplacement d'une entité *)

(** Opérateur somme pour les paires d'entiers*)
let ( ++ ) (x, y : int * int) (dx, dy : int * int) : int * int =
  (x + dx, y + dy)

(** [move old_pos new_pos] déplace le contenu de la case en [old_pos] vers la case [new_pos].
    Si la case [new_pos] est occupé, laisse le monde inchangé.
    Renvoie [new_pos] si le mouvement a eu lieu, et [old_pos] sinon.*)
let move (old_position : int * int) (new_position : int * int) : int * int =
  match get new_position with
  | Empty ->
      let character = get old_position in
      set old_position Empty ;
      set new_position character ;
      new_position
  | _ -> old_position

(** [correct_coordinates coord] renvoi [true] si les coordonnées coord sont
valides, et [false] sinon *)
let correct_coordinates ((x, y): int * int) : bool =
  (0 <= x) && (x < width) && (0 <= y) && (y < height);;

(** [correct_coordinates (x,y)] vérifie si la coordonnée [(x,y)] est correct *)
let correct_coordinates (x, y) : bool =
  (0 <= x) && (x < width) && (0 <= y) && (y < height);;

(** [random_direction ()] renvoie une direction aléatoire *)
let random_direction () : int * int =
  let random_dir = Random.int 4 in
  match random_dir with
  | 0 -> (- 1, 0)
  | 1 -> (+ 1, 0)
  | 2 -> (0, + 1)
  | 3 -> (0, - 1)
  | _ -> (0, 0);;

let is_cactus (x, y) = (world.(x).(y) = Cactus);;
let is_camel(x, y) = (world.(x).(y) = Camel);;
let is_empty(x, y) = (world.(x).(y) = Empty);;
