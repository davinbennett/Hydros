import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/src/types/barcode.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:smartirrigation/controller/barcode_controller.dart';
import 'package:smartirrigation/routes/routes.dart';

import '../../controller/firestore_controller.dart';
import '../../controller/id_controller.dart';
import '../../controller/save_controller.dart';

class id extends StatelessWidget {
  final BarcodeController barcodeController = BarcodeController();
  final inputIDcontroller = TextEditingController();
  final CounterController counterController = Get.put(CounterController());
  final FirestoreController firestoreController = FirestoreController();
  bool isDialogShown = false;

  @override
  Widget build(BuildContext context) {
    print("n = ${counterController.n.value}");
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
              padding: EdgeInsets.only(
                  top: 40.h, left: 35.w, right: 35.w, bottom: 120.h),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Masukkan ID',
                          style: TextStyle(
                              fontFamily: 'Hanuman', fontSize: 20.sp)),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          barcodeController.setResult(value);
                          print(value);
                        },
                        cursorColor: colors.mainColor.withOpacity(0.8),
                        maxLength: 30,
                        decoration: InputDecoration(
                          labelText: 'ID',
                          prefixIcon: Icon(
                            Icons.verified_user_outlined,
                            color: colors.mainColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colors.mainColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: colors.greyColor.withOpacity(0.5)),
                          ),
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                              color: colors.greyColor.withOpacity(0.7),
                              fontFamily: 'Hanuman',
                              fontSize: 18.sp),
                          focusColor: colors.mainColor,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (barcodeController.getResult()?.isNotEmpty ??
                              false) {
                            print(barcodeController.getResult());
                            searchID(context);
                          }
                        },
                        child: Text(
                          "Cari ID",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Hanuman',
                              fontSize: 16.5.sp),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(2),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(78.w, 39.h)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              colors.mainColor),
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
                    for (int i = -1; i < counterController.n.value; i++)
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
            Positioned(
              top: 20.h,
              right: 20.w,
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
                    Get.toNamed(routes.qr);
                    counterController.increment();
                    print("n = ${counterController.n.value}");
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
                    Icons.qr_code_outlined,
                    color: colors.mainColor,
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

  void searchID(BuildContext context) async {
    await SaveController.saveLogin(barcodeController.getResult() ?? "");
    List<String> documentIDs = await firestoreController.getDocumentIDs();
    if (documentIDs.contains(barcodeController.getResult()) && !isDialogShown) {
      isDialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Perangkat Ditemukan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
                'Perangkat telah berhasil ditemukan. Apakah Anda ingin menghubungkannya?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  barcodeController.setResult("");
                  await SaveController.saveIsLoggedIn(false);
                  Get.back();
                  isDialogShown = false;
                },
                child: Text(
                  'Batal',
                  style: TextStyle(color: colors.mainColor, fontSize: 16.sp),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.dialog(Center(child: CircularProgressIndicator()));
                  await SaveController.saveIsLoggedIn(true);
                  Future.delayed(Duration(seconds: 2), () {
                    Get.offAllNamed(routes.bot_navbar);
                  });
                },
                child: Text('Hubungkan Perangkat',
                    style: TextStyle(color: colors.mainColor, fontSize: 16.sp)),
              ),
            ],
          );
        },
      );
    } else if (!isDialogShown) {
      //await SaveController.saveIsLoggedIn(false);
      print(barcodeController.getResult());
      isDialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Perangkat Tidak Ditemukan', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(
                'Perangkat dengan ID ${barcodeController.getResult()} tidak ditemukan.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  barcodeController.setResult("");
                  Get.back();
                  isDialogShown = false;
                },
                child: Text('Tutup', style: TextStyle(color: colors.mainColor, fontSize: 16.sp)),
              ),
            ],
          );
        },
      );
    }
  }
}
