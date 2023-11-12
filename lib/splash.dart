import 'package:absensi/model/db/database.dart';
import 'package:absensi/screen/home.dart';
import 'package:absensi/screen/loginscreen.dart';
import 'package:absensi/utils/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: FlutterLogo()),
    );
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      DatabaseProvider().getToken().then((value) {
        if (value == '') {
          PageNavigator(ctx: context).nextPageOnly(
              page: const KeyboardVisibilityProvider(child: LoginScreen()));
        } else {
          PageNavigator(ctx: context).nextPageOnly(page: const Home());
        }
      });
    });
  }
}
