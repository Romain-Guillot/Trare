
/// Asset names available in the app (see pubspec.yaml) to see all out assets.
/// So to add an asset:
///   1. import the asset inside the assets/ directory
///   2. include the asset name inside the pubspec.yaml
///   3. includ the asset here
/// With this class we can change the asset name or the asset location without
/// change our implementation 
/// (it avoids hard-coding the names of the assets in our widgets in essence)
/// 
/// Everything is constant, so the constructor is private
/// as it makes no sense to create an instance of this class.
class Assets {
  Assets._();

  static const String logo = "assets/logo.svg";

  static const String google = "assets/google.svg";
  static const String facebook = "assets/facebook.svg";
  static const String mail = "assets/mail.svg";

  static const String startup = "assets/startup_image.svg";
}