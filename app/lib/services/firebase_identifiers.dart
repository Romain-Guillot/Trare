

/// Identifiers (name of collections / fields) used in the Cloud Firestore
/// 
/// See the corresponding specification `documents > archi_server.md` (french)
class FBQualifiers {
  // Users (USE)
  static const USE_COL = "users";
  static const USE_NAME = "name";
  static const USE_DESCRIPTION = "description";
  static const USE_AGE = "age";
  static const USE_LOCATION = "country";
  static const USE_LANGUAGES = "languages";
  static const USE_PHOTO = "photoURL";

  // Activity (ACT)
  static const ACT_COL = "activities";
  static const ACT_CREATED_DATE = "createdDate";
  static const ACT_TITLE = "title";
  static const ACT_USER = "user";
  static const ACT_DESCRIPTION = "description";
  static const ACT_BEGIN_DATE = "beginDate";
  static const ACT_END_DATE = "endDate";
  static const ACT_LOCATION = "location";
  static const ACT_INTERESTED = "interested_users";
  static const ACT_PARTICIPANTS = "participants";

  // Message (MSG)
  static const MSG_COL = "messages";
  static const MSG_DATE = "publication_date";
  static const MSG_USER = "user";
  static const MSG_CONTENT = "content";
  static const MSG_ACTIVITY_ID = "id_activity";
}