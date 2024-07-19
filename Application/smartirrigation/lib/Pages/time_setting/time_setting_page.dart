import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:get/get.dart';
import 'package:smartirrigation/controller/firestore_controller.dart';
import 'package:smartirrigation/controller/time_setting_controller.dart';

import '../../models/time_model.dart';

class timeSetting extends StatelessWidget {
  final TimePickerController timeController = Get.put(TimePickerController());
  final ListWaktuController listController = Get.put(ListWaktuController());
  final FirestoreController firestoreController =
      Get.put(FirestoreController());

  @override
  Widget build(BuildContext context) {
    var clockSetting = ClockSetting(timeController: timeController);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.h),
        child: AppBar(
          elevation: 4.0.h,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          title: Text(""),
          backgroundColor: colors.mainColor,
        ),
      ),
      backgroundColor: Color.fromRGBO(235, 235, 235, 0.9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.event_note_outlined,
                    color: colors.mainColor,
                    size: 40.sp,
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Atur Waktu",
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 24.sp,
                          color: colors.greyColor),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.h),
              clockSetting,
              SizedBox(
                height: 18.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  listController.addTime(
                      timeController.hour.value,
                      timeController.minute.value,
                      timeController.timeFormat.value);

                  int selectedHour = timeController.hour.value;
                  int selectedMinute = timeController.minute.value;
                  String timeFormat = timeController.timeFormat.value;

                  if (timeFormat == 'PM' && selectedHour < 12) {
                    selectedHour += 12;
                  }

                  await firestoreController.addAlarmTimestamp(
                      selectedHour, selectedMinute);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(110.w, 40.h),
                  ),
                  elevation: MaterialStateProperty.all<double>(3.0.h),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (!states.contains(MaterialState.pressed)) {
                        return Colors.black;
                      }
                      return Colors.white;
                    },
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return colors.mainColor;
                      }
                      return Colors.white;
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.0.r),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                child: Text(
                  "Tambah",
                  style: TextStyle(
                    fontFamily: 'Hanuman',
                    fontSize: 18.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              Flexible(
                child: Obx(() => ListView.builder(
                    itemCount: listController.itemCount.value,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        if (listController.countdowns[index].inSeconds <= 0) {
                          return SizedBox.shrink();
                        } else {
                          return Container(
                            height: 110.h,
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 3.0.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 0.h, left: 20.w, right: 20.w),
                                title: GradientText(
                                  "${listController.listTimes.value[index].hour.toString().padLeft(2, '0')}:${listController.listTimes.value[index].minute.toString().padLeft(2, '0')} ${listController.listTimes.value[index].timeFormat}",
                                  style: TextStyle(
                                    fontFamily: 'Hanuman',
                                    fontSize: 55.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: [
                                    Color.fromRGBO(63, 148, 106, 1),
                                    Color.fromRGBO(153, 202, 155, 1),
                                  ],
                                ),
                                subtitle: Text(
                                  "${listController.getFormattedDifference(listController.countdowns[index])}",
                                  style: TextStyle(color: colors.greyColor),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    listController.removeTime(index);
                                    firestoreController
                                        .removeAlarmTimestamp(index);
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  splashColor: Colors.brown,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(202, 141, 84, 1),
                                    ),
                                    child: Icon(Icons.delete_outline_outlined,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockSetting extends StatelessWidget {
  const ClockSetting({
    super.key,
    required this.timeController,
  });
  final TimePickerController timeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color.fromRGBO(65, 151, 108, 1),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(
            () => NumberPicker(
              minValue: 0,
              maxValue: 12,
              value: timeController.hour.value,
              zeroPad: true,
              infiniteLoop: true,
              itemWidth: 80.w,
              itemHeight: 60.h,
              onChanged: (value) {
                timeController.hour.value = value;
              },
              textStyle: TextStyle(
                  color: Color.fromARGB(255, 172, 172, 172),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
              selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.white, width: 2.w),
                    bottom: BorderSide(color: Colors.white, width: 2.w)),
              ),
            ),
          ),
          Obx(
            () => NumberPicker(
              minValue: 0,
              maxValue: 59,
              value: timeController.minute.value,
              zeroPad: true,
              infiniteLoop: true,
              itemWidth: 80.w,
              itemHeight: 60.h,
              onChanged: (value) {
                timeController.minute.value = value;
              },
              textStyle: TextStyle(
                  color: Color.fromARGB(255, 172, 172, 172),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
              selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.white, width: 2.w),
                    bottom: BorderSide(color: Colors.white, width: 2.w)),
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  timeController.timeFormat.value = "AM";
                },
                child: Obx(
                  () => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: timeController.timeFormat.value == "AM"
                          ? Color.fromRGBO(202, 141, 84, 1)
                          : Color.fromRGBO(239, 204, 172, 1),
                      border: Border.all(
                        color: timeController.timeFormat.value == "AM"
                            ? Colors.grey
                            : Colors.grey.shade500,
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Text(
                      "AM",
                      style: TextStyle(
                        color: timeController.timeFormat.value == "AM"
                            ? Colors.white
                            : Colors.black26,
                        fontSize: 25.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                onTap: () {
                  timeController.timeFormat.value = "PM";
                },
                child: Obx(
                  () => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: timeController.timeFormat.value == "PM"
                          ? Color.fromRGBO(202, 141, 84, 1)
                          : Color.fromRGBO(239, 204, 172, 1),
                      border: Border.all(
                        color: timeController.timeFormat.value == "PM"
                            ? Colors.grey
                            : Colors.grey.shade500,
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Text(
                      "PM",
                      style: TextStyle(
                        color: timeController.timeFormat.value == "PM"
                            ? Colors.white
                            : Colors.black26,
                        fontSize: 25.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
