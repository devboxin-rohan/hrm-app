// set up the AlertDialog
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAlertDailog extends StatelessWidget {
  dynamic appVersion;
  dynamic latestVersion;
  dynamic link;
  dynamic forceUpdate;

  UpdateAlertDailog(
      {required this.appVersion,
      required this.latestVersion,
      this.link,
      this.forceUpdate});

  // DashboardDetail() {
  //   AttendanceService()
  //       .getAttandanceDetail()
  //       .then((value) => SharedData().setDashboardDetail(value.data));
  // }

  _launchURL(context) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      AlertNotification.error("Url Error", 'Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: const Text(
        "Please update your app with the latest app",
        style: AppColors.subtitleBoldStyle,
      ),
      content: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 5),
        height: 20,
        // child: Text("${appVersion} to ${latestVersion}"),
      ),
      actions: [
        forceUpdate == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      maximumSize: WidgetStatePropertyAll(Size(140, 45)),
                      minimumSize: WidgetStatePropertyAll(Size(140, 45)),
                    ),
                    onPressed: () {
                      _launchURL(context);
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      maximumSize: WidgetStatePropertyAll(Size(110, 45)),
                      minimumSize: WidgetStatePropertyAll(Size(110, 45)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancle",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      maximumSize: WidgetStatePropertyAll(Size(110, 45)),
                      minimumSize: WidgetStatePropertyAll(Size(110, 45)),
                    ),
                    onPressed: () {
                      _launchURL(context);
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
      ],
    );
  }
}

// AlertDialog alert =
