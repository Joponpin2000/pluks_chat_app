import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceAppFreshInstallKey = "ISFRESHINSTALL";
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserCountryKey = "USERCOUNTRYKEY";
  static String sharedPreferenceUserCityKey = "USERCITYKEY";
  static String sharedPreferenceUserIdKey = "USERIDKEY";
  static String sharedPreferenceUserImageUrlKey = "USERIMAGEURLKEY";

  // Save data to shared preference

  static Future<bool> saveAppFreshInstallSharedPreference(
      bool isFreshInstall) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(
        sharedPreferenceAppFreshInstallKey, isFreshInstall);
  }

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserImageUrlSharedPreference(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserImageUrlKey, imageUrl);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserCitySharedPreference(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserCityKey, city);
  }

  static Future<bool> saveUserCountrySharedPreference(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserCountryKey, country);
  }

  static Future<bool> saveUserIdSharedPreference(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserIdKey, id);
  }

  // Get data from shared preference

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<bool> getAppFreshInstallSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceAppFreshInstallKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserImageUrlSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserImageUrlKey);
  }

  static Future<String> getUserCitySharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserCityKey);
  }

  static Future<String> getUserCountrySharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserCountryKey);
  }

  static Future<String> getUserIdSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserIdKey);
  }

  List<String> emojis = [
    "😀",
    "😁",
    "😂",
    "🤣",
    "😃",
    "😄",
    "😅",
    "😆",
    "😉",
    "😊",
    "😋",
    "😎",
    "😍",
    "😘",
    "😗",
    "😙",
    "😚",
    "🙂",
    "🤗",
    "🤔",
    "😮",
    "😥",
    "😣",
    "😏",
    "😶",
    "🙄",
    "😑",
    "😐",
    "🤐",
    "😯",
    "😪",
    "🙈",
    "🙉",
    "🙊",
    "👀",
    "👄",
    "🛌",
    "🚣‍♀️",
    "🏄‍♂️",
    "🏋️‍♂️",
    "🚴‍♂️",
    "🤳",
    "💪",
    "👉",
    "✌",
    "👌",
    "👍",
    "✊",
    "👊",
    "🤛",
    "🤜",
    "🎉",
    "✨",
  ];
}
