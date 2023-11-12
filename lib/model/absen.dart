// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:absensi/constant/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Location {
  double latitude;
  double longitude;

  Location(this.latitude, this.longitude);
}

class AbsenProvider extends ChangeNotifier {
  ///Base Url
  final requestBaseUrl = AppUrl.baseUrl;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';

  //Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  //Login
  void checkin({
    required String userid,
    required String checkin,
    required double lat,
    required double long,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    Location location1 = Location(lat, long); // New York City
    Location location2 = Location(-0.9587, 100.3792);

    print(lat);

    bool result = isLocationInRadius(location1, location2, 40);

    if (result) {
      String url = "$requestBaseUrl/api/absen/create";

      final body = {
        "userid": userid,
        "checkin": checkin,
        "lat": lat.toString(),
        "long": long.toString()
      };
      print(body);

      try {
        http.Response req = await http.post(Uri.parse(url), body: body);
        print(req);
        final res = json.decode(req.body);
        if (res['status'] == true) {
          _isLoading = false;
          _resMessage = "Absen successfull created!";
          notifyListeners();
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
        print(e);
        _isLoading = false;
        _resMessage = "Please try again`";
        notifyListeners();
      }
    } else {
      _isLoading = false;
      _resMessage = "Location is not within the specified radius";
      notifyListeners();
    }
  }

  void clear() {
    _resMessage = "";
    notifyListeners();
  }

  // Haversine formula to calculate the distance between two points on the Earth's surface
  double haversine(Location location1, Location location2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers

    // Convert degrees to radians
    double lat1Rad = location1.latitude * pi / 180;
    double lon1Rad = location1.longitude * pi / 180;
    double lat2Rad = location2.latitude * pi / 180;
    double lon2Rad = location2.longitude * pi / 180;

    // Haversine formula
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  bool isLocationInRadius(
      Location location1, Location location2, double radius) {
    // Calculate the distance between the two locations using the Haversine formula
    double distance = haversine(location1, location2);

    // Check if the distance is within the specified radius
    return distance <= radius;
  }
}
