# Projet-Roguelike

Ce projet nécessite Ocaml 5.3.

Il est nécessaire d'avoir les packages Notty et dune qui peuvent être installés avec :
```bash
opam install notty
opam install dune
```

Ce projet contient 2 fichiers : 
- Le fichier BaseGame qui contient le jeu de base (Q1/Q2/Q3).
- Le fichier Extensions qui contient les 3 extensions réalisées.

## BaseGame 

Nous nous sommes permis de modifier le code de base en enlevant le fait de ```render ()``` à chaques fois qu'une entitées bouge, et nous faisons un affichage seulement après que le chameau ai performé ```End_of_turn``` de ce fait on gagne grandement en performances lorsqu'il y a beaucoup d'araignées sur la carte et le gameplay n'est pas impacté.

### Lancement du jeu et tests


Il faut d'abord ce placer dans le fichier BaseGame/ puis  compiler avec 
```dune build```, on peut ensuite lancer le jeu avec ```dune exec rogue```.

Pour les tests, il suffit de faire ```dune test``` après avoir compiler.

### Gameplay
Vous controler un chameau (avec les flèches directionnelles) sur une carte où sont placés aléatoirement des cactus, il y a également : 
- Un éléphant qui charge pendant 10 tours s'il voit le chameau, et est immobilisé pendant 20 tours s'il percute un cactus pendant sa charge.
- Un serpent qui se déplace aléatoirement.
- Une araignée qui peut pondre des oeufs avec une probabilité de 1% (modifiable) et qui se déplace aléatoirement.
- Des oeufs qui font apparaitrent des araignées tous les 20 tours. Leur durée de vie est de 60 tours.

### Fichiers du jeu 
Les fichiers de bases : 
- Le fichier `world.ml` contient les types et fonctions nécessaires pour décrire et modifier le monde du jeu. Le monde est un tableau mutable global de cases qui peuvent héberger (au plus) une entitée.
- Le fichier `ui.ml` contient le nécessaire pour afficher le jeu et interagir avec lui.
- Le fichier `engine.ml` contient le moteur principal du jeu, qui gère la piscine de threads. Le moteur est basé sur une file où attendent les threads d’exécution des entités en pause. A chaque nouveau tour, une entité est défilée et la continuation de son exécution est exécutée jusqu’à terminaison, ou jusqu’à ce qu’elle lève l’effet `End_of_turn` (auquel cas elle est réinsérée dans la file).
- Le fichier `utils.ml` contient des fonctions qui sont utiles à tous les types d’entités (se déplacer par exemple).
- 🐪 Le fichier `player.ml` contient les fonctions nécessaires pour contrôler le personnage jouable (le chameau), et éteindre le jeu. La fonction camel d´ecrit le comportement du chameau : attendre une entrée clavier, l’exécuter, et recommencer via un appel récursif.
- 🐍 Le fichier `snake.ml` contient la fonction nécessaire pour faire bouger aléatoirement le serpent. Une fonction ```random_direction``` présente dans `utils.ml` et permet de donné une direction aléatoire, que la case adjacente soit vide ou non (si la case adjacente est non vide, alors l'entité ne bouge pas).
- 🐘 Le fichier `elephant.ml` contient les fonctions nécessaires pour implémenter les déplacement de l'éléphant tels que décrit plus haut.
- 🕷️ 🥚 Le fichier `spider.ml` contient les fonctions nécessaires pour implémenter les déplacement de l'araignée ainsi que le fonctionnement des oeufs tels que décrit plus haut.
- Le fichier `main.ml` est en charge d’initialiser l’état du monde au début du jeu et de lancer la boucle de jeu principale.

## Extensions

### Lancement du jeu et tests


Il faut d'abord ce placer dans le fichier Extensions/ puis  compiler avec 
```dune build```, on peut ensuite lancer le jeu avec TODO : écrire les différents noms de fichiers qu'on a crée avec dune genre mainsb pour sandbox.

Pour les tests, il suffit de faire ```dune test``` après avoir compiler.

### Extension 1 : A* 

### Extension 2 : Champ de vision et cookies

### Extension 3 : Sandbox
Nous avons rajouté une entité croix (Cross) : ❌, celle-ci peut se déplacer n'importe où sur la carte, y compris par dessus d'autre entités, pour ce faire on mémorise dans `last_seen` la dernière entité que l'on a écrasé, et on la replace quand on pars de la case où elle était auparavant.


### Modifications des fichiers de bases
