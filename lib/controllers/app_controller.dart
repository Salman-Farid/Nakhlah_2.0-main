import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AppController extends GetxController {
  AppController(this.storage);
  final StorageService storage;
  final tabIndex = 0.obs;
  void decideStart() {
    Future.delayed(const Duration(milliseconds: 650), () {
      if (storage.isLoggedIn) {
        Get.offAllNamed(Routes.shell);
        setTab(0);
      } else {
        Get.offAllNamed(Routes.getStarted);
      }
    });
  }

  void setTab(int i) => tabIndex.value = i;
}
