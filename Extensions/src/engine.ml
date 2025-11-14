open Ui
open Effect
open Effect.Deep
open World

(** L'effet [End_of_turn] indique qu'une entité est prête à passer la main car elle a terminé
    son tour.*)
type _ Effect.t += End_of_turn: cell -> unit t


(** File de threads
   [queue] contient toutes les entités en attente de leur prochain tour,
   sous forme de fonctions [ia]. Pour chaque entité, [ia ()] va jouer le code de l'entité
   correspondant à son prochain tour. *)

(** [player ia] est appelé pour jouer le tour caractérisé par la fonction [ia].
    L'exécution de la fonction est arrêtée si l'effet [End_of_turn] ou [Sandbox] est perform
    et la continuation est enfilée dans [queue].*)
let player (character : unit -> unit) : unit =
  try character ()
  with
  | effect (End_of_turn c), k ->
    Queue.add ((fun () -> continue k ()), c) queue


(** [run_queue (queue)] exécute les fonctions correspondant aux tours successifs des entités du jeu.
    Si la file devient vide lors de la partie, la fonction lève l'exception [Queue.Empty].
    (le type de retour 'a s'explique par le fait que la fonction n'est pas censée terminer)*)
let run_queue () : 'a =
  while true do
    render () ;
    if (not (Queue.is_empty queue)) then begin
      let suspended_character, _ = Queue.pop queue in
      suspended_character () ;
    end;
  done

(** [run_one_step ()] exécute la fonction correspondant au tour de la première entitées de queue.
    Si la file devient vide lors de la partie, la fonction lève l'exception [Queue.Empty].*)
let run_one_step () : unit =
  render () ;
  if (not (Queue.is_empty queue)) then begin
      let suspended_character, _ = Queue.pop queue in
      suspended_character ()
  end
