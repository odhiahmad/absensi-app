import 'package:absensi/screen/calendarscreen.dart';
import 'package:absensi/screen/profilescreen.dart';
import 'package:absensi/screen/todayscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double screenHeight = 0;
  double screenWidth = 0;
  int currentIndex = 0;
  Color primary = Color(0xffeef444c);
  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [CalendarScreeen(), TodayScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = i;
                            });
                          },
                          child: Container(
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.white,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(navigationIcons[i],
                                      color: i == currentIndex
                                          ? primary
                                          : Colors.black45,
                                      size: i == currentIndex ? 30 : 26),
                                  i == currentIndex
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          height: 3,
                                          width: 22,
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(40))),
                                        )
                                      : const SizedBox()
                                ],
                              ))))),
                }
              ],
            ),
          )),
    );
  }
}
