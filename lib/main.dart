import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';
import 'common/app_motion.dart';
import 'constants/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Register the auth/token services before startup refresh so the whole app
  // uses the same ApiService + StorageService instances after reload.
  final storage = Get.put(StorageService(), permanent: true);
  Get.put(ApiService(storage), permanent: true);

  await _refreshSessionOnStartup();
  runApp(const NakhlahApp());
  _startSessionRefreshTimer();
}

Timer? _sessionRefreshTimer;

void _startSessionRefreshTimer() {
  _sessionRefreshTimer?.cancel();
  _sessionRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
    if (!Get.isRegistered<StorageService>() ||
        !Get.isRegistered<ApiService>()) {
      return;
    }

    final storage = Get.find<StorageService>();
    if (!storage.isLoggedIn || !storage.isTokenExpired) return;

    await Get.find<ApiService>().refreshAccessToken();
  });
}

Future<void> _refreshSessionOnStartup() async {
  final storage = Get.find<StorageService>();
  if (!storage.isLoggedIn) return;

  await Get.find<ApiService>().refreshAccessToken();
}

class NakhlahApp extends StatelessWidget {
  const NakhlahApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Nakhlah 2.0',
    initialBinding: InitialBinding(),
    initialRoute: Routes.splash,
    getPages: AppPages.pages,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.light,
    defaultTransition: Transition.cupertino,
    transitionDuration: AppMotion.page,
  );
}
