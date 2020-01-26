/// [String] constants shared across our widgets.
/// 
/// Everything is constant, so the constructor is private
/// as it makes no sense to create an instance of this class.
class Strings {
  Strings._();

  // General
  static const String appName = "TBD";
  static const String snakbarActionDismissed = "Ok";
  
  // Constants related to authentication
  static const String authenticationTitle = "Welcome,";
  static const String authenticationDescription = "Ready to share activities with travellers arround you ?";
  static const String buttonProviderSuffixText = "Continue with";
  static const String googleProvider = "Google";
  static const String facebookProvider = "Facebook";
  static const String emailProvider = "Email";
  static const String alternativeAuthenticationMethodeSeparotor = "OR";
  static const String authenticationError = "An error occured. Please try again";
}