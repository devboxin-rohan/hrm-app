import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/utils/CheckPermission.dart';
import 'package:get/get.dart';
import 'package:hrm_app/main.dart';

class PunchBtn extends StatefulWidget {
  const PunchBtn({Key? key}) : super(key: key);

  @override
  _PunchBtn createState() => _PunchBtn();
}

class _PunchBtn extends State<PunchBtn> {
   
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _handlePermissions();

    HomeController controller = Get.find<HomeController>();
    controller.fetchuserSettings();
    // if(controller.isFaceAuthenticationAllowed.value){
    //  controller.fetchDetails();
    // }
  }


  Future<void> _handlePermissions() async {
    await checkPermissions();
    await requestPermissions(navigatorKey.currentState!.context);
  }


  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    
    return Obx((){
      if(controller.isFaceAuthenticationAllowed.value && !controller.isFaceExist.value && controller.isManualAllowed.value)
      {return  ElevatedButton(
          style:  ButtonStyle(
            maximumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*1, 45)),
            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*1, 45)),
          ),
          onPressed: (){Get.toNamed("punch",arguments:{"isRegister":true});},
          child: const Text(
            "Register Face",
            style: TextStyle(color: Colors.white),
          ),
        );
        }
      else{
      return Row(children: [
         ElevatedButton(
          style:  ButtonStyle(
            maximumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*.43, 45)),
            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*.43, 45)),
          ),
          onPressed: (){Get.toNamed("punch",arguments:{"isPunchin":true});},
          child: const Text(
            "Punch In",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 10,),
        ElevatedButton(
          style:  ButtonStyle(
            maximumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*.43, 45)),
            minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*.43, 45)),
          ),
          onPressed: (){Get.toNamed("punch",arguments:{"isPunchin":false});},
          child: const Text(
            "Punch Out",
            style: TextStyle(color: Colors.white),
          ),
        )
        ],);}
    }); 
  }
}
