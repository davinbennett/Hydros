import 'package:get/get.dart';

class navbarController extends GetxController {
  var i = 0;
  void changeTab(int index) {
    i = index;
    update();
  }
}
