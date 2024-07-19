import 'package:get/get.dart';

class CounterController extends GetxController {
  var n = 0.obs;

  void increment() {
    n.value++; 
  }

  void reset() {
    n.value = 0; 
  }
}
