// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:absensi/constant/url.dart';
import 'package:absensi/model/db/database.dart';
import 'package:absensi/screen/home.dart';
import 'package:absensi/utils/routers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  ///Base Url
  final requestBaseUrl = AppUrl.baseUrl;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';

  //Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  //Login
  void loginUser({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$requestBaseUrl/api/auth/login";

    final body = {"username": email, "password": password};
    print(body);

    try {
      http.Response req = await http.post(Uri.parse(url), body: body);
      print(req);
      final res = json.decode(req.body);
      if (res['status'] == true) {
        _isLoading = false;
        _resMessage = "Login successfull!";
        notifyListeners();

        final userId = res['data']['nama'];
        final token = res['data']['token'];

        DatabaseProvider().saveToken(token);
        DatabaseProvider().saveUserId(userId);
        PageNavigator(ctx: context).nextPageOnly(page: const Home());
      } else {
        final res = json.decode(req.body);
        _resMessage = res['message'];
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available`";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again`";
      notifyListeners();
    }
  }

  void clear() {
    _resMessage = "";
    notifyListeners();
  }
}
