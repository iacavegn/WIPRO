import 'beacon_measured.dart';

class Measurement {
    final List<BeaconMeasured> beacons;

    Measurement(
        this.beacons,
    );

    /// Add multiple beacons to the measurement
    void addBeacons(List<BeaconMeasured> newBeacons) {
        beacons.addAll(newBeacons);
    }

    @override
    String toString() => 'Measurement(beacons: ${beacons.map((b) => b.beacon.name).join(", ")})'; 
}