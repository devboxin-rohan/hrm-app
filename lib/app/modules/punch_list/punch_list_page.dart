import 'package:hrm_app/app/modules/home/widgets/PunchList.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PunchListScreen extends StatefulWidget {
  @override
  _PunchScreen createState() => _PunchScreen();
}

class _PunchScreen extends State<PunchListScreen> {
  var isDialOpen = ValueNotifier<bool>(false);
  var _deviceID;
  var dashboardDetails;
  var name;
  
  

  @override
  Widget build(BuildContext context) {
    // print(controller.dashboardData.value.name);

    return Scaffold(
        // floatingActionButton: helpDesk(isDialOpen),
        appBar: AppBar(),
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
              SizedBox(
                height: 20,
              ),
              PunchList(isLoadUnsync: false,),
              // Container(width: 200,height: 200,color: Colors.black,),
            ],
          )),
        ));
  } 
}





