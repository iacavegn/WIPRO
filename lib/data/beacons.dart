import 'package:flutter/material.dart';

class Beacons {
  static const Map<String, String> beacons = {
    "E9683774-D2D7-518F-B59B-C09555934BBB": "a",
    "137BDCDD-112B-09BC-7F96-5CB779877BCD": "b",
    "C9520664-CBB7-B552-375E-CE9A3C9BA773": "c",
    "FB68E05A-B028-7AC3-5B72-DC054EA9AB90": "d",
  };

  static const Map<String, int> rssiAt1m = {
    "a": -65,
    "b": -65,
    "c": -65,
    "d": -70,
  };

  static const Map<String, Color> placeColors = {
    "a": Colors.red,
    "b": Colors.green,
    "c": Colors.blue,
    "d": Colors.purple,
  };
}
