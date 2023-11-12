import 'package:absensi/model/absen.dart';
import 'package:absensi/model/db/database.dart';
import 'package:absensi/utils/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the user ID when the widget is initialized
    final userDataProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    userDataProvider.getUserId();
  }

  bool positionStreamStarted = false;

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
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Welcome",
              style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth / 20),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Employee ${userDataProvider.userId}',
              style:
                  TextStyle(fontFamily: "NexaBold", fontSize: screenWidth / 18),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Todays's Status",
              style:
                  TextStyle(fontFamily: "NexaBold", fontSize: screenWidth / 18),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2))
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54),
                        ),
                        Text("09:30",
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 20,
                            ))
                      ]),
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54),
                        ),
                        Text("--/--",
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 20,
                            ))
                      ]),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                        color: primary),
                    children: [
                      TextSpan(
                          text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                              color: Colors.black, fontSize: screenWidth / 20))
                    ]),
              )),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54),
                  ),
                );
              }),
          Container(
              margin: const EdgeInsets.only(top: 24),
              alignment: Alignment.centerLeft,
              child: Consumer<AbsenProvider>(builder: (context, absen, child) {
                final GlobalKey<SlideActionState> key = GlobalKey();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (absen.resMessage != '') {
                    showMessage(message: absen.resMessage, context: context);
                    absen.clear();
                  }
                });
                return SlideAction(
                  text: "Slide to Check Out",
                  textStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: screenWidth / 20,
                      fontFamily: "NexaRegular"),
                  outerColor: Colors.white,
                  innerColor: primary,
                  key: key,
                  onSubmit: absen.isLoading
                      ? null
                      : () async {
                          final status = await Permission.location.request();
                          if (status.isGranted) {
                            final position = await GeolocatorPlatform.instance
                                .getCurrentPosition();
                            final checkin =
                                DateFormat('hh:mm').format(DateTime.now());
                            final lat = position.latitude;
                            final long = position.longitude;
                            absen.checkin(
                              userid: userDataProvider.userId,
                              checkin: checkin,
                              lat: lat,
                              long: long,
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            showMessage(
                                message: "Location permission denied.",
                                context: context);
                          }
                        },
                );
              }))
        ],
      ),
    ));
  }
}
