import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'data/beacons.dart';
import 'services/bluetooth_scan_service.dart';
import 'data/sections.dart';
import 'models/beacon.dart';
import 'models/beacon_measured.dart';

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
  final List<BeaconMeasured> _beacons = [];

  bool _isScanning = false;
  Color _bgColor = Colors.white;
  Timer? _timer;

  late final List<String> _allowedIds;

  @override
  void initState() {
    super.initState();
    _allowedIds = Beacons.getAllIds();

    _startScan();
    /*_timer = Timer.periodic(
      const Duration(milliseconds: 4000),
      (_) => _startScan(),
    );*/
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scanService.stopScan();
    super.dispose();
  }

  void _startScan() {
    if (_isScanning) return;

    _scanService.startScan(
      filter: (id) => _allowedIds.contains(id),
      onScanningChanged: (scanning) {
        setState(() => _isScanning = scanning);
      },
      onResults: (results) {
        setState(() {
          _beacons
            ..clear()
            ..addAll(
              results.map((b) => BeaconMeasured(Beacons.getById(b.device.id.id)!, b.rssi)),
            );
          _bgColor = _getBackgroundColor();
        });
      },
    );
  }

  Color _getBackgroundColor() {
    if (_beacons.isEmpty) return _bgColor;
    if (_beacons.length < Beacons.beacons.length) {
      return _bgColor;
    } else {
      return Sections.sections[1].color ?? _bgColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _beacons.length,
              itemBuilder: (_, index) {
                final b = _beacons[index];
                final beacon = b.beacon;
                final name = beacon.name;
                final id = beacon.id;
                final place = beacon.name;
                final d = b.distance;
                final rssi = b.rssi;

                return ListTile(
                  title: Text(place),
                  subtitle: Text(
                      'RSSI: ${rssi} | Distanz: ${d.toStringAsFixed(2)} - ${name}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
