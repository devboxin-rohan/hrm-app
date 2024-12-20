import 'dart:io';
import 'package:camera/camera.dart';
import 'package:my_logger/logger.dart';
import 'package:my_logger/logger_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class Logging {
  init() {
    var config = MyLogger.config;
    config.isDevelopmentDebuggingEnabled = false;
    config.timestampFormat = TimestampFormat.TIME_FORMAT_FULL_3;

    MyLogger.applyConfig(config);
  }

  requestPermission() {
    final Permission _permissionGroup = Permission.storage;
    Future<void> requestPermission(Permission permission) =>
        permission.request();
  }

  LoggerPrint(error) {
    MyLogger.info(
      error,
      dataLogType: DataLogType.DEFAULT,
    );
  }

  exportFile() async {
    File fileExport = await MyLogger.logs.export(
      fileName:"Report-"+DateTime.now().toString(),
      exportType: FileType.TXT,
      filter: LogFilter.last24Hours(),
    );

    Share.shareXFiles([XFile(fileExport.path)], text: 'Report File ',);

    print("Logs are exported into: $fileExport");
  }
}
