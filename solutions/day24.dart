import 'package:dartz/dartz.dart';
import 'package:z3/z3.dart';

import '../utils/index.dart';

typedef MovingPoint = ({
  double x,
  double y,
  double z,
  double vx,
  double vy,
  double vz,
});

class Day24 extends GenericDay {
  Day24() : super(24);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    const collisionLowerBound = 200000000000000.0;
    const collisionUpperBound = 400000000000000.0;

    final movingPoints = parseInput()
        .where(
      (line) => line.isNotEmpty,
    )
        .map((line) {
      final regex = RegExp(
        r'(?<x>-?\d+),\s+(?<y>-?\d+),\s+(?<z>-?\d+)\s+@\s+(?<vx>-?\d+),\s+(?<vy>-?\d+),\s+(?<vz>-?\d+)',
      );
      final match = regex.firstMatch(line)!;

      return (
        x: double.parse(match.namedGroup('x')!),
        y: double.parse(match.namedGroup('y')!),
        z: double.parse(match.namedGroup('z')!),
        vx: double.parse(match.namedGroup('vx')!),
        vy: double.parse(match.namedGroup('vy')!),
        vz: double.parse(match.namedGroup('vz')!),
      );
    }).toList();

    final pointsPairs = List.generate(
      movingPoints.length,
      (i) => List.generate(
        i,
        (j) => (i, j),
      ),
    )
        .expand((element) => element)
        .map(
          (pair) => (
            first: pair.$1,
            second: pair.$2,
          ),
        )
        .toList();

    return pointsPairs
        .map((pair) {
          final (a, b) = (movingPoints[pair.first], movingPoints[pair.second]);

          final result = _getFutureIntersection(
            a: a,
            b: b,
          )
              .map(
                (intersection) => (
                  x: intersection.x,
                  y: intersection.y,
                ),
              )
              .getOrElse(() => (x: double.infinity, y: double.infinity));

          final futureIntersectionCondition =
              a.vx.sign == (result.x - a.x).sign &&
                  b.vx.sign == (result.x - b.x).sign &&
                  a.vy.sign == (result.y - a.y).sign &&
                  b.vy.sign == (result.y - b.y).sign &&
                  result != (x: double.infinity, y: double.infinity);

          return switch (futureIntersectionCondition) {
            true => some(result),
            false => none<({double x, double y})>(),
          };
        })
        .where((option) => option.isSome())
        .map(
          (option) => option.getOrElse(
            () => (x: double.infinity, y: double.infinity),
          ),
        )
        .where(
          (intersection) =>
              intersection.x >= collisionLowerBound &&
              intersection.x <= collisionUpperBound &&
              intersection.y >= collisionLowerBound &&
              intersection.y <= collisionUpperBound &&
              intersection != (x: double.infinity, y: double.infinity),
        )
        .length;
  }

  @override
  int solvePart2() {
    final movingPoints = parseInput()
        .where(
      (line) => line.isNotEmpty,
    )
        .map((line) {
      final regex = RegExp(
        r'(?<x>-?\d+),\s+(?<y>-?\d+),\s+(?<z>-?\d+)\s+@\s+(?<vx>-?\d+),\s+(?<vy>-?\d+),\s+(?<vz>-?\d+)',
      );
      final match = regex.firstMatch(line)!;

      return (
        x: double.parse(match.namedGroup('x')!),
        y: double.parse(match.namedGroup('y')!),
        z: double.parse(match.namedGroup('z')!),
        vx: double.parse(match.namedGroup('vx')!),
        vy: double.parse(match.namedGroup('vy')!),
        vz: double.parse(match.namedGroup('vz')!),
      );
    }).toList();

    final s = solver();
    final (fx, fy, fz) = (
      constVar('fx', intSort),
      constVar('fy', intSort),
      constVar('fz', intSort),
    );
    final (fvx, fvy, fvz) = (
      constVar('fvx', intSort),
      constVar('fvy', intSort),
      constVar('fvz', intSort),
    );

    final zero = IntNumeral.from(0);
    for (var i = 0; i < movingPoints.length; i++) {
      final (:x, :y, :z, :vx, :vy, :vz) = movingPoints[i];
      final (x1, y1, z1) = (
        IntNumeral.from(x.toInt()),
        IntNumeral.from(y.toInt()),
        IntNumeral.from(z.toInt()),
      );
      final (vx1, vy1, vz1) = (
        IntNumeral.from(vx.toInt()),
        IntNumeral.from(vy.toInt()),
        IntNumeral.from(vz.toInt()),
      );
      final t = constVar('t$i', intSort);

      s
        ..add(t >= zero)
        ..add((fx + fvx * t).eq(t * vx1 + x1))
        ..add((fy + fvy * t).eq(t * vy1 + y1))
        ..add((fz + fvz * t).eq(t * vz1 + z1));
    }

    s.ensureSat();
    final model = s.getModel();

    return model.eval(fx + fy + fz);
  }

  Option<({double x, double y})> _getFutureIntersection({
    required MovingPoint a,
    required MovingPoint b,
  }) {
    final (x1, y1) = (a.x, a.y);
    final (x2, y2) = (a.x + a.vx, a.y + a.vy);

    final (x3, y3) = (b.x, b.y);
    final (x4, y4) = (b.x + b.vx, b.y + b.vy);

    final nominatorX =
        (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4);
    final nominatorY =
        (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4);
    final denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    return switch (denominator) {
      0 => none(),
      _ => some(
          (
            x: nominatorX / denominator,
            y: nominatorY / denominator,
          ),
        ),
    };
  }
}
