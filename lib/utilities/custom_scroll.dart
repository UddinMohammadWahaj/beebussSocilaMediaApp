import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class CustomSimulation extends Simulation {
  final double initPosition;
  final double velocity;

  CustomSimulation({required this.initPosition, required this.velocity});

  @override
  double x(double time) {
    var max =
        math.max(math.min(initPosition, 0.0), initPosition + velocity * time);

    // print(max.toString());

    return max;
  }

  @override
  double dx(double time) {
    // print(velocity.toString());
    return velocity;
  }

  @override
  bool isDone(double time) {
    return false;
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics();
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return CustomSimulation(
      initPosition: position.pixels,
      velocity: velocity,
    );
  }
}
