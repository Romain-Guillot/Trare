*Mamadou Diouldé Diallo - MDD22049622*
*Romain Guillot - GUIR15079709*

<h1 style="page-break-before: avoid !important;"> Remise VP - Analyse de la qualité</h1>

Ce rapport reprend la structure du rapport précédent, en y ajoutant le document concernant **l'analyse de qualité**.

Nous utilisons désormais **[le Github Wiki de l'application](https://github.com/Romain-Guillot/Trare/wiki)** pour éditer tous nos documents (techniques, spécifications, etc.). La lecture et la navigation entre les différents documents y sont bien plus aisées que sur un rapport PDF (bien que nous nous efforçons de produire un rendu de qualité à chaque fois !). Ce rapport est généré à partir du wiki de l'application, donc tous les éléments du wiki se trouvent aussi ici (et inversement, à l'exception de cette brève introduction).  
**PS: le sommaire de ce document met en évidences les élements ajoutés / grandement modifiés.**

## Liens utiles
- [Repository de l'application (Github)](https://github.com/Romain-Guillot/Trare)
- [Wiki de l'application (Github)](https://github.com/Romain-Guillot/Trare/wiki)

## Coordonnées
Si vous avez des remarques, suggestions, ou tout autres retours n'hésitez pas à nous contacter :
- [**Romain Guillot** - romain.guillot1@uqac.ca](mailto:romain.guillot1@uqac.ca)
- [**Mamadou Diouldé Diallo** - mamadou-dioulde.diallo1@uqac.ca](mailto:mamadou-dioulde.diallo1@uqac.ca)


## Changelog du rapport (depuis la R2)
- Ajout du document sur l'analyse de qualité
- Mise à jour du document d'architecture client pour refleter les changements effectués au niveau du packaging de l'application
- Mise à jour du document des **modèles** pour ajouter tous les modèles relatifs au système de communication
- Ajout du document de spécification de la fonctionnalité *"Système de communication associé à une activité"*
- Ajout du document du sprint 7
- Divers updates (screenshots, correctifs, etc.)
- Ajout de la license du projet


## Sommaire

Bienvenue sur le wiki de **Trare**.


- <span class="updated">[README](https://github.com/Romain-Guillot/Trare/blob/master/README.md)</span>
- [CONTRIBUTING](https://github.com/Romain-Guillot/Trare/blob/master/CONTRIBUTING.md)
- <span class="new">[LICENSE](https://github.com/Romain-Guillot/Trare/blob/master/LICENSE)</span>

#### Architecture
- <span class="updated">[Client app](https://github.com/Romain-Guillot/Trare/wiki/Architecture-:-client-side)
- <span class="updated">[Modèles](https://github.com/Romain-Guillot/Trare/wiki/Architecture-:-Modèles)</span>
- [Serveur](https://github.com/Romain-Guillot/Trare/wiki/Architecture-:-server-side)



#### Documents utiles

- [Description de l'application](https://github.com/Romain-Guillot/Trare/wiki/Description-de-l'application)
- <span class="updated">[Processus de travail](https://github.com/Romain-Guillot/Trare/wiki/Processus-de-travail)</span>
- [Déploiement](https://github.com/Romain-Guillot/Trare/wiki/Déploiement)
- [Tests (unit, integration, UI)](https://github.com/Romain-Guillot/Trare/wiki/Tests-(unit,-integration,-UI))
- <span class="new">[Analyse de qualité](https://github.com/Romain-Guillot/Trare/wiki/Analyse-de-qualité)</span>



#### Fonctionnalités

- [Authentification](https://github.com/Romain-Guillot/Trare/wiki/Fonctionnalité-:-Authentification)
- [Profil utilisateur](https://github.com/Romain-Guillot/Trare/wiki/Fonctionnalité-:-Profil-utilisateur)
- [Explore](https://github.com/Romain-Guillot/Trare/wiki/Fonctionnalité-:-Explore)
- [Création d'une activité](https://github.com/Romain-Guillot/Trare/wiki/Fonctionnalité-:-Création-d'une-activité)
- [Visualisation des activités créées par l'utilisateur](https://github.com/Romain-Guillot/Trare/wiki/Fonctionnalité-:-Visualisation-des-activités-créées-par-l'utilisateur)
- <span class="new">[Système de communication associé à une activité](https://github.com/Romain-Guillot/Trare/wiki/Fonctionnalité-:-Système-de-communication-associé-à-une-activité)</span>



#### Sprints

- [Sprint#1](https://github.com/Romain-Guillot/Trare/wiki/Sprint%231): set up, app architecture, authentication
- [Sprint#2](https://github.com/Romain-Guillot/Trare/wiki/Sprint%232): profile (edit, view)
- [Sprint#3](https://github.com/Romain-Guillot/Trare/wiki/Sprint%233): app layout, explore homepage
- [Sprint#4](https://github.com/Romain-Guillot/Trare/wiki/Sprint%234): explore homepage, R1, codemagic (CI/CD)
- [Sprint#5](https://github.com/Romain-Guillot/Trare/wiki/Sprint%235): form to create activity
- [Sprint#6](https://github.com/Romain-Guillot/Trare/wiki/Sprint%236): user activities page, user public page, installation guide
- <span class="new">[Sprint#7](https://github.com/Romain-Guillot/Trare/wiki/Sprint%237): activity participants, chats</span>



@import "wiki/README.md"

@import "wiki/CONTRIBUTING.md"


# License
```
MIT License

Copyright (c) 2020 RomainGuillot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```

# Architecture : client side
@import "wiki/Architecture-:-client-side.md"

# Architecture : Modèles
@import "wiki/Architecture-:-Modèles.md"

# Architecture : server side
@import "wiki/Architecture-:-server-side.md"

# Description de l'application
@import "wiki/Description-de-l'application.md"

# Processus de travail
@import "wiki/Processus-de-travail.md"

# Déploiement
@import "wiki/Déploiement.md"

# Tests (unit, integration, UI)
@import "wiki/Tests-(unit,-integration,-UI).md"

# Analyse de qualité
@import "wiki/Analyse-de-qualité.md"

# Authentification
@import "wiki/Fonctionnalité-:-Authentification.md"

# Profil utilisateur
@import "wiki/Fonctionnalité-:-Profil-utilisateur.md"

# Explore
@import "wiki/Fonctionnalité-:-Explore.md"

# Création d'une activité
@import "wiki/Fonctionnalité-:-Création-d'une-activité.md"

# Visualisation des activités créées par l'utilisateur
@import "wiki/Fonctionnalité-:-Visualisation-des-activités-créées-par-l'utilisateur.md"

# Système de communication associé à une activité
@import "wiki/Fonctionnalité-:-Système-de-communication-associé-à-une-activité.md"

# Sprint#1
@import "wiki/Sprint#1.md"

# Sprint#2
@import "wiki/Sprint#2.md"

# Sprint#3
@import "wiki/Sprint#3.md"

# Sprint#4
@import "wiki/Sprint#4.md"

# Sprint#5
@import "wiki/Sprint#5.md"

# Sprint#6
@import "wiki/Sprint#6.md"

# Sprint#7
@import "wiki/Sprint#7.md"












'Tests-(unit,-integration,-UI).md'
