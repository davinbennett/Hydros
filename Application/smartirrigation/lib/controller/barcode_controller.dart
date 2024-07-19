import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smartirrigation/controller/save_controller.dart';

class BarcodeController extends GetxController {
  static final BarcodeController _instance = BarcodeController._internal();

  factory BarcodeController() {
    return _instance;
  }

  BarcodeController._internal();

  var flashOn = false.obs;
  var scanValue = ''.obs;

  void _readScanValueFromPrefs() async {
    String? savedValue = await SaveController.readLogin();
    if (savedValue != null) {
      scanValue.value = savedValue;
    }
  }

  void setResult(String? value) {
    String newValue = value ?? '';
    scanValue.value = newValue;
    SaveController.saveLogin(newValue);
  }

  String? getResult() {
    return scanValue.isNotEmpty ? scanValue.value : '';
  }

  @override
  void onInit() {
    super.onInit();
    toggleFlash();
    _readScanValueFromPrefs();
  }

  void toggleFlash() {
    flashOn.value = !flashOn.value;
  }

}
