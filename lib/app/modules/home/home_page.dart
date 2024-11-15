import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/CheckPermission.dart';
import 'package:hrm_app/app/utils/PunchAsyncData.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/main.dart';
import 'widgets/clock_in_button.dart';
import 'widgets/timesheet_list_item.dart';
import 'widgets/header_section.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  int selectedIndex=0;

// class HomePage extends StatelessWidget {
  //  fetchDetails() async {
  //   AuthController controller = Get.find<AuthController>();
  //   var response= await controller.getUserData();
  //   // var response= await AuthController.getUserData();
  //   print(response!.empId);
  //   return response;
  // }

  handlePermissions() async {
    bool isPermission = await checkPermissions();
    bool isRequest =
        await requestPermissions(navigatorKey.currentState!.context);
    // print("------ requested permission ${isRequest}   ------- check permission ${isPermission}");
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final punchController = Get.find<PunchController>();
    // fetchDetails();
    handlePermissions();
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          HeaderSection(),
          SizedBox(
            height: 15,
          ),
          ClockInButton(onPressed: controller.clockIn),
          SizedBox(height: 10),
          _buildOverlayScreen(controller),
          Expanded(
              child: _buildTimeSheetList(
                  punchController)), // Updated to make it fill remaining space
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildOverlayScreen(HomeController controller) {
    return Container(
      width: double.maxFinite,
      // height: ,
      color: AppColors.secondary,
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 65,
                color: AppColors.white,
              )),
          Positioned(
              // top: 0,
              // bottom: 5,
              // left: 0,
              // right: 0,
              child: _buildWorkingHoursCard(controller)),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursCard(HomeController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(1),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        border: Border.all(
          color: AppColors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total working hours", style: AppColors.subheadingStyle),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today", style: AppColors.labelTextStyle),
                  Obx(() => Text(controller.todayHours.value,
                      style: AppColors.subheadingStyle)),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 1,
                    height: 65,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("This month duration",
                          style: AppColors.labelTextStyle),
                      Obx(() => Text(controller.monthHours.value,
                          style: AppColors.subheadingStyle)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSheetList(PunchController controller) {
    return Obx(() {
      return Container(
        color: AppColors.white, // Set background color to white
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Column(
          children: [
            // Add Sync Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  BackgroundWorkDispatcher.SubmitPunchData();
                },
                child: Text("Sync",
                    style: AppColors.buttonTextStyle
                        .copyWith(color: Colors.white)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.punchList.length,
                itemBuilder: (context, index) {
                  PunchModel entry = controller.punchList[index];
                  return TimesheetListItem(
                    date: entry.dateTime!,
                    duration: "00",
                    inOut: "00",
                    sync: entry.isSync!,
                    isLoading: entry.isLoading,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  
Widget _buildBottomNavigationBar() {
  return BottomNavigationBar(
    backgroundColor: AppColors.white,
    currentIndex: selectedIndex,
    onTap: (index) {
      setState(() {
        selectedIndex = index;
      });
      
      // Navigate based on index
      switch (index) {
        case 0:
          Get.toNamed("/home");
          break;
        case 1:
          removeToken(context);
          Get.toNamed("/auth");
          break;
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.access_time),
        label: "Clock",
        backgroundColor: Colors.white,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.logout),
        label: "Logout",
        backgroundColor: Colors.white,
      ),
    ],
  );
}
}
