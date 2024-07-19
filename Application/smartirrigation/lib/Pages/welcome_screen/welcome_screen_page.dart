import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartirrigation/controller/firestore_controller.dart';
import 'package:smartirrigation/navbar/bot_navbar_page.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/splash_view.dart';

import '../GetStarted_page/getStarted_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splash_view/splash_view.dart';

import '../GetStarted_page/getStarted_page.dart';
import '../../controller/save_controller.dart';

class welcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: SaveController.readIsLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Color.fromRGBO(195, 195, 195, 1),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final isLoggedIn = snapshot.data ?? false;
          return SplashView(
            logo: Image.asset('lib/assets/photos/logo_app.png'),
            done: Done(
              isLoggedIn ? botNavbar() : getStarted(),
              animationDuration: Duration(seconds: 0),
            ),
            backgroundColor: Color.fromRGBO(62, 148, 106, 1),
            showStatusBar: true,
            loadingIndicator: const CircularProgressIndicator(
              color: Color.fromRGBO(195, 195, 195, 1),
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'HYDROS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
