// modules/clock_screen/widgets/header_section.dart
import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:hrm_app/main.dart';

class HeaderSection extends StatefulWidget {
  @override
  _headerSection createState() => _headerSection();
}

class _headerSection extends State<HeaderSection> {
// class HeaderSection extends StatelessWidget {

  String name = "Sam";

  extractUserData() async {
    AuthController controller = Get.find<AuthController>();
    var response = await controller.getUserData();
    setState(() {
      name =response!.name;
    });
    return response!.name;
  }

  @override
  Widget build(BuildContext context) {
   extractUserData();
    
    return
      Padding(
        padding: const EdgeInsets.only(top:30,left:24,right:24),
    child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/image/devlogo.png",width: MediaQuery.of(context).size.width*.5,),
            SizedBox(height: 10,),
             SizedBox(width: MediaQuery.of(navigatorKey.currentState!.context).size.width*.5,
           child:Text("Good morning, ${name}", style: AppColors.labelTextStyle,overflow: TextOverflow.ellipsis,),),
           Text("Let's get to work!", style: AppColors.subheadingStyle),
          ],
        ),
        // Image.asset(
        //   'assets/image/clock-bg.png',
        //   width: 50,
        // ),
        // SizedBox(height: 20,)
      ],
    ),
    );
  }
}
