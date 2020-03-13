// Authors: Romain Guillot and Mamadou Diouldé Diallo

/// Model to represent a user
/// 
/// See the documentation `documents > archi_models.md` for more information
/// 
/// The class DOES NOT contain any logic inside ! It's not its responsability,
/// it's responsability it's just a representation of an user.
/// Some project used the models to convert the model to json ([Map]) of to
/// convert the json to the model for noSQL database. We decided to NOT do that 
/// here because these transformations are dependents of the noSQL dataabse
/// strucutre (name of fields). These transformations are directly applied 
/// in the corresponding services (through adapters)
class User {
  String uid;
  String name;
  String description;
  int age;
  String spokenLanguages;
  String country;
  String urlPhoto;

  User({
    this.uid,
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