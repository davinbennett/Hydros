import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SwitchController extends GetxController {
  var valueSwitch = false.obs;
  RxInt counter = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  void toggleSwitch(bool newValue) {
    valueSwitch.value = newValue;
  }

  void countOn(int value){
    counter.value = value;
  }
}

class RangeSliderController extends GetxController {
  var values = SfRangeValues(0, 100).obs;

  void updateValues(dynamic newValues) {
    if (newValues is SfRangeValues) {
      values.value = newValues;
    }
  }
}


