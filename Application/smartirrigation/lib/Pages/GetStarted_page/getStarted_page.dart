import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:smartirrigation/controller/save_controller.dart';
import 'package:smartirrigation/routes/routes.dart';

import '../../controller/id_controller.dart';

class getStarted extends StatelessWidget {
  final CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    SaveController.saveIsLoggedIn(false);
    // TODO: implement build
    return Scaffold(
      backgroundColor: colors.mainColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 58.w),
            child: Container(
              // decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 270.h),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          // decoration: BoxDecoration(
                          //   color: Colors.amber
                          // ),
                          height: 120.h,
                          child: Image.asset(
                            'lib/assets/photos/logo_app.png',
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          'HYDROS',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 28.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 80.h),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.grey),
                        elevation: MaterialStateProperty.all(5),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        )),
                      ),
                      onPressed: () => {
                        SaveController.readIsLoggedIn().then((isLoggedIn) {
                          print('Is logged in: $isLoggedIn');
                        }).catchError((error) {
                          print('Error: $error');
                        }),
                        counterController.reset(),
                        print("n = {$counterController.n.value}"),
                        Get.toNamed(routes.qr),
                      },
                      label: Text(
                        'Pair Device',
                        style: TextStyle(
                            color: colors.mainColor,
                            fontSize: 20.sp,
                            fontFamily: 'Inter'),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: colors.mainColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
