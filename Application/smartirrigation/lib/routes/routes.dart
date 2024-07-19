import 'package:get/get.dart';
import 'package:smartirrigation/Pages/GetStarted_page/getStarted_page.dart';
import 'package:smartirrigation/Pages/audit_log/auditLog_page.dart';

import '../Pages/history/history_page.dart';
import '../Pages/home/home_page.dart';
import '../Pages/scan_qr/barcode_page.dart';
import '../Pages/scan_qr/id_page.dart';
import '../Pages/time_setting/time_setting_page.dart';
import '../Pages/welcome_screen/welcome_screen_page.dart';
import '../navbar/bot_navbar_page.dart';

class routes {
  static final pages = [
    GetPage(name: welcome, page: () => welcomeScreen()),
    GetPage(name: home, page: () => homePage()),
    GetPage(name: history_, page: () => history()),
    GetPage(name: time_Setting, page: () => timeSetting()),
    GetPage(name: Id, page: () => id()),
    GetPage(name: qr, page: () => barcode()),
    GetPage(name: bot_navbar, page: () => botNavbar()),
    GetPage(name: audit_log, page: () => auditLog()),
    GetPage(name: get_started, page: () => getStarted()),
  ];

  static const welcome = '/welcome';
  static const home = '/home';
  static const history_ = '/history';
  static const time_Setting = '/timeSetting';
  static const Id = '/id';
  static const qr = '/qr';
  static const bot_navbar = '/bot_navbar';
  static const audit_log = '/auditLog';
  static const get_started = '/getstarted';
}
