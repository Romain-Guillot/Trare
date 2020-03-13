# Tests (unit, integration, UI)
*Dernière modification : 13 mar 2020*

## Introduction

Nous considérons 3 types de tests pour tester notre application :
- **Unit test** : test unitaire pour tester une méthode ou une classe
- **Widget test** : test lié à l'UI (aux widgets) pour vérifier le bon fonctionnement d'un widget (ce qu'il affiche, dans quelles conditions, etc.)
- **Integration test** : test une plus large partie de l'application (pas seulement un élément isolé mais plus globalement une fonctionnalité)


## Comment tester notre application ?

L'architecture utilisé pour le projet permet de facilement tester les différentes parties de l'application puisque le prince de *Separation Of Concerns* a bien été appliqué :

![](src/archi_client.png)

- Le package `ui` contient tous les widgets de l'application, cette partie doit être testée avec des *widget tests* ;
- Le package `logic` contient le business logic de l'application (son comportement), cette partie doit être testée avec des *unit tests* ;
- Le package `services` contient la communication avec la base de donnée, ces services seront utilisés pour les tests d'intégrations.

Les tests doivent être créés dans le package `test` de l'application, puis la structure naturelle est la suivante :
```
test/
    mocks/
        myservice_mock.dart
    units/
        myfile_test.dart
        ...
    widgets/
        ...
    integrations/
        ...
```

Les fichiers de tests doivent être suffixé par `_test.dart` comme l'indique la documentation :
> In general, test files should reside inside a test folder located at the root of your Flutter application or package. Test files should always end with `_test.dart`, this is the convention used by the test runner when searching for tests.
> **Source : [Flutter - An introduction to unit testing](https://flutter.dev/docs/cookbook/testing/unit/introduction)**

De plus, pour les tests unitaires la racine du nom du fichier, par convention, doit être la même que le fichier testé.   
Exemple :  
`activity_user_provider.dart`, et son fichier de test : `activity_user_provider_test.dart`

Les services mocks doivent être placé dans le `mocks` package et, comme avec les fichiers de tests unitaires, les fichiers de mock doivent être préfixés avec `_mock.dart`.  
Exemple:  
`profile_service.dart`, et son fichier mock : `profile_service_mock.dart`


## Lancer les tests
Les tests sont automatiquement lancer par Codemagic lorsqu'une version de l'application est publié sur une branche stable (sinon les phases de build et de deploiement sont annulées).

Pour vérifier que tous les tests passents : `flutter test`

## Mocking

> Mocking is a way of simulating parts of your app that are outside the scope of the test so that they behave in a specific way. Using mocking in your unit tests prevents tests from failing for reasons other than a flaw in your code, like an unstable network
> **Source : [raywenderlich.com](https://www.raywenderlich.com/6926998-unit-testing-with-flutter-getting-started)**

Donc, pour écrire nos tests unitaires, sachant que nos providers (business logic) dépendent des services, nous devront créer des mock services qui étendent des interfaces définissant nos services.

![](src/repo_provider_ex_mock.png)

Les mock services sont dans `test > mocks`.


## Current status

Providers | Documented | Covered by unit tests |
---|---|---|
AuthenticationProvider | ✔️ | ❌ |
ProfileProvider | ✔️ | ❌ |
ActivityUserProvider | ✔️ | ✔️ |
ActivityExploreProvider | ✔️| ✔️ |
ActivityCreationProvider | ✔️ | ❌ |
LocationPermissionProvider | ✔️ | ❌ |


## Références
- [Flutter - Testing Flutter apps](https://flutter.dev/docs/testing)
- [Unit Testing With Flutter: Getting Started](https://www.raywenderlich.com/6926998-unit-testing-with-flutter-getting-started)
