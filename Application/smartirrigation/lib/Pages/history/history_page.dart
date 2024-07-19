import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:smartirrigation/controller/history_controller.dart';
import 'package:smartirrigation/controller/home_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartirrigation/routes/routes.dart';

import '../../controller/firestore_controller.dart';

class history extends StatelessWidget {
  final SwitchController switchController = Get.put(SwitchController());
  final datePicker datePickercontroller = Get.put(datePicker());

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: colors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Container(
                  // height: 280.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    color: Colors.white,
                    // border: Border.all(),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: Offset(1.5, 4.0)),
                    ],
                  ),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //decoration: BoxDecoration(color: Colors.amber),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 15.w, right: 15.w, top: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.manage_history_outlined,
                                size: 40.sp,
                                color: colors.mainColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 70.w, top: 5.h),
                                child: Text(
                                  'Riwayat',
                                  style: TextStyle(
                                      fontFamily: 'Hanuman',
                                      fontSize: 24.sp,
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
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Obx(() => StreamBuilder<
                                          QuerySnapshot<Object?>>(
                                      stream: FirestoreController()
                                          .getDataSelectedDate(
                                              datePickercontroller
                                                  .selectedDate.value),
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
                                            !snapshot.hasData)
                                          countString = '0';

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
                      ),
                      //Spacer(),

                      // date & grafik
                      Expanded(
                        child: Container(
                          //decoration: BoxDecoration(color: Colors.amber),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    //decoration: BoxDecoration(color: Colors.blue),
                                    child: Obx(() => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 50.h,
                                              child: GradientText(
                                                '${datePickercontroller.getDate.day}',
                                                style: TextStyle(
                                                    fontFamily: 'Hanuman',
                                                    fontSize: 52.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                colors: [
                                                  Color.fromRGBO(
                                                      63, 148, 106, 1),
                                                  Color.fromRGBO(
                                                      153, 202, 155, 1),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 0.h),
                                              child: Text(
                                                '${datePickercontroller.getNameDate()}',
                                                style: TextStyle(
                                                    fontFamily: 'Hanuman',
                                                    color: colors.greyColor,
                                                    fontSize: 16.sp),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.w, right: 10.w),
                                    child: Container(
                                        width: double.infinity,
                                        //decoration: BoxDecoration(color: Colors.amber),
                                        height: double.infinity,
                                        child: Obx(
                                          () => StreamBuilder<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>(
                                            key: UniqueKey(),
                                            stream: FirestoreController()
                                                .getPumpData(
                                                    datePickercontroller
                                                        .selectedDate.value),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              }

                                              if (snapshot.data == null ||
                                                  snapshot.data!.docs.isEmpty) {
                                                print(
                                                    "Snapshot data is null or empty");
                                                return BarChart(
                                                  BarChartData(
                                                    barTouchData: barTouchData,
                                                    titlesData: titlesData,
                                                    borderData: borderData,
                                                    barGroups:
                                                        generateBarGroupsIsEmpty(), // Menggunakan generateBarGroupsIsEmpty karena snapshot.data null atau kosong
                                                    gridData: const FlGridData(
                                                        show: false),
                                                    alignment: BarChartAlignment
                                                        .spaceBetween,
                                                    maxY: 10.2.h,
                                                    minY: 0.h,
                                                  ),
                                                );
                                              } else {
                                                print(
                                                    "Snapshot data is not null and contains documents");
                                                final pumpDocuments =
                                                    snapshot.data!.docs;
                                                return BarChart(
                                                  BarChartData(
                                                    barTouchData: barTouchData,
                                                    titlesData: titlesData,
                                                    borderData: borderData,
                                                    barGroups:
                                                        generateBarGroups(
                                                            pumpDocuments),
                                                    gridData: const FlGridData(
                                                        show: false),
                                                    alignment: BarChartAlignment
                                                        .spaceBetween,
                                                    maxY: 10.2.h,
                                                    minY: 0.h,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        )),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      //decoration: BoxDecoration(color: Colors.pinkAccent.shade100),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            child: SizedBox(
                                              height: 10.h,
                                              child: Text(
                                                'Lihat Detail',
                                                style: TextStyle(
                                                    fontFamily: 'Hanuman',
                                                    fontSize: 11.sp,
                                                    color: colors.greyColor,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            child: TextButton(
                                                onPressed: () => Get.toNamed(
                                                    routes.audit_log),
                                                child: Text(
                                                  'Riwayat',
                                                  style: TextStyle(
                                                      fontFamily: 'Hanuman',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colors.mainColor,
                                                      fontSize: 40.sp),
                                                )),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Spacer()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              // suhu
              Flexible(
                flex: 2,
                child: SizedBox(
                  child: Container(
                    height: 150.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                      color: Colors.white,
                      // border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: Offset(1.5, 4.0)),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // suhu udara
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Image.asset(
                                  'lib/assets/photos/logo_temperatur.png',
                                  width: 60.w,
                                  height: 66.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                'Suhu Udara',
                                style: TextStyle(
                                  color: colors.greyColor,
                                  fontFamily: 'Hanuman',
                                  fontSize: 18.sp,
                                ),
                              )
                            ],
                          ),
                          Obx(() => StreamBuilder<QuerySnapshot<Object?>>(
                              stream: FirestoreController().getDataSelectedDate(
                                  datePickercontroller.selectedDate.value),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                      'Terjadi kesalahan: ${snapshot.error}');
                                }

                                List<double> temperatures = [];

                                if (snapshot.data != null) {
                                  for (final doc in snapshot.data!.docs) {
                                    var data =
                                        doc.data() as Map<String, dynamic>;

                                    try {
                                      var temperatureArray =
                                          data['Temperature'];

                                      if (temperatureArray.isNotEmpty) {
                                        for (var temperature
                                            in temperatureArray) {
                                          if (temperature is num) {
                                            temperatures
                                                .add(temperature.toDouble());
                                          }
                                        }
                                      }
                                    } catch (e) {}
                                  }
                                }

                                temperatures.sort();

                                double minTemperature = temperatures.isNotEmpty
                                    ? temperatures.first
                                    : 0;
                                double maxTemperature = temperatures.isNotEmpty
                                    ? temperatures.last
                                    : 0;

                                return (temperatures.length > 1)
                                    ? GradientText(
                                        '${minTemperature.toStringAsFixed(0)}-${maxTemperature.toStringAsFixed(0)}°C',
                                        style: TextStyle(
                                          fontSize: 65.sp,
                                          fontFamily: 'Hanuman',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        colors: [
                                          Color.fromRGBO(63, 148, 106, 1),
                                          Color.fromRGBO(153, 202, 155, 1),
                                        ],
                                      )
                                    : GradientText(
                                        '${maxTemperature.toStringAsFixed(0)}°C',
                                        style: TextStyle(
                                          fontSize: 80.sp,
                                          fontFamily: 'Hanuman',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        colors: [
                                          Color.fromRGBO(63, 148, 106, 1),
                                          Color.fromRGBO(153, 202, 155, 1),
                                        ],
                                      );
                              })),
                        ],
                      ),
                    ),
                  ),
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              // lembab udara & tanah
              Flexible(
                flex: 2,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 180.h,
                        width: 164.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                          color: Colors.white,
                          // border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: Offset(1.5, 4.0)),
                          ],
                        ),
                        child: Obx(() => StreamBuilder<QuerySnapshot<Object?>>(
                            stream: FirestoreController().getDataSelectedDate(
                                datePickercontroller.selectedDate.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'Terjadi kesalahan: ${snapshot.error}');
                              }

                              double calculateAverage(
                                  List<dynamic> humidityArray) {
                                if (humidityArray.isEmpty) {
                                  return 0.0;
                                }

                                double sum = 0;
                                for (var humidity in humidityArray) {
                                  if (humidity is num) {
                                    sum += humidity.toDouble();
                                  }
                                }

                                return sum / humidityArray.length;
                              }

                              double totalHumidity = 0.0;
                              int documentCount = 0;

                              if (snapshot.data != null) {
                                for (final doc in snapshot.data!.docs) {
                                  var data = doc.data() as Map<String, dynamic>;

                                  try {
                                    var humidityArray =
                                        data['Humidity'] as List;

                                    if (humidityArray.isNotEmpty) {
                                      totalHumidity +=
                                          calculateAverage(humidityArray);
                                      documentCount++;
                                    }
                                  } catch (e) {}
                                }
                              }

                              double averageHumidity = documentCount > 0
                                  ? totalHumidity / documentCount
                                  : 0.0;

                              String humidityStatus = '';
                              if (averageHumidity == 0.0)
                                humidityStatus = 'N/A';
                              else if (averageHumidity < 45 &&
                                  averageHumidity > 0) {
                                humidityStatus = 'Status: Kering';
                              } else if (averageHumidity >= 45 &&
                                  averageHumidity <= 65) {
                                humidityStatus = 'Status: Ideal';
                              } else {
                                humidityStatus = 'Status: Lembab';
                              }

                              return Column(
                                // Kelembaban Udara
                                children: <Widget>[
                                  Container(
                                    // decoration: BoxDecoration(color: Colors.amber),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15.w, top: 10.h),
                                          child: Icon(
                                            Icons.air,
                                            size: 35.sp,
                                            color: colors.mainColor,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.h, right: 15.w),
                                          child: Text(
                                            '$humidityStatus',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 13.8.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                      //decoration: BoxDecoration(color: Colors.amber),
                                      child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10.h,
                                                left: 15.w,
                                                right: 10.w),
                                            child: Text(
                                              'Avg.',
                                              style: TextStyle(
                                                  color: colors.greyColor,
                                                  fontFamily: 'Hanuman',
                                                  fontSize: 18.sp),
                                            ),
                                          ),
                                          GradientText(
                                            '${averageHumidity.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 52.sp,
                                              fontFamily: 'Hanuman',
                                              fontWeight: FontWeight.w600,
                                            ),
                                            colors: [
                                              Color.fromRGBO(63, 148, 106, 1),
                                              Color.fromRGBO(153, 202, 155, 1),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                                  Spacer(),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.w, bottom: 10.h),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Kelembaban Udara',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 12.sp,
                                            ),
                                          )),
                                    ),
                                    //decoration: BoxDecoration(color: Colors.amber),
                                  ),
                                ],
                              );
                            })),
                      ),
                      Container(
                        height: 180.h,
                        width: 164.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                          color: Colors.white,
                          // border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: Offset(1.5, 4.0)),
                          ],
                        ),
                        child: Obx(() => StreamBuilder<QuerySnapshot<Object?>>(
                            stream: FirestoreController().getDataSelectedDate(
                                datePickercontroller.selectedDate.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'Terjadi kesalahan: ${snapshot.error}');
                              }

                              double calculateAverage(List<dynamic> soilArray) {
                                if (soilArray.isEmpty) {
                                  return 0.0;
                                }

                                double sum = 0;
                                for (var soil in soilArray) {
                                  if (soil is num) {
                                    sum += soil.toDouble();
                                  }
                                }

                                return sum / soilArray.length;
                              }

                              double totalSoil = 0.0;
                              int documentCount = 0;

                              if (snapshot.data != null) {
                                for (final doc in snapshot.data!.docs) {
                                  // Ambil data dari dokumen
                                  var data = doc.data() as Map<String, dynamic>;

                                  // Coba akses array 'Humidity'
                                  try {
                                    var soilArray = data['Soil'] as List;

                                    if (soilArray.isNotEmpty) {
                                      totalSoil += calculateAverage(soilArray);
                                      documentCount++;
                                    }
                                  } catch (e) {}
                                }
                              }

                              double averageSoil = documentCount > 0
                                  ? totalSoil / documentCount
                                  : 0.0;

                              String soilStatus = '';
                              if (averageSoil == 0.0)
                                soilStatus = 'N/A';
                              else if (averageSoil < 45 && averageSoil > 0) {
                                soilStatus = 'Status: Kering';
                              } else if (averageSoil >= 45 &&
                                  averageSoil <= 65) {
                                soilStatus = 'Status: Ideal';
                              } else {
                                soilStatus = 'Status: Lembab';
                              }

                              return Column(
                                // Kelembaban Tanah
                                children: <Widget>[
                                  Container(
                                    // decoration: BoxDecoration(color: Colors.amber),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15.w, top: 10.h),
                                          child: Icon(
                                            Icons.grass_outlined,
                                            size: 35.sp,
                                            color: colors.mainColor,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.h, right: 15.w),
                                          child: Text(
                                            '$soilStatus',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 13.8.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                      //decoration: BoxDecoration(color: Colors.amber),
                                      child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10.h,
                                                left: 15.w,
                                                right: 10.w),
                                            child: Text(
                                              'Avg.',
                                              style: TextStyle(
                                                  color: colors.greyColor,
                                                  fontFamily: 'Hanuman',
                                                  fontSize: 18.sp),
                                            ),
                                          ),
                                          GradientText(
                                            '${averageSoil.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 52.sp,
                                              fontFamily: 'Hanuman',
                                              fontWeight: FontWeight.w600,
                                            ),
                                            colors: [
                                              Color.fromRGBO(63, 148, 106, 1),
                                              Color.fromRGBO(153, 202, 155, 1),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                                  Spacer(),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.w, bottom: 10.h),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Kelembaban Tanah',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 12.sp,
                                            ),
                                          )),
                                    ),
                                    //decoration: BoxDecoration(color: Colors.amber),
                                  ),
                                ],
                              );
                            })),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(colors.mainColor),
                    shadowColor: MaterialStateProperty.all(Colors.grey),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    )),
                  ),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePickerDialog(
                      context: context,
                      contentPadding: EdgeInsets.all(16),
                      padding: EdgeInsets.all(36),
                      initialDate: DateTime.now(),
                      minDate: DateTime(2020),
                      maxDate: DateTime.now().add(Duration(days: 365)),
                      // currentDate: DateTime.now(),
                      selectedDate: datePickercontroller.getDate,
                      currentDateDecoration: const BoxDecoration(),
                      currentDateTextStyle: const TextStyle(),
                      daysOfTheWeekTextStyle: const TextStyle(),
                      disabledCellsDecoration: const BoxDecoration(),
                      disabledCellsTextStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                      enabledCellsDecoration: const BoxDecoration(
                          //color: Colors.amber
                          ),
                      enabledCellsTextStyle: const TextStyle(),
                      initialPickerType: PickerType.days,
                      selectedCellDecoration: BoxDecoration(
                        color: colors.mainColor,
                        shape: BoxShape.circle,
                      ),
                      selectedCellTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      leadingDateTextStyle: const TextStyle(),
                      slidersColor: colors.mainColor,
                      highlightColor: Colors.redAccent,
                      slidersSize: 20,
                      splashColor: Colors.lightBlueAccent,
                      splashRadius: 40,
                      centerLeadingDate: true,
                    );
                    if (pickedDate != null) {
                      datePickercontroller.setDate(pickedDate);
                      print(pickedDate);
                    }
                  },
                  label: Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Inter'),
                  ),
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                ),
              ),
              //Spacer(),
              //
            ],
          ),
        ),
      ),
    );
  }
}

BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.only(top: 4, left: 11),
        tooltipMargin: 2,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round() == 8 ? 'ON' : '',
            TextStyle(
              color: colors.mainColor, // Change color here
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              fontSize: 14.sp,
            ),
          );
        },
      ),
    );

Widget getTitles(double value, TitleMeta meta) {
  final style = TextStyle(
    color: colors.greyColor, // Change color here
    fontWeight: FontWeight.bold,
    fontSize: 11,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = '00:00';
      break;
    case 1:
      text = '04:00';
      break;
    case 2:
      text = '08:00';
      break;
    case 3:
      text = '12:00';
      break;
    case 4:
      text = '16:00';
      break;
    case 5:
      text = '20:00';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: style),
  );
}

FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40.h,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData {
  return FlBorderData(
      show: true,
      border: Border(
          bottom: BorderSide(
              color: Color.fromARGB(255, 102, 102, 102), width: 1.8)));
}

LinearGradient get _greenBarsGradient => LinearGradient(
      colors: [
        Color.fromRGBO(63, 148, 106, 1),
        Color.fromRGBO(153, 202, 155, 1), // Change color here
      ],
      end: Alignment.bottomCenter,
      begin: Alignment.topCenter,
    );

LinearGradient get _greyBarsGradient => LinearGradient(
      colors: [
        Colors.grey.shade400,
        Colors.grey.shade200,
      ],
      end: Alignment.bottomCenter,
      begin: Alignment.topCenter,
    );

List<BarChartGroupData> generateBarGroups(
  List<DocumentSnapshot> pumpDocuments,
) {
  double var1 = 4.5;
  double var2 = 4.5;
  double var3 = 4.5;
  double var4 = 4.5;
  double var5 = 4.5;
  double var6 = 4.5;

  for (DocumentSnapshot document in pumpDocuments) {
    Timestamp time = document['time'] as Timestamp;
    bool status = document['status'] as bool;

    DateTime dateTime = time.toDate();

    if (dateTime.hour >= 0 && dateTime.hour < 4) {
      if (status) {
        var1 = 8;
      }
    } else if (dateTime.hour >= 4 && dateTime.hour < 8) {
      if (status) {
        var2 = 8;
      }
    } else if (dateTime.hour >= 8 && dateTime.hour < 12) {
      if (status) {
        var3 = 8;
      }
    } else if (dateTime.hour >= 12 && dateTime.hour < 16) {
      if (status) {
        var4 = 8;
      }
    } else if (dateTime.hour >= 16 && dateTime.hour < 20) {
      if (status) {
        var5 = 8;
      }
    } else {
      if (status) {
        var6 = 8;
      }
    }
  }

  return List.generate(6, (index) {
    double toYValue = 4.5;

    switch (index) {
      case 0:
        toYValue = var1;
        break;
      case 1:
        toYValue = var2;
        break;
      case 2:
        toYValue = var3;
        break;
      case 3:
        toYValue = var4;
        break;
      case 4:
        toYValue = var5;
        break;
      case 5:
        toYValue = var6;
        break;
    }

    LinearGradient gradient =
        toYValue == 8 ? _greenBarsGradient : _greyBarsGradient;

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          fromY: 0.5,
          toY: toYValue,
          gradient: gradient,
          width: 26,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            topLeft: Radius.circular(6),
          ),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  });
}

List<BarChartGroupData> generateBarGroupsIsEmpty() {
  return List.generate(6, (index) {
    double toYValue = 4.5; // Set toY to 4.5 for all bars
    LinearGradient gradient = _greyBarsGradient; // Use default gradient
    switch (index) {
      case 0:
        toYValue = 4.5;
        break;
      case 1:
        toYValue = 4.5;
        break;
      case 2:
        toYValue = 4.5;
        break;
      case 3:
        toYValue = 4.5;
        break;
      case 4:
        toYValue = 4.5;
        break;
      case 5:
        toYValue = 4.5;
        break;
    }
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          fromY: 0.5,
          toY: toYValue,
          gradient: gradient,
          width: 26,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            topLeft: Radius.circular(6),
          ),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  });
}
