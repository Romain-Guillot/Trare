# Architecture : server-side
*Dernière modification : 29 mar 2020*


## Technologies
Nous avons choisi de stocker nos données avec **Firebase**, notamment avec les services suivants :

- **Firebase Authentication:** gestion des utilisateurs
- **Cloud Storage:** stockage des fichiers (photos par exemple)
- **Cloud Firestore:** stockage des données (base de données)

Voici les raisons qui ont menées à choisir **Firebase** :
- **Très bien intégré à Flutter via la suite de plugin [flutterfire](https://github.com/FirebaseExtended/flutterfire).** Ces plugins qui permettent d'accéder aux services de Firebase sont maintenus par l'équipe de Firebase. Cela permet d'avoir des plugins mis à jour rapidement lors de changements de Firebase.
- **La simplicité d'utilisation** : nous avons une équipe réduite (2 personnes), aucun d'entre nous a déjà eu de l'expérience dans la mise en place / configuration de serveurs. Utiliser un système *serverless* permet de nous abstraire beaucoup de contraintes
- **La gratuité du service pour commencer** : pas besoin d'investir de l'argent, le plan gratuit permet de subvenir à nos besoins durant le developpement
- **Familiarité avec le service** : nous avons déjà quelques connaissances de base de certains services Firebase
- **Mesures de qualités** : Firebase ne permet pas uniquement le stockage de données mais fourni aussi des services permettant d'avoir des mesures de qualités de notre applications (performances, crash, app distribution, etc)
- **Évolution** : Firebase fourni aussi d'autres services qui peuvent être utiles pour la suite : Google Analytics pour analyser le comportement de nos utilisateurs, A/B testing, etc.

## Données / structure
### Utilisateur
Voir `archi_models.md > #Users` pour davantage information à propos des utilisateurs.
###### Connexion / inscription
*Firebase Authentication* est utilisé pour gérer la connexion des utilisateurs via les façons suivantes :
- email / mot de passe
- Facebook
- Google

###### Données
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

###### Photo

Les photos des utilisateurs sont stockées dans *Cloud Storage* dans le dossier `users_photos`.

TBD: Définir les limites de tailles d'image / compression / format / etc.



### Activité

Voici la structure noSQL des données des activités :

```
col:activities
    doc:id#1
        - createdDate: date
        - title: text
        - user: text
        - description: text
        - beginDate: date
        - endDate: date
        - location:
            - geohash: text
            - geopoint: geographical point
    doc:id#2
        ...
    ...
```
Note: l'attribut `user` stocke l'ID de l'utilisateur ayant créé l'activité.  
Note: l'attribut `location` est composé de 2 éléments pour effectuer des requêtes "par proximité spatiale" grâce au geohash
> Geohash is a public domain geocode system invented in 2008 by Gustavo Niemeyer[1] and (similar work in 1966) G.M. Morton[2], which encodes a geographic location into a short string of letters and digits. It is a hierarchical spatial data structure which subdivides space into buckets of grid shape.


### Chat / système de communication

Il faut stocker les éléments suivants:
- les utilisateurs intéressés
- les participants
- les messages

Pour cela on rajoute les champs suivants à une activités : **interested_user** et **participants**. Pour stocker les messages on rajoute la collection **messages** qui contiendra des documents representant les messages échangés. Un message contiendra sa **date de publication**, son **contenu** et **l'uid de l'utilisateur du message**.
```
col:activities
    doc:id#1
        ... (see above)

        - interested_users: array of text
        - participants: array of text
        - col:messages
            - doc:message#1
                - publication_date: date
                - content: text
                - user: text
            -doc:message#2
                ...
            -doc:message#3
                ...

    doc:id#2
        ...
    ...
```








<!--  -->
