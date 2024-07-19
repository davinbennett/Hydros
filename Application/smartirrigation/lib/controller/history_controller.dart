import 'package:get/get.dart';
import 'package:intl/intl.dart';

class datePicker extends GetxController {
  var selectedDate = DateTime.now().obs;

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  DateTime get getDate => selectedDate.value;

  String getNameDate() => DateFormat('EEEE', 'id_ID').format(selectedDate.value);
  
  String getNameMonth() =>
      DateFormat('MMMM', 'id_ID').format(selectedDate.value);
}
