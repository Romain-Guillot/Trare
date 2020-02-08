# Architecture : Architecture application client
*Dernière modification : 8 fev 2020*


Voici le schéma d'architecture globale côté client :

![](src/architecture_globale.png)

Concrétement, `ui`, `logic` et `repositories` sont des dossiers (packages). `logic` et `repositories` contiendront sûrement uniquement des fichiers (assez peu nombreux au final). Par contre, `ui` sera sans doute séparé en plusieurs sous-dossier, le nombre de widgets pouvant être assez importants, il sera nécessaire de créer des sous-dossiers afin de mieux les organiser.
