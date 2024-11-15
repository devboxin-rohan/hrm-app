import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrm_app/app/data/local/hive_database.dart';
import 'package:hrm_app/app/utils/background_worker.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveDatabase.init(); // Initialize Hive and open boxes

  // BackgroundWorker.initialize();
  // BackgroundWorker.registerBackgroundTask();

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'HRM App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Load the light theme by default
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
