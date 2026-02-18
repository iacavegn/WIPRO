import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScanService {
  StreamSubscription<List<ScanResult>>? _resultSub;
  StreamSubscription<bool>? _scanStateSub;

  bool _isScanning = false;
  bool _disposed = false;

  /// Startet den Scan kontinuierlich
  void startScan({
    required void Function(List<ScanResult>) onResults,
    required void Function(bool) onScanningChanged,
    required bool Function(String id) filter,
    Duration timeout = const Duration(seconds: 1),
    Duration pauseBetweenScans = const Duration(seconds: 1),
  }) async {
    _disposed = false;

    // Ergebnis-Stream abonnieren
    _resultSub = FlutterBluePlus.scanResults.listen((results) {
      if (_disposed) return;
      final filtered = results
          .where((r) => filter(r.device.id.toString()))
          .toList()
        ..sort((a, b) => -a.rssi.compareTo(b.rssi));
      onResults(filtered);
    });

    // Scan-State-Stream abonnieren
    _scanStateSub = FlutterBluePlus.isScanning.listen((scanning) {
      if (_disposed) return;
      _isScanning = scanning;
      onScanningChanged(scanning);
    });

    // Endlosschleife für kontinuierliches Scannen
    while (!_disposed) {
      try {
        print("Scan gestartet");
        await FlutterBluePlus.startScan(timeout: timeout);
      } catch (e) {
        print("Scan-Fehler: $e");
      }

      // Kurze Pause zwischen den Scans
      await Future.delayed(pauseBetweenScans);
    }
  }

  /// Stoppt den Scan und stream subscriptions
  void stopScan() {
    _disposed = true;
    FlutterBluePlus.stopScan();
    _resultSub?.cancel();
    _scanStateSub?.cancel();
  }
}
