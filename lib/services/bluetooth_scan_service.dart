import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScanService {
  StreamSubscription? _resultSub;
  StreamSubscription? _scanStateSub;

  void startScan({
    required void Function(List<ScanResult>) onResults,
    required void Function(bool) onScanningChanged,
    required bool Function(String id) filter,
  }) async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(milliseconds: 1000),
    );

    _resultSub = FlutterBluePlus.scanResults.listen((results) {
      final filtered = results
          .where((r) => filter(r.device.id.toString()))
          .toList()
        ..sort((a, b) => -a.rssi.compareTo(b.rssi));

      onResults(filtered);
    });

    _scanStateSub =
        FlutterBluePlus.isScanning.listen(onScanningChanged);
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    _resultSub?.cancel();
    _scanStateSub?.cancel();
  }
}
