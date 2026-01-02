class Beacon {
  final String id;
  final String place;
  final int rssiAt1m;

  Beacon({
    required this.id,
    required this.place,
    required this.rssiAt1m,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['id'] as String,
      place: json['place'] as String,
      rssiAt1m: json['rssi_at_1m'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place,
      'rssi_at_1m': rssiAt1m,
    };
  }
}
