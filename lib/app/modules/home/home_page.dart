import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/modules/home/widgets/AppUpdateDialog.dart';
import 'package:hrm_app/app/modules/home/widgets/PunchBtn.dart';
import 'package:hrm_app/app/modules/home/widgets/PunchList.dart';
import 'package:hrm_app/app/service/attendance.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/DeviceId.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/app/utils/help.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/widgets/AppBar.dart';
import 'package:hrm_app/app/utils/widgets/BottomNavigationBar.dart';
import 'package:hrm_app/app/utils/widgets/Footer.dart';
import 'package:hrm_app/main.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with RouteAware {
  var isDialOpen = ValueNotifier<bool>(false);
  var _deviceID;
  var dashboardDetails;
  var name;
  var ver;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeDashboard();
  }

  void initializeDashboard() async {
    checkTimeAndTriggerFunction(context);
    Timer.periodic(Duration(minutes: 5),
        (Timer t) => checkTimeAndTriggerFunction(context));

    var data = await SharedData().getDashboardDetail();
    String deviceCode = await setDeviceId(context, data["user_id"]);
    SharedData().setDeviceId(deviceCode);
    setState(() {
      dashboardDetails = data;
      _deviceID = deviceCode;
      name = data["emp_name"];
    });

    appversionControl();
    print(dashboardDetails.toString() + "_-----" + _deviceID.toString());
  }

  void appversionControl() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      setState(() {
        ver = version;
      });
      Logging().LoggerPrint("---------------- ${version} --------------------");
      AttendanceService().getAttandanceDetail().then((value) async {
        if (value.data != null &&
            value.data["app_version"] != null &&
            value.data["app_version"]["version"] != version) {
          showUpdateDialog(value.data);
        }
      });
    }).onError((error, stack) {
      Logging().LoggerPrint(error.toString());
    });
  }

  void showUpdateDialog(dynamic decodedData) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: UpdateAlertDailog(
              appVersion: decodedData["app_version"]["version"],
              latestVersion: decodedData["app_version"]["version"],
              link: decodedData["app_version"]["app_link"],
              forceUpdate: decodedData["app_version"]["force_update"],
            ),
          );
        });
  }

  Future<void> _refreshData() async {
    print("Refresh triggered");
    setState(() {
      isLoading = true;
    });

    initializeDashboard(); // Simulate API call

    setState(() {
      isLoading = false;
    });

    // Optionally reload dashboard details or other state here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FooterBar(),
        backgroundColor: AppColors.primary,
        appBar: CustomAppBar(),
        body: RefreshIndicator(
          onRefresh: _refreshData, // Refresh function
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(), // Ensures the list scrolls even if the content is less
            child: Container(
              height: MediaQuery.of(navigatorKey.currentState!.context).size.height *1,
              width: MediaQuery.of(navigatorKey.currentState!.context).size.width *1,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  WelcomeBoard(),
                  SizedBox(height: 20),
                  PunchList(
                    isLoadUnsync: true,
                  ),
                  SizedBox(height: 20),
                  PunchBtn(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ));
  }

  //Welcome board for logged in user
  WelcomeBoard() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: double.maxFinite,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              offset: Offset(0, 25),
              blurRadius: 5,
              spreadRadius: -15)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: AppColors.subheadingStyle,
                    ),
                    Text(
                      dashboardDetails?["emp_name"]?.toString() ?? '',
                      style: AppColors.labelTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Device id :- $_deviceID",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Container(
            width: 110,
            height: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/user.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
