import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'data/beacons.dart';
import 'services/bluetooth_scan_service.dart';
import 'data/sections.dart';
import 'models/beacon.dart';
import 'models/beacon_measured.dart';
import 'models/measurement.dart';

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
        if (_setOfMeasurements.length >= 10) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: Text(
          'Scanne nach Beacons...\nGefundene Messungen: ${_setOfMeasurements.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
