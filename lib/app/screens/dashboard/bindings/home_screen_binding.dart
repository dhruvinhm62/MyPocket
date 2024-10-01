import 'package:get/get.dart';
import 'package:mypocket/app/screens/dashboard/controller/home_screen_controller.dart';

class BookingDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(
      () => HomeScreenController(),
    );
  }
}
