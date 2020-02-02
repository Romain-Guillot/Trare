# Architecture : Firebase

Les données sont stockées dans les services de **Firebase**, notamment les services suivants :

- **Firebase Authentication:** gestion des utilisateurs
- **Cloud Storage:** stockage des fichiers (photos par exemple)
- **Cloud Firestore:** stockage des données (base de données)

Voici les raisons qui ont menées à choisir **Firebase** :
- **Intégré à Flutter via la suite de plugin [flutterfire](https://github.com/FirebaseExtended/flutterfire).** Ces plugins qui permettent d'accéder aux services de Firebase sont maintenus par l'équipe de Firebase. Cela permet d'avoir des plugins mis à jour rapidement lors de changements de Firebase.
- **Support hors-ligne et système de cache.** Les modifications effectuées sont effectuées sur une base de données locale puis *merge* sur la base de données *online*. Cela permet d'avoir un support "hors-ligne" (par exemple, une perte de connexion temoraire sera transparent pour l'utilisateur pour l'ajout de données puisque les données seront d'abord insérée sur la BDD locale). Les plugins ont aussi un système de cache performant pour eviter des multiples accès à une même resource.
- **La gratuité du service pour commencer**
- **La simplicité d'utilisation**

## Utilisateur
##### Connexion / inscription
*Firebase Authentication* est utilisé pour gérer la connexion des utilisateurs via les façons suivantes :
- email / mot de passe
- Facebook
- Google

##### Données
Voici la structure noSQL des données des utilisateurs :
```
col:users
    doc:uid#1
        - name: text
        - age: integer
        - description: text
        - country: text
        - languages: text
        - photo: text        
    doc:uid#2
        ...
    ...
```
Note: l'attribut `photo` des utilisateurs est une URL vers la photo de profile de l'utilisateur. Cette URL correspond à la photo stocké sur *Cloud Storage* voir ci-dessous.

##### Photo

Les photos des utilisateurs sont stockées dans *Cloud Storage* dans le dossier `users_photos`.

TODO: Définir les limites de tailles d'image / compression / format / etc.















<!--  -->
