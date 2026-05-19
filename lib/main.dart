import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';
import 'common/app_motion.dart';
import 'constants/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const NakhlahApp());
}

class NakhlahApp extends StatelessWidget {
  const NakhlahApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Nakhlah 2.0',
    initialBinding: InitialBinding(),
    initialRoute: Routes.arabicLessonFlow,
    getPages: AppPages.pages,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.light,
    defaultTransition: Transition.cupertino,
    transitionDuration: AppMotion.page,
  );
}
