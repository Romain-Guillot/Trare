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
  static const String accessibilityLoadingLabel = "Please wait...";


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
  static const String profileErrorRetry = "Retry";
  static const String profileSignOut = "Sign out 👋";
  static const String profileDelete = "Delete my account";
  static const String profileEdit = "Edit";

  // Profile edition
  static const String profileEditionInfo = "Configure your profile to let users get to know you a little better";
  static const String profileEditionTakePhoto = "Take photo";
  static const String profileEditionPickPhoto = "Add photo";
  static const String profileEditionSave = "Save";
  static const String profileEditionError = "An error occured";
  static const String profileEditionSuccess = "Profile successufully updated";


  // Explore
  static const String exploreTitle = "Explore";
  static const String exploreDescription = "Explore activities proposed by other users arround you.";
  static const String locationPermissionInfo = "Enable the location permission to look for activities near you";
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

}