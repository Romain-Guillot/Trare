# Architecture : Modèles
*Dernière modification : 8 fev 2020*

## User
TBD

## Activité

Propriétés | Contraintes | Remarques
---|---|---
date de création | | utile principalement pour le tri
titre | 6 < len < 50 |
utilisateur |  | l'utilisateur proposant l'activité
description | 20 < len < 500 |
date de début | > date de création |  date à partir de laquelle l'utilisateur est disponible pour l'activité
date de fin | > date de fin | date limite jusqu'à laquelle l'utilisateur n'est plus disponible pour effectué l'activité
localisation | | localisation approximative de l'activités, des coordonnées GPS afin de pouvoir utiliser la position dans des algorithmes *de proximité*
