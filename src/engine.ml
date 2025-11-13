open Ui
open Effect
open Effect.Deep
open World

(** L'effet [End_of_turn] indique qu'une entité est prête à passer la main car elle a terminé
    son tour.*)
type _ Effect.t += End_of_turn: cell -> unit t

(** L'effet [Sandbox] indique que la croix a fait un tour, et peux passer au tour suivant *)
type _ Effect.t += Sandbox: unit t


(** [player ia] est appelé pour jouer le tour caractérisé par la fonction [ia].
    L'exécution de la fonction est arrêtée si l'effet [End_of_turn] ou [Sandbox] est perform
    et la continuation est enfilée dans [queue].*)
let player (character : unit -> unit) : unit =
  try character ()
  with
  | effect (End_of_turn c), k ->
    Queue.add ((fun () -> continue k ()), c) queuePlayer
  | effect Sandbox, k ->
    Queue.add ((fun () -> continue k ()), Cross) queueCross


(** [run_queue (queue)] exécute les fonctions correspondant aux tours successifs des entités du jeu.
    Si la file devient vide lors de la partie, la fonction lève l'exception [Queue.Empty].
    (le type de retour 'a s'explique par le fait que la fonction n'est pas censée terminer)*)
let run_queue (queue) : 'a =
  while true do
    render () ;
    let suspended_character, _ = Queue.pop queue in
    suspended_character () ;
  done

(** [run_one_step ()] exécute la fonction correspondant au tour de la première entitées de queuePlayer.
    Si la file devient vide lors de la partie, la fonction lève l'exception [Queue.Empty].*)
let run_one_step () : unit =
  render () ;
  let suspended_character, _ = Queue.pop queuePlayer in
  suspended_character ()
