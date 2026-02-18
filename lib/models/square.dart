import 'dart:math';
import '/models/point3d.dart';

class Square {
    final Point startPointA;
    final Point endPointB;

    /// Create a square from two points (ignores z if Point3d)
    const Square(this.startPointA, this.endPointB);

    /// Check if a point is inside the square
    bool contains(Point point) {
        if (point.x < startPointA.x || point.x > endPointB.x) return false;
        if (point.y < startPointA.y || point.y > endPointB.y) return false;
        return true;
    }

    /// Check if a point3d is inside the square (ignores z)
    bool containsPoint3d(Point3d point3d) {
        return contains(Point(point3d.x, point3d.y));
    }

    @override
    String toString() => 'Square(Start: $startPointA, End: $endPointB)';

}