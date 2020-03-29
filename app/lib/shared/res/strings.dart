import 'package:intl/intl.dart';


/// [String] constants shared across our widgets.
/// 
/// Everything is constant, so the constructor is private
/// as it makes no sense to create an instance of this class.
class Strings {
  Strings._();

  // General
  static const String appName = "TBD";
  static const String snakbarActionDismissed = "Ok";
  static const String loading = "Loading ...";
  static const String unexpectedError = "This wasn't supposed to happen... 😳";
  static const String availableSoon = "Stay tuned, available soon 🙏";
  static const String enable = "Enable";
  static const String grant = "Autorize";
  static const String accessibilityLoadingLabel = "Please wait...";
  static const String addActivity = "Add activity";
  static const String reload = "Retry";
  static const String error = "Error";



  // Layout
  static const String navBarExplore = "Explore";
  static const String navBarChats = "Chats";
  static const String navBarMyActivities = "My activities";
  static const String navBarProfile = "Profile";

  
  // Constants related to authentication
  static const String authenticationTitle = "Welcome,";
  static const String authenticationDescription = "Ready to share activities with travellers arround you ?";
  static const String buttonProviderSuffixText = "Continue with";
  static const String googleProvider = "Google";
  static const String facebookProvider = "Facebook";
  static const String emailProvider = "Email";
  static const String alternativeAuthenticationMethodeSeparotor = "OR";
  static const String authenticationError = "An error occured. Please try again";


  // Profile general
  static const String profileUsername = "Username";
  static const String profileDescription = "Description";
  static const String profileCountry = "Country";
  static const String profileSpokenLanguages = "Spoken languages";
  static const String profileAge = "Age";
  static const String profileUnknownName = "Unknown";


  // Profile visualization
  static const String profileLoading = "Loading ...";
  static const String profileError = "An error occured while loading your profile";
  static const String profileSignOut = "Sign out";
  static const String profileDelete = "Delete my account";
  static const String profileEdit = "Edit";


  // Profile edition
  static const String profileEditionInfo = "Configure your profile to let users get to know you a little better";
  static const String profileEditionTakePhoto = "Take photo";
  static const String profileEditionPickPhoto = "Add photo";
  static const String profileEditionSave = "Save";
  static const String profileEditionError = "An error occured";
  static const String profileEditionSuccess = "Profile successufully updated";
  static const String profileDeleteInfo = "This action cannot be undone. This will permanently delete your account";
  static const String profileDeleteVerificationLabel = "I'm sure";
  static const String profileDeleteButton = "Delete my account";
  static const String profileDeleteError = "Please log out and log in again to confirm your action.";
  static const String profileDescriptionEditionInfo = "Consider translating your description into the languages you speak.";

  // Explore
  static const String exploreTitle = "Explore";
  static const String exploreDescription = "Explore activities proposed by other users arround you.";
  static const String databaseErrorInfo = "Sorry there is an erro accessing the database";


  // Activity view
  static const String activityViewLoadingPos = "Loading position ...";
  static const String activityMapViewCaption = "Discuss with the host for the exact location";
  static String activityDateRange([DateTime d1, DateTime d2]) {
    var dateFormat = DateFormat.yMMMd();
    if (d1 == null && d2 == null)
      return null;
    if (d1 == null && d2 != null)
      return "Until ${dateFormat.format(d2)}";
    if (d1 != null && d2 == null)
      return "From ${dateFormat.format(d1)}";
    return "Between ${dateFormat.format(d1)} and ${dateFormat.format(d2)}";
  }
  static const String iAmInterested = "I'm interested";
  static const String unknownLocation = "Unknown location";
  static const String activityEnded = "Ended";


  // Activity creation
  static const String activityCreationDescription = "Create a new activity to propose it to other users of the application.";
  static const String addActivityButton = "Add the activity";
  static const String activityTitleLabel = "Title";
  static const String activityDescriptionLabel = "Description";
  static const String activityBeginDateLabel = "Begin date";
  static const String activityEndDateLabel = "End date";
  static const String activityLocationLabel = "Location";
  static const String errorEndDateBeforeBeginDate = "The end date must be after the begin date";


  // User activities
  static const String userActivitiesTitle = "My activities";
  static const String userActivitiesError = "Unable to load your activities";

  // Form
  static const String invalidFormEmpty = "Cannot be empty";
  static const String invalidFormTooShort = "Too short";
  static String invalidFormRangeValue({int min, int max}) {
    if (min == null && max == null)
      return "Invalid range";
    if (min == null && max != null)
      return "Cannot exceed $max";
    if (min != null && max == null)
      return "Must be at least $min";
    return "Must be comprised between $min and $max";
  } 
  static const String optionalTextField = "Optional";
  static const String requiredTextField = "Required";
  static String textFieldMinLengthCounter(int remainingLength) {
    return "Too short, add $remainingLength more character" + (remainingLength > 1 ? "s" : "");
  }
  static const String requiredMap = "Required";
  static const String requiredDate = "Required";


  // Activity communication
  static const String participantRequestsTitle = "Requests";
  static const String participantsTitle = "Participants";
  static const String participantAcceptRequest = "Accept";
  static const String participantRejectRequest = "Reject";
  static const String activityChat = "chat";
  static const String noParticipant = "No participant yet";
  static const String chatUnableToLoad = "Unable to load chat";
  static const String participationNotYetAccepted = "The user who created the activity has to validate your participation request.";
  static const String participationNotYetAcceptedStayTuned = "Stay tuned !";

  // User chats
  static const String userChatsTitle = "Chats";
  static const String userChatsLoadingError = "Unable to load your chats";


  // Permissions
  static const String locationPermissionDenied = "You have not granted the location permission";
  static const String locationPermissionDisabled = "Please enable the location service";
  static const String locationPermissionUnknonw = "Unable to retrieve your position";
}