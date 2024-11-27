import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/home/widgets/PunchBtn.dart';
import 'package:hrm_app/app/modules/home/widgets/PunchList.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/widgets/AppBar.dart';
import 'package:hrm_app/app/utils/widgets/BottomNavigationBar.dart';
import 'package:hrm_app/main.dart';
import 'package:get/get.dart';

class LeavePage extends StatefulWidget {
  @override
  _leavePage createState() => _leavePage();
}

class _leavePage extends State<LeavePage> {
  @override
  Widget build(BuildContext context) {
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
                ),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const SizedBox(height: 20,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween
                      ,children: [
                     const Text("Leave",style:AppColors.subheadingStyle),
                      ElevatedButton(onPressed:(){Get.toNamed("/leave-form");}, child:const Text("Add Leave"))
                     ],)
                    ]))));
  }
}
