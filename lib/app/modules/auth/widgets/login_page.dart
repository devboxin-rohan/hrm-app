import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/service/attendance.dart';
import 'package:hrm_app/app/service/auth.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/CheckInternet.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/app/utils/help.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:hrm_app/app/utils/widgets/Footer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// MyLogin Widget (Stateful)
class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

// State class for MyLogin
class _MyLoginState extends State<MyLogin> {
  // State variables
  String email = "";
  String password = "";
  bool isLoading = false;
  bool _passwordVisible = false;
  bool ischecked = false;
  ScrollController _scrollController = ScrollController();

  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  var isDialOpen = ValueNotifier<bool>(false);

  var ver;

  @override
  void initState() {
    inputEmail.text = email;
    inputPassword.text = password;
    super.initState();
    appversionControl();
  }

  void appversionControl() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      setState(() {
        ver = version;
      });
    }).onError((error, stack) {
      Logging().LoggerPrint(error.toString());
    });
  }


  Future<void> _openBrowser() async {
    Uri toLaunch =
        Uri(scheme: 'https', host: 'developerbox.co.in', path: '/privacy-policy-1/');
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $toLaunch');
    }
  }

  

  // Main build method for UI
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      floatingActionButton: const FooterBar(),
      body: Stack(
        children: [
          Container(), // Background container

          // Title Container
          Container(
            margin: const EdgeInsets.only(left: 35, top: 30),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.black, fontSize: 33),
            ),
          ),

          // Main form layout
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        // Email Input Field
                        TextField(
                          controller: inputEmail,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: "Email",
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Password Input Field
                        TextField(
                          controller: inputPassword,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: ischecked,
                                onChanged: (checked) {
                                  setState(() {
                                    ischecked = checked!;
                                  });
                                }),
                                GestureDetector(onTap: (){
                                  _openBrowser();
                                },
                                child: Text("Accept terms and conditions",style: TextStyle(color: AppColors.blue,decoration: TextDecoration.underline)) ,
                                )
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Login Button
                        ElevatedButton(
                          onPressed: () async {

                            if(!ischecked){
                              AlertNotification.error("Accept terms and conditions",
                                  "Please click in checkbox to accept terms and condition ");
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            bool? isInternet = await CheckInternet();
                            if (isInternet) {
                              // bool? isServer = await CheckServer(context);
                              setState(() {
                                isLoading = false;
                              });

                              if (true) {
                                isLoading
                                    ? null
                                    : authController.login(
                                        inputEmail.text, inputPassword.text);
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              AlertNotification.error("Internet Issue",
                                  "Please check your internet connection");
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
