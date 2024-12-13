import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/service/attendance.dart';
import 'package:hrm_app/app/service/auth.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/CheckInternet.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/app/utils/help.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// FooterBar Widget (Stateful)
class FooterBar extends StatefulWidget {
  const FooterBar({Key? key}) : super(key: key);

  @override
  _FooterBar createState() => _FooterBar();
}

// State class for FooterBar
class _FooterBar extends State<FooterBar> {
  var isDialOpen = ValueNotifier<bool>(false);

  var ver;

  @override
  void initState() {
    super.initState();
    appversionControl();
  }

  void appversionControl() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      setState(() {
        ver = version;
      });
    }).onError((error, stack) {
      Logging().LoggerPrint(error.toString());
    });
  }

  Future<void> _makePhoneCall() async {
    Uri toLaunch =
        Uri(scheme: 'https', host: 'developerbox.co.in', path: '/privacy-policy/');
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $toLaunch');
    }
  }

  // Main build method for UI
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: GestureDetector(
                    onTap: () {
                      _makePhoneCall();
                    },
                    child: const Text(
                      "Privacy Policy ",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  )),
              Text(" - V ${ver}"),
            ],
          ),
          helpDesk(isDialOpen)
        ]));
  }
}
