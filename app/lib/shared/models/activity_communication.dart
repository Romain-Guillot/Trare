// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/user.dart';
import 'package:flutter/foundation.dart';


/// Model to represent the communication system of an activity
/// 
/// See the documentation `documents > archi_models.md` for more information
/// 
/// The class DOES NOT contain any logic inside ! It's not its responsability,
/// it's responsability it's just a representation of an activity.
/// Some project used the models to convert the model to json ([Map]) of to
/// convert the json to the model for noSQL database. We decided to NOT do that 
/// here because these transformations are dependents of the noSQL dataabse
/// strucutre (name of fields). These transformations are directly applied 
/// in the corresponding services (through adapters)
class ActivityCommunication {
  Activity activity;
  List<User> participants;
  List<User> interestedUsers;

  ActivityCommunication({
    @required this.activity,
    this.participants,
    this.interestedUsers,
  });
}



/// Model to represent a message of the [ActivityCommunication] chat
/// 
/// See the documentation `documents > archi_models.md` for more information
/// 
/// The class DOES NOT contain any logic inside ! It's not its responsability,
/// it's responsability it's just a representation of an activity.
/// Some project used the models to convert the model to json ([Map]) of to
/// convert the json to the model for noSQL database. We decided to NOT do that 
/// here because these transformations are dependents of the noSQL dataabse
/// strucutre (name of fields). These transformations are directly applied 
/// in the corresponding services (through adapters)
class Message {
  String id;
  String content;
  User user;
  DateTime publicationDate;

  Message({
    this.id,
    this.user,
    @required this.content,
    @required this.publicationDate,
  });

  void setUser(User user) {this.user = user;}
}