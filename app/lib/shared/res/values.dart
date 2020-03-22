/// Values share across the app that are not related to the UI 
/// 
/// See [Dimens] for constants used for the UI
/// 
/// Everything is constant, so the constructor is private
/// as it makes no sense to create an instance of this class.
class Values {
  Values._();

  static const int profileUsernameMinLength = 6;
  static const int profileUsernameMaxLength = 40;

  static const int profileAgeMinValue = 18;
  static const int profileAgeMaxValue = 100;

  static const int profileDescriptionMinLength = 20;
  static const int profileDescriptionMaxLength = 500;

  static const int profileLanguagesMaxLength = 100;

  static const int profileCountryMaxLength = 50;

  static const double mapDefaultZoom = 9;
  static const double mapCircleRadius = 6000;
}