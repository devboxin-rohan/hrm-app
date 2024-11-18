import 'package:flutter/material.dart';
import 'package:hrm_app/app/utils/CheckPermission.dart';
import 'package:get/get.dart';

class PunchBtn extends StatefulWidget {
  const PunchBtn({Key? key}) : super(key: key);

  @override
  _PunchBtn createState() => _PunchBtn();
}

class _PunchBtn extends State<PunchBtn> {




  @override
  Widget build(BuildContext context) {
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
        ],);
  }
}
