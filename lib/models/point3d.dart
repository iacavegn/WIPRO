import 'dart:math';

class Point3d {
    final double x;
    final double y;
    final double z;

    const Point3d(
        this.x,
        this.y,
        this.z,
    );

    double distanceTo(Point3d other) {
        final dx = x - other.x;
        final dy = y - other.y;
        final dz = z - other.z;
        return sqrt(dx * dx + dy * dy + dz * dz);
    }

    @override
    String toString() => 'Point3d(x: $x, y: $y, z: $z)';
}