// import 'package:workmanager/workmanager.dart';

// const String backgroundTaskKey = "backgroundTask";

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     // Background task logic here (e.g., sync data)
//     print("Background task executed: $task");
//     return Future.value(true);
//   });
// }

// class BackgroundWorker {
//   static void initialize() {
//     Workmanager().initialize(
//       callbackDispatcher,
//       isInDebugMode: true,
//     );
//   }

//   static void registerBackgroundTask() {
//     Workmanager().registerPeriodicTask(
//       "1",
//       backgroundTaskKey,
//       frequency: Duration(hours: 1), // Set your desired frequency
//     );
//   }
// }
