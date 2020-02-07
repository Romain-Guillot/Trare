// Authors: Romain Guillot and Mamadou Diouldé Diallo
//
// Doc: TODO
// Tests: TODO

///
///
///
class Activity{
  String title;
  String location;
  String duration;
  String urlPhoto;

  String get getTitle => title;
  String get getLocation=> location;
  String get getDuration => duration;
  String get getUrlPhoto => urlPhoto;


  Activity({
    this.title,
    this.location,
    this.duration,
    this.urlPhoto,
  });



}





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