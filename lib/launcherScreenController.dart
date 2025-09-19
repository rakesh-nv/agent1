// import 'package:get/get.dart';
// import 'package:mbindiamy/utils/app_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class LauncherScreenController extends GetxController{
//   bool isLogin = true;
//
//   ///check if user has Login or not
//   ///
//   ///if Logined
//   ///
//   ///[splashInit] will say if the user is logedIn or not and do some initial stuff
//   Future<bool> launchInit() async {
//     final SharedPreferences pref = await SharedPreferences.getInstance();
//     final loginDetails = pref.getString(AppConstants.keyToken);
//     print('Authorization Token from splashInit: $loginDetails');
//     if (loginDetails != null) {
//
//       if (language["status"]) {
//         ///language is present
//         UserData userData = language["data"];
//
//         ///
//       } else {
//         return false;
//
//       }
//       return true;
//     } else {
//       ///Navigate to login
//       return false;
//     }
//   }
// }