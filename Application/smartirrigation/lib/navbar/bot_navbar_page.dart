import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartirrigation/Pages/history/history_page.dart';
import 'package:smartirrigation/Pages/home/home_page.dart';
import 'package:smartirrigation/Pages/time_setting/time_setting_page.dart';


import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';


class botNavbar extends StatefulWidget {

  @override
  State<botNavbar> createState() => navbarState();
}

class navbarState extends State<botNavbar> {
  final controller = NotchBottomBarController(index: 1);
  final pageController = PageController(initialPage: 1);
  int maxCount = 3;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> bottomBarPages = [
    history(),
    homePage(),
    timeSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: controller,
              color: Color.fromRGBO(63, 148, 106, 1),
              showLabel: false,
              shadowElevation: 3,
              kBottomRadius: 0,
              notchColor: Colors.white,
              removeMargins: true,
              showShadow: true,
              durationInMilliSeconds: 300,
              elevation: 0,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.access_time_filled,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.access_time_filled,
                    color: Colors.black,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.black,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ],
              kIconSize: 24.0.sp,
              onTap: (index) {
                pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}
