import 'package:flutter/material.dart';
import '/data/beacons.dart';
import '/location/location.dart';
import '/models/measurement.dart';
import '/models/beacon_measured.dart';
import '/models/beacon_average.dart';
import '/models/square.dart';
import '/models/section.dart';
import 'dart:math';

/*    x
 |a--|---|--b|
 | A | B | C |
 |---|---|---|
y| D | E | F |
 |---|---|---|
 | G | H | I |
 |c--|---|--d|
*/

class Sections {
    static final a = Beacons.getByName("a")!;
    static final b = Beacons.getByName("b")!;
    static final c = Beacons.getByName("c")!;
    static final d = Beacons.getByName("d")!;

    static List<Section> sections = [
        Section("A", Square(Point(  0,   0), Point( 40,  40)), Colors.red),
        Section("B", Square(Point( 40,   0), Point( 80,  40)), Colors.orange),
        Section("C", Square(Point( 80,   0), Point(120,  40)), Colors.yellow),
        Section("D", Square(Point(  0,  40), Point( 40,  80)), Colors.green),
        Section("E", Square(Point( 40,  40), Point( 80,  80)), Colors.blue),
        Section("F", Square(Point( 80,  40), Point(120,  80)), Colors.indigo),
        Section("G", Square(Point(  0,  80), Point( 40, 120)), Colors.purple),
        Section("H", Square(Point( 40,  80), Point( 80, 120)), Colors.teal),
        Section("I", Square(Point( 80,  80), Point(120, 120)), Colors.brown),
    ];

    static Section? getSection(Set<Measurement> measurements) {
        final position = Location.getLocation(measurements);
        if (position == null) return null;

        for (final section in sections) {
            if (section.square.contains(position)) {
                print("Position $position liegt in Section ${section.name}");
                return section;
            }
        }

        return null;
    }
}