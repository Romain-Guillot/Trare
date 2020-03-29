# Planning : Sprint 7


ℹ️ **Préparation à distance à cause du covid19**

**CECI EST UN DOCUMENT DE DEBUT DE SPRINT ! IL N'EST PAS MIS A JOUR AVEC LES CHANGEMENTS EFFECTUES AU COURS DU DEVELOPPEMENT. VEUILLEZ VOSU REFERER AUX AUTRES DOCUMENTS QUI EUX SONT MIS A JOUR.**


**Fonctionnalité :** Système de contact entre les utilisateurs

**Objectifs du document :**
- Scope (description plus ou moins détaillée de la fonctionnalité)
- Considérations techniques (architecture, code, base de données)
- Liste des tâches à faire

**Concepts clés :** système de communication, créateur, participants, intéressés, message.


## Scope


Les activités seront associées à un **système de communication** pour mettre en contact les utilisateurs.

On considère 3 groupes d'utilisateur :
- **Le créateur :** l'utilisateur ayant créé l'activité
- **Les intéressés :** les utilisateurs voulant participer à l'activité
- **Les participants :** les utilisateurs participant à l'activité

Le système de communication consiste en une liste de **messages** envoyer par les participants et/ou le créateur. Ces messages peuvent être vu uniquement par les participants et/ou le créateur.

Pour pouvoir accécer à ce système de communication un utilisateur pourra demander à participer à l'activité, il fera donc parti du groupe des intéressés. Le créateur de l'activité pourra alors soit :
- **Accepter** la demande, l'utilisateur deviendra alors un participants
- **Ignorer** cette demande

Pour demander à participer à l'activité celle-ci ne doit pas être terminé (date de fin inférieure à la date actuelle).  

Le créateur, les intéressés et les participants pourront acceder à ce système de communication via une liste dans l'onglet "Chats". Voici les droits de visibilités des différents éléments :


| Élément      | Créateur | Participants | Intéressés |
| ------------ | -------- | ------------ |------------|
| Messages     | ✔️        | ✔️            | ❌         |
| Participants | ✔️        | ✔️            | ❌         |
| Demandes     | ✔️        | ❌           | ❌         |

Les intéressés n'ont accès à aucune info, un message d'attente sera affiché (*ex: "en attente de la réponse de ..."*)



![](https://i.imgur.com/Tk2iXW5.png)

> - bouton dans l'app bar : "details" ou "participants"
> - le bandeau orange est une indication visible par le créateur pour indiquer qu'il y a des demandes de participations
> - les demandes sont visibles uniquement par le créateur


## Considérations techniques (architecture, code, base de données)

### Model

![](https://i.imgur.com/4rqEY6U.png)


**Système de communication**

Propriétés | Contraintes | Remarques
---|---|---
activity |  | **requis**
participants | |
interested_users | |
messages | |

**Message**
Propriétés | Contraintes | Remarques
---|---|---
user |  | **requis**
content | | **requis**
date | | **requis**



### Base de données
Il faut stocker les éléments suivants:
- les utilisateurs intéressés
- les participants
- les messages

Pour cela on rajoute les champs suivants à une activités : **interested_user** et **participants**. Pour stocker les messages on rajoute la collection **messages** qui contiendra des documents representant les messages échangés. Un message contiendra sa **date de publication**, son **contenu** et **l'uid de l'utilisateur du message**.
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


### Architecture

- **Service :** récupération de système de communication, ajout de message, accepter / refuser un nouvel utilisateur
- **Provider :** un provider de gestion du système de communication d'une activité
- **UI :**
    - le chat de messages
    - le detail du chat (visualisation du créateur, des demandes et des participants)


## Liste des tâches

- [x] Définir model du système de communication (document + code)
- [x] Définir la structure de la base de données (document)
- [x] Création d'un nouveau service :
    - [x] Fonction : recupération du système de communication
    - [x] Fonction : ajout d'un message
    - [x] Fonction : accepter un nouvel utilisateur
    - [x] Fonction : refuser un nouvel utilisateur
- [x] Provider : gestion du système de communication d'une activité
- [x] UI : chat
- [x] UI : details du système de communication (demandes + participants)
