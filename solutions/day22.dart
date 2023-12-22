import 'dart:collection';

import '../utils/index.dart';

typedef Brick = ({
  int x1,
  int y1,
  int z1,
  int x2,
  int y2,
  int z2,
});

class Day22 extends GenericDay {
  Day22() : super(22);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final bricks = parseInput().map((line) {
      final regex = RegExp(
        r'(?<x1>\d+),(?<y1>\d+),(?<z1>\d+)~(?<x2>\d+),(?<y2>\d+),(?<z2>\d+)',
      );

      final match = regex.firstMatch(line);

      return (
        x1: int.parse(match!.namedGroup('x1')!),
        y1: int.parse(match!.namedGroup('y1')!),
        z1: int.parse(match!.namedGroup('z1')!),
        x2: int.parse(match!.namedGroup('x2')!),
        y2: int.parse(match!.namedGroup('y2')!),
        z2: int.parse(match!.namedGroup('z2')!),
      );
    }).toList()
      ..sort(
        (a, b) => a.z1.compareTo(b.z1),
      );

    // simulate the bricks falling by normalizing the z-axis
    for (var i = 0; i < bricks.length; i++) {
      var maxZ = 1;
      for (var j = 0; j < i; j++) {
        if (_isOverlapping(bricks[i], bricks[j])) {
          maxZ = _max(maxZ, bricks[j].z2 + 1);
        }
      }

      bricks[i] = (
        x1: bricks[i].x1,
        y1: bricks[i].y1,
        z1: maxZ,
        x2: bricks[i].x2,
        y2: bricks[i].y2,
        z2: maxZ + bricks[i].z2 - bricks[i].z1,
      );
    }

    bricks.sort(
      (a, b) => a.z1.compareTo(b.z1),
    );

    // construct the support graph
    final overlapsAboveMap = <int, Set<int>>{};
    final overlapsBelowMap = <int, Set<int>>{};

    for (var i = 0; i < bricks.length; i++) {
      overlapsAboveMap[i] = {};
      overlapsBelowMap[i] = {};

      for (var j = 0; j < i; j++) {
        if (_isOverlapping(bricks[i], bricks[j]) &&
            bricks[i].z1 == bricks[j].z2 + 1) {
          overlapsAboveMap[j]!.add(i);
          overlapsBelowMap[i]!.add(j);
        }
      }
    }

    // count the number of bricks which can be easily removed
    // while not disrupting the support structure
    // var count = 0;
    // for (var i = 0; i < bricks.length; i++) {
    //   final falling = <int>{i}..addAll(
    //       overlapsAboveMap[i]!.where(
    //         (j) => overlapsBelowMap[j]!.length == 1,
    //       ),
    //     );
    //   final q = Queue<int>()
    //     ..addAll(
    //       overlapsAboveMap[i]!.where(
    //         (j) => overlapsBelowMap[j]!.length == 1,
    //       ),
    //     );
    //
    //   while (q.isNotEmpty) {
    //     final j = q.removeFirst();
    //     for (final k in overlapsAboveMap[j]!) {
    //       if (falling.contains(k)) {
    //         continue;
    //       }
    //
    //       falling.add(k);
    //       q.add(k);
    //     }
    //   }
    //
    //   count += falling.length - 1;
    // }

    return bricks.whereIndexed((index, element) {
      return overlapsAboveMap[index]!
          .where(
            (element) => overlapsBelowMap[element]!.length < 2,
          )
          .isEmpty;
    }).length;
  }

  @override
  int solvePart2() {
    final bricks = parseInput().map((line) {
      final regex = RegExp(
        r'(?<x1>\d+),(?<y1>\d+),(?<z1>\d+)~(?<x2>\d+),(?<y2>\d+),(?<z2>\d+)',
      );

      final match = regex.firstMatch(line);

      return (
        x1: int.parse(match!.namedGroup('x1')!),
        y1: int.parse(match!.namedGroup('y1')!),
        z1: int.parse(match!.namedGroup('z1')!),
        x2: int.parse(match!.namedGroup('x2')!),
        y2: int.parse(match!.namedGroup('y2')!),
        z2: int.parse(match!.namedGroup('z2')!),
      );
    }).toList()
      ..sort(
        (a, b) => a.z1.compareTo(b.z1),
      );

    // simulate the bricks falling by normalizing the z-axis
    for (var i = 0; i < bricks.length; i++) {
      var maxZ = 1;
      for (var j = 0; j < i; j++) {
        if (_isOverlapping(bricks[i], bricks[j])) {
          maxZ = _max(maxZ, bricks[j].z2 + 1);
        }
      }

      bricks[i] = (
        x1: bricks[i].x1,
        y1: bricks[i].y1,
        z1: maxZ,
        x2: bricks[i].x2,
        y2: bricks[i].y2,
        z2: maxZ + bricks[i].z2 - bricks[i].z1,
      );
    }

    bricks.sort(
      (a, b) => a.z1.compareTo(b.z1),
    );

    // construct the support graph
    final overlapsAboveMap = <int, Set<int>>{};
    final overlapsBelowMap = <int, Set<int>>{};

    for (var i = 0; i < bricks.length; i++) {
      overlapsAboveMap[i] = {};
      overlapsBelowMap[i] = {};

      for (var j = 0; j < i; j++) {
        if (_isOverlapping(bricks[i], bricks[j]) &&
            bricks[i].z1 == bricks[j].z2 + 1) {
          overlapsAboveMap[j]!.add(i);
          overlapsBelowMap[i]!.add(j);
        }
      }
    }

    // count the number of bricks which can be easily removed
    // while not disrupting the support structure
    var count = 0;
    for (var i = 0; i < bricks.length; i++) {
      final falling = <int>{i}..addAll(
          overlapsAboveMap[i]!.where(
            (j) => overlapsBelowMap[j]!.length == 1,
          ),
        );
      final q = Queue<int>()
        ..addAll(
          overlapsAboveMap[i]!.where(
            (j) => overlapsBelowMap[j]!.length == 1,
          ),
        );

      while (q.isNotEmpty) {
        final j = q.removeFirst();
        for (final k in overlapsAboveMap[j]!) {
          if (falling.contains(k)) {
            continue;
          }

          if (!falling.containsAll(overlapsBelowMap[k]!)) {
            continue;
          }

          falling.add(k);
          q.add(k);
        }
      }

      count += falling.length - 1;
    }

    return count;
  }

  bool _isOverlapping(Brick a, Brick b) {
    return _max(a.x1, b.x1) <= _min(a.x2, b.x2) &&
        _max(a.y1, b.y1) <= _min(a.y2, b.y2);
  }

  int _max(int a, int b) {
    return a > b ? a : b;
  }

  int _min(int a, int b) {
    return a < b ? a : b;
  }
}
