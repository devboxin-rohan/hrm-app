import 'package:flutter/material.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:hrm_app/main.dart';

AppBar CustomAppBar(){

  return AppBar(
          leadingWidth: double.infinity,
          toolbarHeight: 70, // Set this height
          leading: Container(
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  margin:EdgeInsets.only(left: 20),
                  width: 180,
                  decoration:const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/devlogo.png'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                           removeToken(navigatorKey.currentState!.context);
                           AlertNotification.error( "Successfully logout" , "");
                           },
                          icon: Icon(
                            Icons.logout_sharp,
                            color: Colors.white,
                            size: 30,
                          )),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
}