<!-- .github/copilot-instructions.md - guidance for AI coding agents -->
# Copilot instructions — bookstore_flutter

Purpose: make AI agents productive quickly in this Flutter BLE demo app.

- **Big picture:** This is a small Flutter app that scans Bluetooth beacons and changes the UI background by section. Core pieces:
  - `lib/main.dart` — app entry, shows `MainPage` which navigates into the scanner.
  - `lib/connection.dart` — `BackgroundPage` and `BluetoothScannerPage` UI; ties services, models and data together.
  - `lib/services/bluetooth_scan_service.dart` — encapsulates continuous BLE scanning using `flutter_blue_plus` streams.
  - `lib/models/*` — `Beacon`, `BeaconMeasured` (distance calc), `Section` models.
  - `lib/data/*` — JSON-backed lists (ids, areas, distances) and helper lookups.

- **Why code is structured this way:** scanning is separated into a service that produces streams of `ScanResult`. UI subscribes to filtered results and maps them to domain models (`BeaconMeasured`) using static helpers. This keeps BLE concerns isolated in `services/` and domain logic in `models/`.

- **Key conventions / patterns to follow**
  - Services expose start/stop semantics and use subscriptions (see `BluetoothScanService`): always cancel subscriptions and set `_disposed` before stopping.
  - Filtering of beacons is done by string id lists provided by `lib/data/beacons.dart` (use `Beacons.getAllIds()` / `Beacons.getById(id)`).
  - Distance is computed in `BeaconMeasured.calculateDistance(rssi, txPower)`; other code expects `BeaconMeasured.distance` to be precomputed at construction.
  - UI mutates state inside `setState()` and expects the service to emit frequent updates (short scan timeout + short pause in the service).

- **Important files to inspect when changing behavior**
  - `lib/services/bluetooth_scan_service.dart` — change scanning behavior, timeouts, or filtering here.
  - `lib/connection.dart` — glue between scanning and UI; contains logic to pick section color: `Sections.getSection(_beacons)`.
  - `lib/models/beacon_measured.dart` and `lib/models/beacon.dart` — domain modeling and distance calculation.
  - `pubspec.yaml` — assets and `flutter_blue_plus` dependency; assets: `assets/beacons.json`, `assets/areas.json`, `assets/distances.json`.

- **Build / run / debug notes (project-specific)**
  - Install packages: `flutter pub get`.
  - Run on a real device for BLE scanning (iOS Simulator does not support BLE; Android emulators often don't provide real BLE). Example:

```bash
flutter pub get
flutter run -d <device-id>
```

  - To run tests: `flutter test` (project has a `test/widget_test.dart` placeholder).
  - If changing native iOS/Android BLE permissions, update `ios/Runner/Info.plist` and Android `AndroidManifest.xml` in the platform folders.

- **External integrations**
  - BLE via `flutter_blue_plus` (check `pubspec.yaml`). Changes to scanning APIs must consider the subscription-based design used in `BluetoothScanService`.
  - Static data loaded from JSON assets in `lib/data/*` — any ID/name changes must be reflected across `assets/*.json` and `lib/data` helpers.

- **Common small tasks with examples**
  - Add a new beacon: update `assets/beacons.json` and `lib/data/beacons.dart` mapping. Use `Beacons.getById(...)` where needed.
  - Change scanning cadence: edit `timeout` and `pauseBetweenScans` defaults in `BluetoothScanService.startScan()`.
  - Fix background color logic: inspect `BluetoothScannerPage._getBackgroundColor()` in `lib/connection.dart`.

- **Safety and quick checks for PRs**
  - Ensure BLE subscriptions are cancelled when widgets are disposed (compare to `dispose()` in `BluetoothScannerPage`).
  - Verify asset keys after editing `assets/*.json` by running the app and checking `Beacons.getAllIds()` results.
  - When editing platform code, document required permission changes in the PR description.

If anything here is unclear or you'd like short expansions (for example: how `Sections.getSection` chooses a color, or where assets are parsed), tell me which area to expand. 
