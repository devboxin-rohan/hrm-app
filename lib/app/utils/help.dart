import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

helpDesk(isDialOpen) {
  String version = "";
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future versionGet() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  return SpeedDial(
    // animatedIcon: AnimatedIcons.menu_close,
    // animatedIconTheme: IconThemeData(size: 22.0),
    // / This is ignored if animatedIcon is non null
    // child: Text("open"),
    // activeChild: Text("close"),
    icon: Icons.help,
    activeIcon: Icons.close,
    spacing: 3,
    openCloseDial: isDialOpen,
    childPadding: const EdgeInsets.all(5),
    spaceBetweenChildren: 4,
    

    /// Transition Builder between label and activeLabel, defaults to FadeTransition.
    // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
    /// The below button size defaults to 56 itself, its the SpeedDial childrens size

    // overlayColor: Colors.black,
    // foregroundColor: Colors.black,
    // backgroundColor: Colors.white,
    // activeForegroundColor: Colors.red,
    // activeBackgroundColor: Colors.blue,
    elevation: 8.0,
    animationCurve: Curves.elasticInOut,
    isOpenOnStart: false,

    // shape: customDialRoot
    //     ? const RoundedRectangleBorder()
    //     : const StadiumBorder(),
    // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    children: [
      SpeedDialChild(
        child: const Icon(Icons.support_agent),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: 'Customer Service',
        onTap: () => {_makePhoneCall('9111333243')},
      ),
      SpeedDialChild(
        child: const Icon(Icons.report),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        label: 'Share your issue',
        onTap: () => {Logging().exportFile()},
      ),
    ],
  );
}
