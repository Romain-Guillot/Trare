# Planning : Sprint 1

## Itération 1
### Planning
**Durée​ :** 1ère semaine (du 20 au 26 janvier)
**Objectifs​ :**
- [x] Mise en place de notre environnement de travail (Git, système de communication, etc.);
- [x] Mise en place du projet Firebase (côté serveur);
- [x] Choix d’architecture côté client;
- [x] Développement de la fonctionnalité d’authentification (spéfication, implémentation et tests).

### Résulats

###### Environnement de travail
- Mise en place du système de versionning **Git** + hébergement du repository sur **Github**.  
- Installation des technologies (Flutter, Dart, Android SDK, IDE).  
- Mise en place d'un outils de *continuous integration* et *continuous delivery* : [CodeMagic](https://codemagic.io/start/). Configuration pour automatiser la phase de test + la phase de build automatiquement lors de *push* sur Github.  

**TODO:** configuration de la phase de deploiement sur Google Play.

###### Projet Firebase
Création du projet Firebase et activation du service **Firebase Authentication** pour implémenter la fonctionnalité. Configuration des nos environnement de travail dessus (pour la signature de l'application mobile)
Activation des méthodes d'authentification suivantes : Google, Facebook, et mail / mot de passe.

###### Architecture client

Voir `archi_appclient.md`.


###### Authentification

Voir `feature_authentification.md`

Presque tout a été réalisé :
- UI avec les boutons d'authentification (Google, Facebook, Email) ;
- le provider qui communique entre l'ui et le repository + fourni à l'UI l'utilisateur actuelle;
- le repository qui permet la communication avec Firebase pour les méthodes d'authentification suivants : Google et Facebook

**TODO:** Authentification (connexion / inscription) via email / mot de passe.













<!--  -->
