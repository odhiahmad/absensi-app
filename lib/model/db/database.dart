import 'dart:convert';

import 'package:absensi/screen/loginscreen.dart';
import 'package:absensi/utils/routers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Person {
  String userid;
  String token;
  String id;
  String name;

  Person(
      {required this.userid,
      required this.token,
      required this.id,
      required this.name});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      userid: json['userid'],
      token: json['atokenge'],
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'token': token,
      'id': id,
      'name': name,
    };
  }
}

class MyObject {
  String name;
  int age;

  MyObject({required this.name, required this.age});
}

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _token = '';

  String _userId = '';

  String get token => _token;

  String get userId => _userId;

  void saveToken(String token) async {
    SharedPreferences value = await _pref;

    value.setString('token', token);
  }

  void saveUserId(String id) async {
    SharedPreferences value = await _pref;

    value.setString('id', id);
  }

  void saveUser(Person person) async {
    final SharedPreferences value = await SharedPreferences.getInstance();
    final String objectJson = jsonEncode(person.toJson());
    value.setString('myObject', objectJson);
  }

  Future<String> getToken() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('token')) {
      String data = value.getString('token')!;
      _token = data;
      notifyListeners();
      return data;
    } else {
      _token = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getUserId() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('id')) {
      String data = value.getString('id')!;
      _userId = data;
      notifyListeners();
      return data;
    } else {
      _userId = '';
      notifyListeners();
      return '';
    }
  }

  void logOut(BuildContext context) async {
    final value = await _pref;

    value.clear();

    // ignore: use_build_context_synchronously
    PageNavigator(ctx: context).nextPageOnly(page: const LoginScreen());
  }
}
