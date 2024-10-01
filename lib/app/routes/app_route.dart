import 'package:get/get.dart';
import 'package:mypocket/App/Screens/SplashScreen/View/splash_screen.dart';

class AppRoutes {
  static String splashScreen = "/";

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
