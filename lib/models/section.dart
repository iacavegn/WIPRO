import 'package:flutter/material.dart';
import 'beacon.dart';
import '/models/square.dart';

class Section {
    final String name;
    final Square square;
    final Color color;

    Section(
        this.name,
        this.square,
        this.color,
    ) { 
        print("Section $name created with square: $square and color: $color");
    }

    @override
    String toString() => 'Section(name: $name, square: $square, color: $color)';
}
