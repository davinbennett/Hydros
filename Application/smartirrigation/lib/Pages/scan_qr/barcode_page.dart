import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smartirrigation/colors/colors.dart';
import 'package:smartirrigation/controller/firestore_controller.dart';
import 'package:smartirrigation/controller/save_controller.dart';
import 'package:smartirrigation/routes/routes.dart';

import '../../controller/barcode_controller.dart';
import '../../controller/id_controller.dart';

class barcode extends StatelessWidget {
  final BarcodeController barcodeController = Get.put(BarcodeController());
  final CounterController counterController = Get.put(CounterController());
  final FirestoreController firestoreController =
      Get.put(FirestoreController());
  bool isDialogShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            QRViewWidget(
                barcodeController: barcodeController,
                firestoreController: firestoreController,
                isDialogShown: isDialogShown),
            Positioned(
              top: 15.h,
              left: 15.w,
              child: Container(
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: Colors.white,
                // ),
                width: 35.w,
                height: 35.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //color: Color.fromARGB(113, 148, 148, 148),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (counterController.n.value > 0) {
                      Get.back();
                      Get.back();
                    }
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(164, 180, 180, 180)),
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
                    size: 25.sp,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pindai',
                    style: TextStyle(
                        fontFamily: 'Hanuman',
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 15.h,
              right: 15.w,
              child: Obx(() => Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: barcodeController.flashOn.value
                          ? colors.mainColor
                          : colors.mainColor.withOpacity(0.5),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        barcodeController.toggleFlash();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 255, 255)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0.r),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.zero),
                      ),
                      child: Icon(
                        barcodeController.flashOn.value
                            ? Icons.flash_off
                            : Icons.flash_on,
                        color: barcodeController.flashOn.value
                            ? colors.mainColor.withOpacity(0.5)
                            : colors.mainColor,
                        size: 20.sp,
                      ),
                    ),
                  )),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150.h,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 126.w, vertical: 55.h),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAndToNamed(
                        routes.Id,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(colors.mainColor),
                      elevation: MaterialStateProperty.all<double>(1),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                    ),
                    child: Text(
                      'Masukkan ID',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hanuman',
                          fontSize: 16.sp),
                    ),
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

class QRViewWidget extends StatelessWidget {
  final BarcodeController barcodeController;
  final FirestoreController firestoreController;
  bool isDialogShown;

  QRViewWidget(
      {Key? key,
      required this.barcodeController,
      required this.firestoreController,
      required this.isDialogShown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QRView(
      overlay: QrScannerOverlayShape(
          borderColor: colors.mainColor,
          borderRadius: 20.r,
          borderLength: 32.h,
          borderWidth: 9.w,
          cutOutSize: 270,
          cutOutBottomOffset: 65.h),
      key: GlobalKey(debugLabel: 'QR'),
      onQRViewCreated: (controller) async {
        controller.scannedDataStream.listen((scanData) async {
          String data = scanData.code as String;

          barcodeController.setResult(data);
          await SaveController.saveLogin(barcodeController.getResult() ?? "");
          List<String> documentIDs = await firestoreController.getDocumentIDs();
          if (documentIDs.contains(barcodeController.getResult()) &&
              !isDialogShown) {
            isDialogShown = true;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Perangkat Ditemukan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                      child: Text('Batal',
                          style: TextStyle(
                              color: colors.mainColor, fontSize: 16.sp)),
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
                          style: TextStyle(
                              color: colors.mainColor, fontSize: 16.sp)),
                    ),
                  ],
                );
              },
            );
          } else if (!isDialogShown) {
            //await SaveController.saveIsLoggedIn(false);
            isDialogShown = true;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Perangkat Tidak Ditemukan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Obx(() => Text(
                      'Perangkat dengan ID ${barcodeController.getResult()} tidak ditemukan.')),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        barcodeController.setResult("");
                        Get.back();
                        isDialogShown = false;
                      },
                      child: Text('Tutup',
                          style: TextStyle(
                              color: colors.mainColor, fontSize: 16.sp)),
                    ),
                  ],
                );
              },
            );
          }
        });
        //controller.toggleFlash();
        barcodeController.flashOn.listen((value) {
          controller.toggleFlash();
        });
      },
    );
  }
}
