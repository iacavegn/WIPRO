import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'data/beacons.dart';
import 'services/bluetooth_scan_service.dart';
import 'data/sections.dart';
import 'models/beacon.dart';
import 'models/beacon_measured.dart';
import 'models/measurement.dart';
import 'location/location.dart';

class BackgroundPage extends StatelessWidget {
  const BackgroundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Scanner',
      home: const BluetoothScannerPage(),
    );
  }
}

class BluetoothScannerPage extends StatefulWidget {
  const BluetoothScannerPage({super.key});

  @override
  State<BluetoothScannerPage> createState() =>
      _BluetoothScannerPageState();
}

class _BluetoothScannerPageState extends State<BluetoothScannerPage> {
  final _scanService = BluetoothScanService();
  final Set<Measurement> _setOfMeasurements = {};

  bool _isScanning = false;
  Color _bgColor = Colors.white;
  Timer? _timer;
  Offset? _point;

  final int _amountOfBeaconsToFind = Beacons.getAmountOfBeacons();

  late final List<String> _allowedIds;

  @override
  void initState() {
    super.initState();
    _allowedIds = Beacons.getAllIds();
    _startScan();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scanService.stopScan();
    super.dispose();
  }

  void _startScan() {
    if (_isScanning) return;

    List<BeaconMeasured> beacons = [];

    _scanService.startScan(
      filter: (id) => _allowedIds.contains(id),
      amountOfDevicesToFind: _amountOfBeaconsToFind,
      onResults: (results) {
        if (_setOfMeasurements.length >= 100) {
          _setOfMeasurements.remove(_setOfMeasurements.first);
        }
        beacons
          ..clear()
          ..addAll(
            results.map((b) => BeaconMeasured(Beacons.getById(b.device.id.id)!, b.rssi)),
          );
        _setOfMeasurements.add(Measurement(beacons));
        print("Set of Measurements ${_setOfMeasurements.length}");

        setState(() {
          _bgColor = _getBackgroundColor();
          _point = getPointFromLatestMeasurement();
        });
      },
    );
  }

  Color _getBackgroundColor() {
    if (_setOfMeasurements.length == 5) {
      return _bgColor;
    } else {
      return Sections.getSection(_setOfMeasurements)?.color ?? _bgColor;
    }
  }

  Offset? getPointFromLatestMeasurement() {
    final point = Location.getLocation(_setOfMeasurements);
    if (point == null) return null;
    return Offset(point.x, point.y);
  }

  @override
  Widget build(BuildContext context) {
    // Beispielpunkt bei x=60, y=80
    return Scaffold(
      backgroundColor: _bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final squareSide = size.shortestSide;

          final offsetX = (size.width - squareSide) / 2;
          final offsetY = (size.height - squareSide) / 2;

          final scale = squareSide / 120;

          return Stack(
            children: [
              CustomPaint(
                size: size,
                painter: GridPainterCentered(
                  scale: scale,
                  offsetX: offsetX,
                  offsetY: offsetY,
                  point: _point,
                ),
              ),
              Center(
                child: Text(
                  'Scanne nach Beacons...\nGefundene Messungen: ${_setOfMeasurements.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// CustomPainter mit Punktanzeige
class GridPainterCentered extends CustomPainter {
  final double scale;
  final double offsetX;
  final double offsetY;
  final Offset? point; // Punkt optional

  GridPainterCentered({
    required this.scale,
    required this.offsetX,
    required this.offsetY,
    this.point,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1;

    // Vertikale Linien bei 40 und 80
    for (int i = 1; i < 3; i++) {
      double x = offsetX + i * 40 * scale;
      canvas.drawLine(Offset(x, offsetY), Offset(x, offsetY + 120 * scale), paint);
    }

    // Horizontale Linien bei 40 und 80
    for (int i = 1; i < 3; i++) {
      double y = offsetY + i * 40 * scale;
      canvas.drawLine(Offset(offsetX, y), Offset(offsetX + 120 * scale, y), paint);
    }

    // Rahmen
    canvas.drawRect(
      Rect.fromLTWH(offsetX, offsetY, 120 * scale, 120 * scale),
      paint..style = PaintingStyle.stroke,
    );

    // Achsenbeschriftung
    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    for (int i = 0; i <= 120; i += 40) {
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(offsetX + i * scale, offsetY - 14));
      textPainter.paint(canvas, Offset(offsetX - 20, offsetY + i * scale));
    }

    // Punkt zeichnen, falls vorhanden
    if (point != null) {
      final pointPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      // Punkt skalieren und verschieben
      final x = offsetX + point!.dx * scale;
      final y = offsetY + point!.dy * scale;
      canvas.drawCircle(Offset(x, y), 6, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
