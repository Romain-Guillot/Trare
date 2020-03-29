# Architecture : Modèles
*Dernière modification : 29 mar 2020*

Voici le diagramme de classe à jour avec le **sprint#7**.

![](src/class_diagram.png)

**Ces différents modèles sont contenu dans le package suivant : `lib.shared.models`**

## User


Propriétés | Contraintes | Remarques
---|---|---
name | 6 < len < 40 | **requis**
description | 20 < len < 500 |
age | 18 < value < 100 |
langues parlées | len < 100 |
pays | len < 50 |  
photos |  |  

## Activité

Propriétés | Contraintes | Remarques
---|---|---
date de création | | **auto-généré**. Utile principalement pour le tri
titre | 6 < len < 50 | **requis**
utilisateur |  | **auto-généré**. L'utilisateur proposant l'activité
description | 20 < len < 500 | **requis**
date de début | > date de création | **requis**. Date à partir de laquelle l'utilisateur est disponible pour l'activité
date de fin | > date de fin |**requis**. Date limite jusqu'à laquelle l'utilisateur n'est plus disponible pour effectué l'activité
localisation | | **requis**. Localisation approximative de l'activités, des coordonnées GPS afin de pouvoir utiliser la position dans des algorithmes *de proximité*

*Note: une propriété **auto-générée** implique que le champs est **requis**.*

## Système de communication d'une activité
Propriétés | Contraintes | Remarques
---|---|---
activité | | **requis**
utilisateurs intéressés | |
participants | |


## Un message du chat d'une activité
Propriétés | Contraintes | Remarques
---|---|---
content | non vide | **requis**
user | | **requis**
date de publication |  | **requis**



<!-- eof -->
