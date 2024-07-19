import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:smartirrigation/controller/home_controller.dart';
import 'package:smartirrigation/routes/routes.dart';
import '../../controller/barcode_controller.dart';
import '../../controller/firestore_controller.dart';
import '../../controller/id_controller.dart';
import '../../controller/save_controller.dart';
import '../../controller/save_controller.dart';

class homePage extends StatelessWidget {
  final switchController = Get.put(SwitchController());
  final RangeSliderController controller = Get.put(RangeSliderController());
  final BarcodeController barcodeController = Get.put(BarcodeController());
  final FirestoreController firestoreController =
      Get.put(FirestoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(73.h),
        child: AppBar(
          elevation: 4.0.h, // Set elevation for shadow
          shadowColor: Colors.black, // Set shadow color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0.r),
              bottomRight: Radius.circular(10.0.r),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 7.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Image.asset('lib/assets/photos/logo_app.png'),
                      width: 70.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Text(
                        "HYDROS",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 16.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.w,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.grey),
                    elevation: MaterialStateProperty.all(5),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    )),
                  ),
                  onPressed: () {
                    SaveController.readIsLoggedIn().then((isLoggedIn) {
                      print('Is logged in: $isLoggedIn');
                    }).catchError((error) {
                      print('Error: $error');
                    });
                    Get.dialog(
                      AlertDialog(
                        title: Text('Keluar',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('Apakah Anda yakin ingin keluar?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Batal',
                                style: TextStyle(
                                    color: colors.mainColor, fontSize: 16.sp)),
                          ),
                          TextButton(
                            onPressed: () async {
                              barcodeController.setResult("");
                              await SaveController.saveIsLoggedIn(false);
                              Get.offAllNamed(routes.get_started);
                            },
                            child: Text('Keluar',
                                style: TextStyle(
                                    color: colors.mainColor, fontSize: 16.sp)),
                          ),
                        ],
                      ),
                    );
                  },
                  label: Text(
                    'Keluar',
                    style: TextStyle(
                        color: colors.mainColor,
                        fontSize: 20.sp,
                        fontFamily: 'Inter'),
                  ),
                  icon: Icon(
                    Icons.logout_outlined,
                    color: colors.mainColor,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: colors.mainColor,
        ),
      ),
      backgroundColor: colors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // suhu
              Container(
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
                              fontSize: 20.sp,
                            ),
                          )
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: firestoreController.getDataNow(
                            'Devices', 'DateTime'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                                color: colors.mainColor);
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Text('No data available');
                          }

                          final temperatureData = snapshot.data!.docs;
                          var latestData = temperatureData.first.data();

                          Map<String, dynamic> latestDataMap =
                              latestData as Map<String, dynamic>;

                          var temperatureArray = latestDataMap['Temperature'];

                          double lastTemperature =
                              temperatureArray.last.toDouble();

                          return GradientText(
                            '${lastTemperature.toStringAsFixed(0)}°C',
                            style: TextStyle(
                              fontSize: 90.sp,
                              fontFamily: 'Hanuman',
                              fontWeight: FontWeight.w600,
                            ),
                            colors: [
                              Color.fromRGBO(63, 148, 106, 1),
                              Color.fromRGBO(153, 202, 155, 1),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),

              // lembab udara & pompa
              SizedBox(
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
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Kelembaban Udara
                        children: <Widget>[
                          Container(
                            //decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 15.w, top: 10.h),
                                  child: Icon(
                                    Icons.air,
                                    size: 38.sp,
                                    color: colors.mainColor,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.h, right: 15.w),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: firestoreController.getDataNow(
                                          'Devices', 'DateTime'),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                              color: colors.mainColor);
                                        }

                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Text('No data available');
                                        }

                                        final humidityData =
                                            snapshot.data!.docs;
                                        var latestData =
                                            humidityData.first.data();

                                        Map<String, dynamic> latestDataMap =
                                            latestData as Map<String, dynamic>;

                                        var humidityArray =
                                            latestDataMap['Humidity'];

                                        double lastHumidity =
                                            humidityArray.last.toDouble();

                                        if (lastHumidity < 45)
                                          return Text(
                                            'Status: Kering',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 14.sp,
                                            ),
                                          );
                                        else if (lastHumidity >= 45 &&
                                            lastHumidity <= 65)
                                          return Text(
                                            'Status: Ideal',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 14.sp,
                                            ),
                                          );
                                        else
                                          return Text(
                                            'Status: Lembab',
                                            style: TextStyle(
                                              color: colors.greyColor,
                                              fontFamily: 'Hanuman',
                                              fontSize: 14.sp,
                                            ),
                                          );
                                      }),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          StreamBuilder<QuerySnapshot>(
                              stream: firestoreController.getDataNow(
                                  'Devices', 'DateTime'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                      color: colors.mainColor);
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text('No data available');
                                }

                                final humidityData = snapshot.data!.docs;
                                var latestData = humidityData.first.data();

                                Map<String, dynamic> latestDataMap =
                                    latestData as Map<String, dynamic>;

                                var humidityArray = latestDataMap['Humidity'];

                                double lastHumidity =
                                    humidityArray.last.toDouble();

                                return Container(
                                    //decoration: BoxDecoration(color: Colors.amber),
                                    child: Padding(
                                  padding: EdgeInsets.only(right: 15.w),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GradientText(
                                      '${lastHumidity.toStringAsFixed(1).replaceAll('.', ',')}%',
                                      style: TextStyle(
                                        fontSize: 55.sp,
                                        fontFamily: 'Hanuman',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      colors: [
                                        Color.fromRGBO(63, 148, 106, 1),
                                        Color.fromRGBO(153, 202, 155, 1),
                                      ],
                                    ),
                                  ),
                                ));
                              }),
                          Spacer(),
                          Container(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 15.w, bottom: 10.h),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Kelembaban Udara',
                                    style: TextStyle(
                                      color: colors.greyColor,
                                      fontFamily: 'Hanuman',
                                      fontSize: 12.5.sp,
                                    ),
                                  )),
                            ),
                            //decoration: BoxDecoration(color: Colors.amber),
                          ),
                        ],
                      ),
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
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //pompa
                        children: <Widget>[
                          Container(
                            //decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 15.w, top: 10.h),
                                  child: Icon(
                                    Icons.cyclone_outlined,
                                    size: 40.sp,
                                    color: colors.mainColor,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.h, right: 15.w),
                                  child: Text(
                                    'Pompa',
                                    style: TextStyle(
                                      color: colors.greyColor,
                                      fontFamily: 'Hanuman',
                                      fontSize: 19.sp,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Spacer(),
                          Expanded(
                            child: Container(
                                //decoration: BoxDecoration(color: Colors.amber),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirestoreController()
                                          .getDataNow('Devices', 'DateTime'),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                              color: colors.mainColor);
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final docs = snapshot.data!.docs;

                                          final switchOnData =
                                              docs.first['SwitchOn'];
                                          bool switchValue =
                                              switchOnData ?? false;
                                          switchController
                                              .toggleSwitch(switchValue);

                                          SaveController.readCountOn()
                                              .then((value) {
                                            switchController.counter(value);
                                          });

                                          int counterValue =
                                              switchController.counter.value;

                                          return Obx(() {
                                            switchController
                                                .toggleSwitch(switchValue);
                                            return LiteRollingSwitch(
                                              value: switchController
                                                  .valueSwitch.value,
                                              width: 118.w,
                                              textOn: 'ON',
                                              textOff: 'OFF',
                                              colorOn: colors.mainColor,
                                              colorOff: Color.fromRGBO(
                                                  146, 146, 146, 1),
                                              iconOn: Icons.lightbulb_outline,
                                              iconOff: Icons.power_settings_new,
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                              onChanged: (newValue) async {
                                                if (newValue == true) {
                                                  switchController
                                                      .counter.value++;
                                                  counterValue =
                                                      switchController
                                                          .counter.value;
                                                  await SaveController
                                                      .saveCountOn(
                                                          counterValue);
                                                }

                                                await FirestoreController()
                                                    .updateSwitchInFirestore(
                                                        'Devices',
                                                        'DateTime',
                                                        newValue);
                                                await FirestoreController()
                                                    .updateCountOn(
                                                        'Devices',
                                                        'DateTime',
                                                        counterValue);
                                                await FirestoreController()
                                                    .addPumpCollection(
                                                        'Devices',
                                                        'DateTime',
                                                        newValue);
                                              },
                                              textOnColor: Colors.white,
                                              textSize: 20.sp,
                                              onDoubleTap: () {},
                                              onSwipe: () {},
                                              onTap: () {},
                                            );
                                          });
                                        }
                                      },
                                    ))),
                          ),
                          SizedBox(
                            height: 4.h,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // soil
              Container(
                height: 180.h,
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
                  children: <Widget>[
                    Container(
                      //decoration: BoxDecoration(color: Colors.amber),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.grass_outlined,
                              size: 40.sp,
                              color: colors.mainColor,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: firestoreController.getDataNow(
                                    'Devices', 'DateTime'),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                        color: colors.mainColor);
                                  }

                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Text('No data available');
                                  }

                                  final soilData = snapshot.data!.docs;
                                  var latestData = soilData.first.data();

                                  Map<String, dynamic> latestDataMap =
                                      latestData as Map<String, dynamic>;

                                  var soilArray = latestDataMap['Soil'];

                                  double lastSoil = soilArray.last.toDouble();

                                  if (lastSoil <= 40)
                                    return Text(
                                      'Status: Kering',
                                      style: TextStyle(
                                        color: colors.greyColor,
                                        fontFamily: 'Hanuman',
                                        fontSize: 17.sp,
                                      ),
                                    );
                                  else if (lastSoil > 40 && lastSoil <= 60)
                                    return Text(
                                      'Status: Ideal',
                                      style: TextStyle(
                                        color: colors.greyColor,
                                        fontFamily: 'Hanuman',
                                        fontSize: 17.sp,
                                      ),
                                    );
                                  else
                                    return Text(
                                      'Status: Basah',
                                      style: TextStyle(
                                        color: colors.greyColor,
                                        fontFamily: 'Hanuman',
                                        fontSize: 17.sp,
                                      ),
                                    );
                                }),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    // angka
                    FittedBox(
                        //decoration: BoxDecoration(color: Colors.amber),
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: firestoreController.getDataNow(
                                'Devices', 'DateTime'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                    color: colors.mainColor);
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text('No data available');
                              }

                              final soilData = snapshot.data!.docs;
                              var latestData = soilData.first.data();

                              Map<String, dynamic> latestDataMap =
                                  latestData as Map<String, dynamic>;

                              var soilArray = latestDataMap['Soil'];

                              double lastSoil = soilArray.last.toDouble();

                              return Padding(
                                padding: EdgeInsets.only(left: 15.w),
                                child: GradientText(
                                  '${lastSoil.toStringAsFixed(1).replaceAll('.', ',')}%',
                                  style: TextStyle(
                                    fontSize: 62.sp,
                                    fontFamily: 'Hanuman',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  colors: [
                                    Color.fromRGBO(63, 148, 106, 1),
                                    Color.fromRGBO(153, 202, 155, 1),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          width: 10.w,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirestoreController()
                                .getDataNow('Devices', 'DateTime'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return CircularProgressIndicator(
                                  color: colors.mainColor,
                                );
                              else if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else {
                                final docs = snapshot.data!.docs;

                                final inputStartData =
                                    docs.first['inputSoilStart'];
                                final inputEndData = docs.first['inputSoilEnd'];
                                controller.updateValues(SfRangeValues(
                                    inputStartData, inputEndData));

                                return Obx(() => SfRangeSliderTheme(
                                      data: SfRangeSliderThemeData(
                                        tooltipBackgroundColor:
                                            Color.fromARGB(255, 100, 100, 100),
                                        inactiveTrackHeight: 10.h,
                                        activeTrackHeight: 12.h,
                                        trackCornerRadius: 10.r,
                                        tooltipTextStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13.sp,
                                          //fontStyle: FontStyle.italic
                                        ),
                                        thumbRadius: 11.r,
                                        thumbStrokeColor: Colors.white,
                                        thumbStrokeWidth: 1.2.w,
                                        //overlappingThumbStrokeColor: Colors.black,
                                      ),
                                      child: SfRangeSlider(
                                        min: 0,
                                        max: 100,
                                        stepSize: 1,
                                        values: controller.values.value,
                                        //interval: 20,
                                        //showTicks: true,
                                        inactiveColor: Colors.grey,
                                        activeColor: colors.mainColor,
                                        //thumbShape: SfThumbShape(),
                                        showLabels: true,
                                        enableTooltip: true,
                                        minorTicksPerInterval: 1,
                                        //numberFormat: NumberFormat("#.###%"),
                                        onChanged: (SfRangeValues values) {
                                          controller.updateValues(values);
                                        },
                                        onChangeEnd: (SfRangeValues values) {
                                          Future.delayed(
                                              Duration(milliseconds: 1000),
                                              () async {
                                            // send data ke firestore
                                            await FirestoreController()
                                                .updateSoilStartInFirestore(
                                                    'Devices',
                                                    'DateTime',
                                                    values.start);
                                            await FirestoreController()
                                                .updateSoilEndInFirestore(
                                                    'Devices',
                                                    'DateTime',
                                                    values.end);
                                          });
                                        },
                                      ),
                                    ));
                              }
                            })
                      ],
                    )),
                    Spacer(),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.w, bottom: 10.h),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 15.sp,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Text(
                                    'Atur kelembaban tanah sesuai yang diinginkan.',
                                    style: TextStyle(
                                      color: colors.greyColor,
                                      fontFamily: 'Hanuman',
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      //decoration: BoxDecoration(color: Colors.amber),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
