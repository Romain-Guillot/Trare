// Authors: Romain Guillot and Mamadou Diouldé Diallo
import 'package:app/models/activity.dart';
import 'package:app/models/user.dart';
import 'package:geolocator/geolocator.dart';


final user = User(uid: "uid");

final a1 = Activity(
  id: "uid1",
  title: "a1",
  beginDate: DateTime.fromMicrosecondsSinceEpoch(0),
  endDate: DateTime.fromMicrosecondsSinceEpoch(10000),
  createdDate: DateTime.fromMicrosecondsSinceEpoch(0),
  description: "a1 descr",
  location: Position(longitude: 50, latitude: 100),
  user: user
);

final a2 = Activity(
  id: "uid2",
  title: "a2",
  beginDate: DateTime.fromMicrosecondsSinceEpoch(100),
  endDate: DateTime.fromMicrosecondsSinceEpoch(500),
  createdDate: DateTime.fromMicrosecondsSinceEpoch(10),
  description: "a2 descr",
  location: Position(longitude: 0, latitude: 0),
  user: user
);
