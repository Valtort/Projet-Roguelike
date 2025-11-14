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

Nous nous sommes permis de modifier le code de base en enlevant le fait de ```render ()``` à chaques fois qu'une entités bouge, et nous faisons un affichage seulement après que le chameau ai performé ```End_of_turn``` de ce fait on gagne grandement en performances lorsqu'il y a beaucoup d'araignées sur la carte et le gameplay n'est pas impacté.

### Lancement du jeu et tests

Il faut d'abord se placer dans le fichier BaseGame/ puis  compiler avec dune

```bash
cd BaseGame
dune exec rogue
```

Pour efectuer les tests, il suffit de faire :
```bash
cd BaseGame
dune build
dune test
```

### Gameplay
Vous contrôlez un chameau (avec les flèches directionnelles) sur une carte où sont placés aléatoirement des cactus, il y a également :
- Un éléphant qui charge pendant 10 tours s'il voit le chameau, et est immobilisé pendant 20 tours s'il percute un cactus pendant sa charge.
- Un serpent qui se déplace aléatoirement.
- Une araignée qui peut pondre des oeufs avec une probabilité de 1% (modifiable) et qui se déplace aléatoirement.
- Des oeufs qui font apparaitrent des araignées tous les 20 tours. Leur durée de vie est de 60 tours.

### Fichiers du jeu
Les fichiers de bases :
- Le fichier `world.ml` contient les types et fonctions nécessaires pour décrire et modifier le monde du jeu. Le monde est un tableau mutable global de cases qui peuvent héberger (au plus) une entité.
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


Il faut d'abord se placer dans le fichier Extensions/ puis  compiler avec dune :

```bash
cd Extensions
dune exec rogue
```

Pour efectuer les tests, il suffit de faire :
```bash
cd Extensions
dune build
dune test
```

### Extension 1 : Dijkstra
Dans la version extension, le serpent ne bouge plus aléatoirement mais adopte l’attitude suivant :
- aller vers le chameau le plus proche si un chameau est accessible
- bouger dans une direction aléatoire si aucun chameau n’est accessible

De plus, si un chameau est accessible, le serpent ne se déplace qu’un tour sur deux, sinon le serpent harcèle le chameau et ce n’est pas très marrant à jouer.

---

### Extension 2 : Champ de vision et cookies
>[!NOTE]
>On suppose ici qu'il n'y a qu'un seul chameau dans le jeu.

- On peut activer/desactiver cette extension avec  la variable globale `use_vision` située dans le fichier `world.ml`, false pour le jeu de base, true pour le jeu avec extension.

- Les cookies : 

    - On place `nb_cookies`(ici 10) aléatoirement sur la carte intialement.

    - Les chamaux peuvent manger les cookies en se déplaçant dessus.

    - Seuls les chamaux peuvent manger les cookies et se déplacer sur les cases contenant les cookies.

    - Chaque cookie augmente le champ de vision de `increase_vision` (ici 2).

- Le fonctionnement du champ de vision est un brouillard de guerre (fog of war) : 

<img width="1221" height="727" alt="image" src="https://github.com/user-attachments/assets/7c666f67-8714-465c-851f-7bb9e0d0e3ca" />


---

### Extension 3 : Sandbox

> [!IMPORTANT]
> Il faut que la variable `use_vision` de l'extension 2 soit à false pour utiliser le mode sandbox sans l'extension 2 !

### La croix
Nous avons rajouté une entité croix : ❌ dont les fonctions sont implémentées dans `sandbox.ml`, celle-ci peut se déplacer n'importe où sur la carte, y compris par-dessus d'autres entités, pour ce faire on mémorise dans `last_seen` la dernière entité que l'on a écrasé, et on la replace quand on pars de la case où elle était auparavant.

La croix est initialement placé à la case (`width/2`, `height/2`).

### Les commandes
Pour déplacé la croix, on utilise les flèches directionnelles.

Voici une liste des touches permettant de placer des entités sur la carte :
- a : 🕷️
- c : 🌵
- e : 🐘
- g : 🐪
- k : 🍪
- o : 🥚
- s : 🐍

Pour changer entre mode exécution et mode écriture, il faut appuyer sur `Tab`.

- Dans le mode écriture, on peut poser des entités (mais pas les supprimer !).

- Dans le mode exécution, on peut appuyer sur `Enter` pour simuler un tour du jeu.

> [!NOTE]
> On peut appuyer sur "q" pour quitter DEFINITIVEMENT le mode écriture et lancer la partie sans avoir à appuyer sur `Enter` pour avancer de tour en tour.

### Pretty-print
On affiche à droite du jeu la file d'exécution, celle-ci affiche la prochaine entité qui doit jouer. Elle est de taille limitée à TODO : mettre la valeur qu'on aura choisit.

On a modifié l'effet `End_of_turn` pour que celui-ci mémorise l'entité qui a levé `End_of_turn`. Ex : `End_of_turn Camel`, `End_of_turn Spider` etc...
### Suppression d'entités
Nous n'avons pas pu ajouter la suppression d'entités car il fallait également supprimer l'entité de la file de threads.

### Illustration du jeu
<img width="1227" height="733" alt="image" src="https://github.com/user-attachments/assets/60913f50-ce2d-4d7e-ad04-75c6602febad" />

Mode écriture :
<img width="1381" height="776" alt="image" src="https://github.com/user-attachments/assets/21290e9b-7338-4bd9-8765-4fef80ab6472" />

Mode exécution :
<img width="1373" height="757" alt="image" src="https://github.com/user-attachments/assets/3d5a26a7-dd33-4cc8-8b5c-62855e71d7b2" />


---

### Modifications des fichiers de bases
