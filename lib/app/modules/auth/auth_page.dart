// login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/constants.dart';
import 'auth_controller.dart'; // Ensure this path is correct
// import 'style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final AuthController authController = Get.put(AuthController());
  bool isKeyboardVisible = false;
  bool isPasswordVisible = false; // Add this variable to control password visibility

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Check if the keyboard is visible
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      isKeyboardVisible = keyboardHeight > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeOut,
              // Adjust padding based on keyboard visibility
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  _buildLogo(),
                  const SizedBox(height: 20),

                  if (!isKeyboardVisible) _buildDescriptionText(),
                  const SizedBox(height: 20),

                  // Only show when keyboard is hidden
                  // if (!isKeyboardVisible) _buildTermsAndConditionsLink(),

                  const SizedBox(height: 20),
                  // Obx(() => authController.isLoading.value
                  //     ? const Center(child: CircularProgressIndicator())
                  //     : _
                  _buildLoginForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      // padding: const EdgeInsets.symmetric(vertical: , horizontal: 15),
      child: Image.asset(
        'assets/image/devlogo.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDescriptionText() {
    return const Text(
      Constants.appWelcomeParagraph,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, color: AppColors.black),
    );
  }

  Widget _buildTermsAndConditionsLink() {
    return GestureDetector(
      onTap: () {
        // Handle terms and conditions tap
      },
      child: Text(
        'Term & condition',
        style:
            AppColors.linkTextStyle.copyWith(fontSize: 14, color: Colors.blue),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Login',
              style: AppColors.headerTextStyle
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildTextField('Email', false, authController.username),
          const SizedBox(height: 20),
          _buildTextField('Password', true, authController.password),
          const SizedBox(height: 10),
          _buildForgotPasswordLink(),
          const SizedBox(height: 10),
          _buildRememberMeAndLoginButton(),
          const SizedBox(height: 20),
          _buildRegisterLink(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword, RxString controllerValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppColors.labelTextStyle.copyWith(fontSize: 16)),
        SizedBox(height: 5),
        TextField(
          obscureText: isPassword && !isPasswordVisible, // Toggle based on isPasswordVisible
          onChanged: (value) => controllerValue.value = value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            // Add suffix icon for password visibility toggle
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // Handle forgot password tap
        },
        child: Text(
          'Forget Password?',
          style: AppColors.linkTextStyle
              .copyWith(fontSize: 14, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildRememberMeAndLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(() => Checkbox(
                  value: authController.rememberMe.value,
                  onChanged: (bool? value) {
                    authController.rememberMe.value = value ?? false;
                  },
                )),
            Text('Remember',
                style: AppColors.labelTextStyle.copyWith(fontSize: 14)),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            // authController
            //     .login(); // Calls the login function from AuthController
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Obx(() => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: authController.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    : Text('Login',
                        style: AppColors.buttonTextStyle
                            .copyWith(color: Colors.white)),
              )),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Send request to create account - ',
          style: AppColors.labelTextStyle.copyWith(fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            // Handle register link tap
          },
          child: Text(
            'Register?',
            style: AppColors.linkTextStyle
                .copyWith(fontSize: 14, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
