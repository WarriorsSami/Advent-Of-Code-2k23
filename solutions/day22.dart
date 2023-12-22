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
    // a brick is supported by another brick if it overlaps with it
    // and it is directly above/below it
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

    // This code block is responsible for determining the number of bricks that
    // do not have any other bricks directly above them
    // that are only supported by the current brick.
    return bricks.whereIndexed((index, element) {
      return overlapsAboveMap[index]!
          .where(
            (element) => overlapsBelowMap[element]!.length == 1,
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
    // while not disrupting the support structure using a chain reaction
    var count = 0;

    // Iterate over each brick
    for (var i = 0; i < bricks.length; i++) {
      // Create a set of bricks that are falling. Initially, it contains the
      // current brick and all bricks directly above it that are only supported
      // by the current brick
      final falling = <int>{i}..addAll(
          overlapsAboveMap[i]!.where(
            (j) => overlapsBelowMap[j]!.length == 1,
          ),
        );

      // Create a queue of bricks to check. Initially, it contains all bricks
      // directly above the current brick that are only supported by
      // the current brick
      final q = Queue<int>()
        ..addAll(
          overlapsAboveMap[i]!.where(
            (j) => overlapsBelowMap[j]!.length == 1,
          ),
        );

      // While there are still bricks to check
      while (q.isNotEmpty) {
        // Remove the first brick from the queue
        final j = q.removeFirst();

        // For each brick directly above the removed brick
        for (final k in overlapsAboveMap[j]!) {
          // If the brick is already in the falling set, skip it
          if (falling.contains(k)) {
            continue;
          }

          // If the brick is supported by any brick not in the falling set,
          // skip it
          if (!falling.containsAll(overlapsBelowMap[k]!)) {
            continue;
          }

          // Add the brick to the falling set and the queue
          falling.add(k);
          q.add(k);
        }
      }

      // Increase the counter by the number of bricks in the falling set minus
      // one (to exclude the current brick)
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
