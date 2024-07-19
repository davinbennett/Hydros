import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:smartirrigation/controller/auditLog_controller.dart';
import 'package:smartirrigation/controller/firestore_controller.dart';
import 'package:smartirrigation/controller/history_controller.dart';
import 'package:intl/intl.dart';

import '../../controller/home_controller.dart';

class auditLog extends StatelessWidget {
  final datePicker datePickerController = Get.put(datePicker());
  final auditController listController = Get.put(auditController());
  final switchController = Get.put(SwitchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.h),
        child: AppBar(
          elevation: 4.0.h, // Set elevation for shadow
          shadowColor: Colors.black, // Set shadow color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          title: Text(""),
          backgroundColor: colors.mainColor,
        ),
      ),
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 40.h),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.manage_history_outlined,
                              size: 35.sp,
                              color: colors.mainColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 59.w, top: 7.h),
                              child: Text(
                                'Riwayat',
                                style: TextStyle(
                                    fontFamily: 'Hanuman',
                                    fontSize: 20.sp,
                                    color: colors.greyColor),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Penyiraman',
                                  style: TextStyle(
                                    color: colors.greyColor,
                                    fontFamily: 'Inter',
                                    fontSize: 13.sp,
                                  ),
                                ),
                                Obx(() => StreamBuilder<QuerySnapshot<Object?>>(
                                    stream: FirestoreController()
                                        .getDataSelectedDate(
                                            datePickerController.selectedDate.value),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(
                                            'Terjadi kesalahan: ${snapshot.error}');
                                      }

                                      int countValue = 0;
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        final docs = snapshot.data!.docs;
                                        if (docs.isNotEmpty) {
                                          final countOnData =
                                              docs.first['countOn'];
                                          countValue = countOnData;
                                        }
                                      }

                                      String countString =
                                          countValue.toString();
                                      if (snapshot.data == null ||
                                          !snapshot.hasData) countString = '0';

                                      return GradientText(
                                        '${countString}x',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.sp),
                                        colors: [
                                          Color.fromRGBO(63, 148, 106, 1),
                                          Color.fromRGBO(153, 202, 155, 1),
                                        ],
                                      );
                                    }))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 40.h,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(235, 235, 235, 0.9)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Obx(() => Text(
                                '${datePickerController.getNameDate()}, ${datePickerController.getDate.day} ${datePickerController.getNameMonth()} ${datePickerController.getDate.year}',
                                style: TextStyle(
                                    fontFamily: 'Hanuman',
                                    color: colors.greyColor),
                              )),
                        ),
                      ),
                      Flexible(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirestoreController().getPumpData(
                              datePickerController.selectedDate.value),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                  'Terjadi kesalahan: ${snapshot.error}');
                            }

                            final pumpDocuments = snapshot.data?.docs ?? [];

                            return ListView.builder(
                              itemCount: pumpDocuments.length,
                              itemBuilder: (context, index) {
                                final data = pumpDocuments[index].data();
                                String formattedTime = DateFormat('hh:mm a')
                                    .format(data['time'].toDate());
                                return Column(
                                  children: [
                                    ListTile(
                                        dense: true,
                                        leading: (data['status'])
                                            ? Icon(
                                                Icons.lightbulb_outline_rounded,
                                                color: colors.mainColor,
                                                size: 25.sp,
                                              )
                                            : Icon(
                                                Icons.power_settings_new,
                                                color: Color.fromRGBO(
                                                    202, 141, 84, 1),
                                                size: 25.sp,
                                              ),
                                        title: (data['status'])
                                            ? Text(
                                                'Pompa On',
                                                style: TextStyle(
                                                  fontFamily: 'Hanuman',
                                                  fontSize: 16.sp,
                                                  color: colors.greyColor,
                                                ),
                                              )
                                            : Text('Pompa Off',
                                                style: TextStyle(
                                                  fontFamily: 'Hanuman',
                                                  fontSize: 16.sp,
                                                  color: colors.greyColor,
                                                )),
                                        subtitle: Text(
                                          '${datePickerController.getNameDate()}, ${datePickerController.getDate.day} ${datePickerController.getNameMonth()} ${datePickerController.getDate.year}',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: colors.greyColor),
                                        ),
                                        trailing: (data['status'])
                                            ? Text(
                                                '${formattedTime}',
                                                style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontFamily: 'Inter',
                                                    color: colors.mainColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text('${formattedTime}',
                                                style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontFamily: 'Inter',
                                                    color: Color.fromRGBO(
                                                        202, 141, 84, 1),
                                                    fontWeight:
                                                        FontWeight.bold))),
                                    Divider()
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              left: 20.w,
              child: Container(
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: Colors.white,
                // ),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                    elevation: MaterialStateProperty.all<double>(3),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
