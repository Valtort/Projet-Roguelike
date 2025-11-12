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

(** Vérifie si la case [(x,y)] est vide*)
let is_empty ((x,y) : int*int) = 
  world.(x).(y) = Empty

(** Vérifie si un cactus est présent sur la case [(x,y)] *)
let is_cactus ((x,y) : int*int) = 
  world.(x).(y) = Cactus

(** Vérifie si un chameau est présent sur la case [(x,y)] *)
let is_camel ((x,y) : int*int) = 
  world.(x).(y) = Camel

