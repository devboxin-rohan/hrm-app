// modules/home/widgets/clock_in_button.dart
import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:hrm_app/app/utils/logging.dart';
// class ClockInButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const ClockInButton({required this.onPressed});

class ClockInButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ClockInButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _ClockInButton createState() => _ClockInButton();
}

class _ClockInButton extends State<ClockInButton> {


  @override
  void initState() {
    super.initState();
    HomeController controller= Get.find<HomeController>();
    controller.fetchDetails();
  }

  

  @override
  Widget build(BuildContext context) {
    HomeController controller= Get.find<HomeController>();

    print(controller.isFaceExist.value);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        ),
        child:Obx(() =>  Center(
          child: controller.isLoading.value
              ? CircularProgressIndicator(color: AppColors.white,)
              : controller.isFaceExist.value
                  ? Text("Clock In", style: AppColors.buttonTextStyle)
                  : Text("Register", style: AppColors.buttonTextStyle),
        )),
      ),
    );
  }
}
