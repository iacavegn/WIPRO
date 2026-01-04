import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '/models/section.dart';
import '/data/beacons.dart';
import '/models/beacon.dart';
import '/models/beacon_measured.dart';

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
        Section("A", {a: 0,b: 2,c: 2,d: 3, }, Colors.red),
        Section("C", {a: 2,b: 0,c: 3,d: 2, }, Colors.yellow),
        Section("G", {a: 2,b: 3,c: 0,d: 2, }, Colors.purple),
        Section("I", {a: 3,b: 2,c: 2,d: 1, }, Colors.brown),
    ];

    static List<Section> sectionsB = [
        Section("A", {a: 0,b: 2,c: 2,d: 3, }, Colors.red),
        Section("B", {a: 1,b: 1,c: 2,d: 2, }, Colors.orange),
        Section("C", {a: 2,b: 0,c: 3,d: 2, }, Colors.yellow),
        Section("D", {a: 1,b: 2,c: 1,d: 2, }, Colors.green),
        Section("E", {a: 1,b: 1,c: 1,d: 1, }, Colors.blue),
        Section("F", {a: 2,b: 1,c: 2,d: 1, }, Colors.indigo),
        Section("G", {a: 2,b: 3,c: 0,d: 2, }, Colors.purple),
        Section("H", {a: 2,b: 2,c: 1,d: 1, }, Colors.teal),
        Section("I", {a: 3,b: 2,c: 2,d: 1, }, Colors.brown),
    ];

    static Section? getSection(List<BeaconMeasured> others) {
        if (others.length != sections[1].beaconsWithDistances.length) return null;
        
        others.sort((a, b) => b.rssi.compareTo(a.rssi));
        List<Beacon> bs = others.map((bm) => bm.beacon).toList();

        print(others.map((b) => b.distance).join(', '));
        print(bs.map((b) => b.name).join(', '));

        for (final section in sections) {
            if (listEquals(section.getSortedBeacons(), bs)) {
                return section;
            }
        }

        
        return null;
    }
}