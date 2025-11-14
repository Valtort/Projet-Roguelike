(** Type du contenu d'une case du monde. *)
type cell = Empty | Cactus | Camel | Cookie | Snake | Elephant | Spider | Egg | Cross
type mode = SandboxWrite | SandboxExec | Play

let width, height = 50, 30
let nb_cookies = 10
let initial_vision = 3
let increase_vision = 2  (* Facteur multiplicateur pour le champ de vision *)
let use_vision = ref true  (* Si true, utilise le champ de vision ; si false, affiche tout *)

let queue : ((unit -> unit) * cell) Queue.t = Queue.create ();;

let game_mode = ref SandboxWrite;;

(** Le monde [world] est un tableau mutable. *)
let world : cell array array = Array.make_matrix width height Empty

(** [get (x,y)] renvoie le contenu de la case en position [x,y] du monde.
    Renvoie un cactus pour toutes les cases hors du monde.*)
let get (x, y : int * int) : cell = try world.(x).(y) with _ -> Cactus

(** [set (x,y) v] remplit la case en position [x,y] du monde avec l'entité [v].
    Lève [Exception: Invalid_argument] si la position est hors du monde.*)
let set (x, y : int * int) (v : cell) : unit = world.(x).(y) <- v


(** Stockage des informations de vision des camels *)
type camel_info = {
  position : int * int;
  vision : int;
}

(** Liste mutable contenant tous les camels avec leur vision *)
let camels_info : camel_info list ref = ref []

(** [register_camel pos vis] enregistre ou met à jour un camel à la position [pos] avec vision [vis] *)
let register_camel (pos : int * int) (vis : int) : unit =
  (* On efface toute la liste et on ne garde que le camel actuel *)
  (* (il n'y a qu'un seul camel dans le jeu) *)
  if get pos = Camel || get pos = Cross then
    camels_info := [{ position = pos; vision = vis }]
  else
    camels_info := []

(** [get_camels_info ()] renvoie la liste des informations de tous les camels *)
let get_camels_info () : camel_info list = !camels_info

(** [seen_map] stocke ce qui a été vu à chaque position (fog of war) *)
let seen_map : cell array array = Array.make_matrix width height Empty

(** [update_seen_map ()] met à jour la carte de ce qui a été vu en fonction des camels actuels *)
let update_seen_map () : unit =
  let camels = !camels_info in
  List.iter (fun camel ->
    let (cx, cy) = camel.position in
    let vision_range = increase_vision * camel.vision in
    for x = 0 to width - 1 do
      for y = 0 to height - 1 do
        if abs (x - cx) <= vision_range && abs (y - cy) <= vision_range then
          (* Met toujours à jour seen_map avec ce qui est actuellement visible *)
          (* Ainsi, si un élément a disparu/bougé, le camel verra la case vide/changée *)
          seen_map.(x).(y) <- world.(x).(y)
      done
    done
  ) camels

(** [get_seen (x, y)] renvoie ce qui a été vu à la position (x, y) *)
let get_seen (x, y : int * int) : cell =
  try seen_map.(x).(y) with _ -> Empty
