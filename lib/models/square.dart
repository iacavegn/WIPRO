import 'dart:math';
import '/models/point3d.dart';

class Square {
    late double minX;
    late double maxX;
    late double minY;
    late double maxY;

    /// Create a square from two points (ignores z if Point3d)
    Square(Point pointA, Point pointB) {
        minX = min(pointA.x.toDouble(), pointB.x.toDouble());
        maxX = max(pointA.x.toDouble(), pointB.x.toDouble());
        minY = min(pointA.y.toDouble(), pointB.y.toDouble());
        maxY = max(pointA.y.toDouble(), pointB.y.toDouble());
    }

    /// Check if a point is inside the square
    bool contains(Point point) {
        return point.x >= minX &&
                point.x <= maxX &&
                point.y >= minY &&
                point.y <= maxY;
    }

    /// Check if a point3d is inside the square (ignores z)
    bool containsPoint3d(Point3d point3d) {
        return contains(Point(point3d.x, point3d.y));
    }
}