import 'package:absensi/model/db/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = Color(0xffeef444c);
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final userDataProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(
              top: screenHeight / 15, bottom: screenHeight / 20),
          child: Text(
            "Logout",
            style:
                TextStyle(fontSize: screenWidth / 18, fontFamily: "NexaBold"),
          ),
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    userDataProvider.logOut(context);
                  },
                  child: Container(
                      height: 60,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: screenHeight / 40),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 26,
                              color: Colors.white,
                              letterSpacing: 2),
                        ),
                      )),
                )
              ],
            ))
      ]),
    );
  }
}
