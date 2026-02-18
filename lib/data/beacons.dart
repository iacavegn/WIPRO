import 'package:flutter/material.dart';
import '/models/beacon.dart';

class Beacons {
  static List<Beacon> beacons = [
    Beacon("E9683774-D2D7-518F-B59B-C09555934BBB", "a", -65),
    Beacon("137BDCDD-112B-09BC-7F96-5CB779877BCD", "b", -65),
    Beacon("C9520664-CBB7-B552-375E-CE9A3C9BA773", "c", -65),
    Beacon("FB68E05A-B028-7AC3-5B72-DC054EA9AB90", "d", -70),
  ];

  static List<String> getAllIds() {
    return beacons.map((beacon) => beacon.id).toList();
  }

  static String? getNameById(String id) {
    final beacon = beacons?.firstWhere(
      (b) => b.id == id
    );
    return beacon?.name;
  }

  static Beacon? getByName(String name) {
    return beacons?.firstWhere(
      (b) => b.name == name
    );
  }

  static Beacon? getById(String id) {
    return beacons?.firstWhere(
      (b) => b.id == id
    );
  }

  static const Map<String, int> rssiAt1m = {
    "a": -65,
    "b": -65,
    "c": -65,
    "d": -70,
  };
}
