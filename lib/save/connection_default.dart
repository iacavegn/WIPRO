import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:math';
import 'dart:async';


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
  State<BluetoothScannerPage> createState() => _BluetoothScannerPageState();
}

class _BluetoothScannerPageState extends State<BluetoothScannerPage> {
  final List<ScanResult> _devices = [];
  bool _isScanning = false;
  Timer? _scanTimer;

  Color _bgColor = Colors.white; 

  Map<String, String> beacons = {
    "E9683774-D2D7-518F-B59B-C09555934BBB": "a",
    "137BDCDD-112B-09BC-7F96-5CB779877BCD": "b",
    "C9520664-CBB7-B552-375E-CE9A3C9BA773": "c",
    "FB68E05A-B028-7AC3-5B72-DC054EA9AB90": "d",
  };

  List<String> allowedIds = [];

  Map<String, int> rssi_at_1m = {
    "a": -65,
    "b": -65,
    "c": -65,
    "d": -70,
  };
  
  Map<String, int> distances = {
    "a,b": 2,
    "a,c": 1,
    "b,c": 1,
    "c,d": 2,
  };


  @override
  void initState() {
    super.initState();
    allowedIds = beacons.keys.toList();
    /*Timer.periodic(Duration(milliseconds: 1000), (_) async {
      await FlutterBluePlus.startScan(timeout: Duration(milliseconds: 1000));
    });*/
    _startScan();
   // _scanTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) => _startScan());
  }

  @override
  void dispose() {
   //_scanTimer?.cancel();
    _stopScan();
    super.dispose();
  }

  // Startet den Scan nur, wenn aktuell nicht gescannt wird
  void _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    await FlutterBluePlus.startScan(timeout: Duration(milliseconds: 1000));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _devices
          ..clear()
          ..addAll(results.where((r) => filter(r.device.id.toString())))
          ..sort((a, b) => -a.rssi.compareTo(b.rssi));
        _bgColor = getColor();
      });
    });

    FlutterBluePlus.isScanning.listen((scanning) {
      setState(() {
        _isScanning = scanning;
      });
    });
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
  }

  bool filter(String id) {
    
    return this.allowedIds.contains(id);
  }

  double distance(int rssi) {
    const int n = 2;
    const double txpower = -60;
    return pow(10, (txpower - rssi) / (10 * n)).toDouble();
  }

  String getPlace() {
    if (_devices.isEmpty && _devices.length < 4) return "";
    final firstId = _devices[0].device.id.id;
    final place = beacons[firstId];

    switch (place) {
      case "a": return "a";
      case "b": return "b";
      case "c": return "c";
      case "d": return "d";
      default: return "";
    }
  }

  Color getColor() {
    String place = getPlace();
    switch (place) {
      case "a": return Colors.red;
      case "b": return Colors.green;
      case "c": return Colors.blue;
      case "d": return Colors.purple;
      default: return _bgColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.stop : Icons.search),
            onPressed: _isScanning ? _stopScan : _startScan,
          )
        ],
      ),
      body: Column(
        children: [
          if (_isScanning) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index].device;
                final name = device.name.isNotEmpty ? device.name : 'Unbenannt';
                final id = device.id.id;
                final beacon_place = beacons[id];
                final rssi = _devices[index].rssi;
                final d = distance(rssi);
              
                return ListTile(
                  key: ValueKey(device.id),
                  title: Text(name),
                  subtitle: Text(
                      'Beacon: ${beacon_place} RSSI: $rssi  Distance: ${d.toStringAsFixed(2)}'),
                );
              },
            ),
            
          ),
        ],
      ),
    );
  }
}
