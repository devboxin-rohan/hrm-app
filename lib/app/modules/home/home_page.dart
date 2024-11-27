import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/home/widgets/PunchBtn.dart';
import 'package:hrm_app/app/modules/home/widgets/PunchList.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/app/utils/widgets/AppBar.dart';
import 'package:hrm_app/app/utils/widgets/BottomNavigationBar.dart';
import 'package:hrm_app/main.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>  with RouteAware{
  
  @override
  initState(){
    super.initState();
    checkTimeAndTriggerFunction(navigatorKey.currentState!.context);
    Timer.periodic(Duration(minutes: 15), (Timer t){checkTimeAndTriggerFunction(navigatorKey.currentState!.context);});
  }

  @override
  Widget build(BuildContext context) {
    // print(controller.dashboardData.value.name);
    
    return Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(),
        // floatingActionButton: helpDesk(isDialOpen),
        appBar: CustomAppBar(),
        // drawer: Drawer(),
        backgroundColor: AppColors.primary,
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: const BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              WelcomeBoard(),
              SizedBox(
                height: 20,
              ),
              PunchList(isLoadUnsync: true,),
              PunchBtn(),
              // Container(width: 200,height: 200,color: Colors.black,),
            ],
          )),
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
                width: MediaQuery.of(navigatorKey.currentState!.context)
                        .size
                        .width *
                    0.4,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                       style: AppColors.headerTextStyle,
                    ),
                    Text(
                      'Team',
                      style: AppColors.labelTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              // Text(
              //   "Hello Team",
              //   style: TextStyle(fontSize: 12),
              // ),
            ],
          ),
          Container(
            width: 110,
            height: 120, // Reduced height to fit within the container
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



  