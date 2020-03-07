import 'package:app/models/user.dart';
import 'package:app/services/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';





void main() {

  group("FiresoreProfileService", () {

  });

  group("_FirestoreUserAdapter", () {
    var map1;
    var map2 = {Identifiers.USER_NAME: "name"};
    var map3 = {
      Identifiers.USER_NAME: "name",
      Identifiers.USER_PHOTO: "photo",
      Identifiers.USER_LOCATION: "location",
      Identifiers.USER_LANGUAGES: "languages",
      Identifiers.USER_DESCRIPTION: "description",
      Identifiers.USER_PHOTO: "photo",
      Identifiers.USER_AGE: 0
    };

    var user1 = FirestoreUserAdapter(uid: "1", userData: map1);
    var user2 = FirestoreUserAdapter(uid: "2", userData: map2);
    var user3 = FirestoreUserAdapter(uid: "3", userData: map3);
    

    test("Constructor", () {
      expect(user1, isInstanceOf<User>());

      expect(user1.name, null);
      expect(user1.age, null);
      expect(user1.country, null);
      expect(user1.description, null);
      expect(user1.urlPhoto, null);
      expect(user1.spokenLanguages, null);

      expect(user2.name, "name");
      expect(user2.age, null);
      expect(user2.country, null);
      expect(user2.description, null);
      expect(user2.urlPhoto, null);
      expect(user2.spokenLanguages, null);

      expect(user3.name, "name");
      expect(user3.age, 0);
      expect(user3.country, "location");
      expect(user3.description, "description");
      expect(user3.urlPhoto, "photo");
      expect(user3.spokenLanguages, "languages");
    });

    var user4 = User(name: "name", age: 0);
    var userToMap1 = FirestoreUserAdapter.toMap(user1);
    var userToMap2 = FirestoreUserAdapter.toMap(user3);
    var userToMap3 = FirestoreUserAdapter.toMap(user4);
    
    test("to map", () {
      expect(userToMap1, isInstanceOf<Map>());

      expect(userToMap1[Identifiers.USER_NAME], null);
      expect(userToMap1[Identifiers.USER_AGE], null);
      expect(userToMap1[Identifiers.USER_DESCRIPTION], null);
      expect(userToMap1[Identifiers.USER_PHOTO], null);
      expect(userToMap1[Identifiers.USER_LOCATION], null);
      expect(userToMap1[Identifiers.USER_LANGUAGES], null);

      expect(userToMap2[Identifiers.USER_NAME], "name");
      expect(userToMap2[Identifiers.USER_AGE], 0);
      expect(userToMap2[Identifiers.USER_DESCRIPTION], "description");
      expect(userToMap2[Identifiers.USER_PHOTO], "photo");
      expect(userToMap2[Identifiers.USER_LOCATION], "location");
      expect(userToMap2[Identifiers.USER_LANGUAGES], "languages");

      expect(userToMap3[Identifiers.USER_NAME], "name");
      expect(userToMap3[Identifiers.USER_AGE], 0);
      expect(userToMap3[Identifiers.USER_DESCRIPTION], null);
      expect(userToMap3[Identifiers.USER_PHOTO], null);
      expect(userToMap3[Identifiers.USER_LOCATION], null);
      expect(userToMap3[Identifiers.USER_LANGUAGES], null);
    });
    
  });
}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockQuery extends Mock implements Query {}