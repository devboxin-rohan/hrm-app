import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/auth/widgets/login_page.dart';
import 'package:hrm_app/app/theme/app_colors.dart';

// Main Welcome Page
class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({Key? key}) : super(key: key);

  @override
  _MyWelcomeState createState() => _MyWelcomeState();
}

class _MyWelcomeState extends State<MyWelcomePage> {
  // Variables to control the UI state
  double containerHeight = 400.0;
  String id1 = "";
  String id2 = "";
  bool loginDisplay = false;

  @override
  void initState() {
    super.initState();

    // Set container height after the initial frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        containerHeight = MediaQuery.of(context).size.height * 0.65;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background Color and Design
              _buildTopBackground(context),

              // Employee Image in the Center
              _buildCenterImage(context),

              // Logo at the Top
              _buildLogo(context),

              // Bottom Color Overlay
              _buildBottomOverlay(context),

              // Animated Container with Welcome Text or Login Screen
              _buildAnimatedContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  // Top background color with rounded corners
  Widget _buildTopBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
      ),
    );
  }

  // Center employee image
  Widget _buildCenterImage(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.18,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/employee.png"),
          ),
        ),
      ),
    );
  }

  // Logo at the top
  Widget _buildLogo(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.14,
      left: 0,
      right: 0,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/logo.png"),
          ),
        ),
      ),
    );
  }

  // Bottom overlay with solid color
  Widget _buildBottomOverlay(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.65,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .35,
        color: AppColors.primary,
      ),
    );
  }

  // Animated container with either welcome text or login screen
  Widget _buildAnimatedContainer(BuildContext context) {
    return AnimatedPositioned(
      duration: Durations.short2,
      top: containerHeight == 0
          ? MediaQuery.of(context).size.height * 0.65
          : containerHeight,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .65,
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: loginDisplay ? const MyLogin() : _buildWelcomeText(context),
      ),
    );
  }

  // Welcome text with a button to trigger the login screen
  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: const Text(
            "Welcome to Hrm Service! Streamline your workforce with our intuitive platform, managing your details efficiently.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              containerHeight = MediaQuery.of(context).size.height * 0.25;
              loginDisplay = true;
            });
          },
          child: const Text(
            "Get Started",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
