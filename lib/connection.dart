import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'data/beacons.dart';
import 'services/bluetooth_scan_service.dart';
import 'utils/beacon_utils.dart';
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
  final List<ScanResult> _devices = [];

  bool _isScanning = false;
  Color _bgColor = Colors.white;
  Timer? _timer;

  late final List<String> _allowedIds;

  @override
  void initState() {
    super.initState();
    _allowedIds = Beacons.getAllIds();

    _startScan();
    _timer = Timer.periodic(
      const Duration(milliseconds: 1100),
      (_) => _startScan(),
    );
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
          _devices
            ..clear()
            ..addAll(results);
          _bgColor = _getBackgroundColor();
        });
      },
    );
  }

  Color _getBackgroundColor() {
    if (_devices.isEmpty) return _bgColor;

    final id = _devices.first.device.id.id;
    final place = Beacons.getNameById(id);

    return Sections.sections[0].color ?? _bgColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon:
                Icon(_isScanning ? Icons.stop : Icons.search),
            onPressed:
                _isScanning ? _scanService.stopScan : _startScan,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isScanning) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (_, index) {
                final r = _devices[index];
                final name = r.device.name.isNotEmpty ? r.device.name : 'Unbenannt';
                final id = r.device.id.id;
                final place = Beacons.getNameById(id);
                final d =
                    BeaconUtils.calculateDistance(r.rssi);

                return ListTile(
                  title: Text(place != null ? place : 'Unbekannt'),
                  subtitle: Text(
                      'RSSI: ${r.rssi} | Distanz: ${d.toStringAsFixed(2)} - ${name}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
