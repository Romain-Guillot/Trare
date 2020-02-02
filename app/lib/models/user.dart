// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: TODO

///
///
class User {
  String name;
  String description;
  int age;
  String spokenLanguages;
  String country;
  String urlPhoto;

  User({
    this.name, 
    this.description, 
    this.age, 
    this.spokenLanguages, 
    this.country, 
    this.urlPhoto
  });

  @override
  String toString() => "Name : $name";
}