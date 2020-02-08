# Fonctionnalité : Explore
*Dernière modification : 8 fev 2020*

*Explore* fait partie des fonctionnalités principales de l'application. Une fois l'utilisateur connecté, la page *Explore* est affichée (lors de l'ouverture de l'application normale via le launcher d'application).

La page *Explore* a pour objectif d'afficher les activités pouvant intéresser l'utilisateur. La problématique majeure est donc de savoir **comment choisir ces activités**.

Dans un premier temps, l'algorithme de selection des activités sera basique :
- l'activité devra avoir une localisation *proche* de la localisation de l'utilisateur (proche = rayon d'acceptance - valeur fixée arbitrairement);
- les activités seront triées par ordre de date de création décroissante.

D'un point de vue UI, une liste des activités doit être affichée avec les informations suivantes pour chaque activité :
- Le titre
- Le lieu
- La plage de date (début, fin)
- La photo de l'utilisateur

Dans un premier temps, la page contiendra uniquement la liste des activités. Voici cependant quelques pistes d'amélioration :
- proposer de **changer la localisation** (par exemple si il veut prévoir un futur voyage dans une nouvelle destination)
- **Changer le rayon d'acceptance** des activités par rapport à la localisation effective (celle de l'appareil ou celle choisie)
