import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveFileToPersistentStorage(File file) async {
  final directory = await getApplicationDocumentsDirectory(); // Use persistent storage directory
  final path = directory.path;
  final newFilePath = "$path/${file.uri.pathSegments.last}";

  final newFile = await file.copy(newFilePath);
  return newFile.path; // Return the persistent file path
}
