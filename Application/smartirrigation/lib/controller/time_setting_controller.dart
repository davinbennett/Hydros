// time picker
import 'dart:async';

import 'package:get/get.dart';
import 'package:smartirrigation/controller/firestore_controller.dart';
import 'package:smartirrigation/models/time_model.dart';

class TimePickerController {
  var hour = 0.obs;
  var minute = 0.obs;
  var timeFormat = "AM".obs;
}

// list waktu
class ListWaktuController extends GetxController {
  var listTimes = Rx<List<TimeModel>>([]);
  late TimeModel timeModel;
  var itemCount = 0.obs;
  late Timer timer;
  var countdowns = <Duration>[].obs;
  var timers = <int, Timer?>{};
  final FirestoreController firestoreController =
      Get.put(FirestoreController());

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    for (var timer in timers.values) {
      timer?.cancel();
    }
    timers.clear();
    super.onClose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      for (var i = 0; i < listTimes.value.length; i++) {
        countdowns[i] = calculateCountdown(listTimes.value[i]);
        if (countdowns[i].inSeconds <= 0) {
          removeTime(i);
        }
      }
    });
  }

  Duration calculateCountdown(TimeModel scheduledTime) {
    DateTime now = DateTime.now();
    DateTime scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      scheduledTime.timeFormat == 'PM' && scheduledTime.hour < 12
          ? scheduledTime.hour + 12
          : scheduledTime.hour,
      scheduledTime.minute,
    );

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(Duration(days: 1));
    }

    Duration difference = scheduledDateTime.difference(now);
    return difference;
  }

  @override
  void onReady() {
    super.onReady();
  }

  void addTime(int hour, int minute, String timeFormat) {
    timeModel = TimeModel(hour: hour, minute: minute, timeFormat: timeFormat);
    listTimes.value.add(timeModel);
    itemCount.value = listTimes.value.length;
    countdowns.add(calculateCountdown(timeModel));

    Timer timer = Timer.periodic(Duration(seconds: 1), (_) {
      int index = listTimes.value.indexOf(timeModel);
      countdowns[index] = calculateCountdown(timeModel);
      if (countdowns[index].inSeconds <= 0) {
        removeTime(index);
      }
    });
    timers[listTimes.value.length - 1] = timer;
  }

  void removeTime(int index) {
    listTimes.value.removeAt(index);
    countdowns.removeAt(index);
    itemCount.value--;
    timers[index]?.cancel();
    timers.remove(index);
    firestoreController.removeAlarmTimestamp(index);
  }

  String getFormattedDifference(Duration difference) {
    //difference += Duration(seconds: 5); 
    if (difference.inSeconds <= 0) {
      return 'Waktu sudah habis';
    } else if (difference.inHours < 1) {
      int minutes = difference.inMinutes;
      int seconds = difference.inSeconds.remainder(60);
      return 'Pompa nyala dalam $minutes menit $seconds detik';
    } else {
      int days = difference.inDays;
      int hours = difference.inHours.remainder(24);
      int minutes = difference.inMinutes.remainder(60);

      if (days > 0) {
        return 'Pompa nyala dalam $days hari $hours jam $minutes menit';
      } else if (hours > 0) {
        return 'Pompa nyala dalam $hours jam $minutes menit';
      } else {
        return 'Pompa nyala dalam $minutes menit';
      }
    }
  }
}
