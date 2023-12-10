import 'dart:collection';

import '../utils/index.dart';

const validPipePositions = [
  (Direction.north, '|', 'S'),
  (Direction.north, '|', 'J'),
  (Direction.north, '|', 'L'),
  (Direction.north, '|', '|'),
  (Direction.north, '7', 'S'),
  (Direction.north, '7', 'J'),
  (Direction.north, '7', 'L'),
  (Direction.north, '7', '|'),
  (Direction.north, 'F', 'S'),
  (Direction.north, 'F', 'J'),
  (Direction.north, 'F', 'L'),
  (Direction.north, 'F', '|'),
  (Direction.east, '-', 'S'),
  (Direction.east, '-', 'L'),
  (Direction.east, '-', 'F'),
  (Direction.east, '-', '-'),
  (Direction.east, 'J', 'S'),
  (Direction.east, 'J', 'L'),
  (Direction.east, 'J', 'F'),
  (Direction.east, 'J', '-'),
  (Direction.east, '7', 'S'),
  (Direction.east, '7', 'L'),
  (Direction.east, '7', 'F'),
  (Direction.east, '7', '-'),
  (Direction.south, '|', 'S'),
  (Direction.south, '|', '7'),
  (Direction.south, '|', 'F'),
  (Direction.south, '|', '|'),
  (Direction.south, 'L', 'S'),
  (Direction.south, 'L', '7'),
  (Direction.south, 'L', 'F'),
  (Direction.south, 'L', '|'),
  (Direction.south, 'J', 'S'),
  (Direction.south, 'J', '7'),
  (Direction.south, 'J', 'F'),
  (Direction.south, 'J', '|'),
  (Direction.west, '-', 'S'),
  (Direction.west, '-', 'J'),
  (Direction.west, '-', '7'),
  (Direction.west, '-', '-'),
  (Direction.west, 'F', 'S'),
  (Direction.west, 'F', 'J'),
  (Direction.west, 'F', '7'),
  (Direction.west, 'F', '-'),
  (Direction.west, 'L', 'S'),
  (Direction.west, 'L', 'J'),
  (Direction.west, 'L', '7'),
  (Direction.west, 'L', '-'),
];

enum Color {
  black,
  white,
}

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = input.getPerLine().map((line) => line.split('')).toList();
    final sewageField = Field<String>(lines);

    final linesSteps = input
        .getPerLine()
        .map(
          (line) => line
              .split('')
              .map(
                (e) => switch (e) {
                  '.' => -2,
                  'S' => 0,
                  _ => -1,
                },
              )
              .toList(),
        )
        .toList();
    final stepsField = Field<int>(linesSteps);

    final start = sewageField.findFirstPosition('S');
    final queue = Queue<({({int x, int y}) position})>()
      ..add(
        (position: start,),
      );

    while (queue.isNotEmpty) {
      final (:position) = queue.removeFirst();
      final steps = stepsField.getValueAt(position.x, position.y);

      for (final ((x, y), direction) in sewageField.adjacentWithDirections(
        position.x,
        position.y,
      )) {
        if (stepsField.getValueAt(x, y) != -1) continue;

        final currentPosition = (
          direction,
          sewageField.getValueAt(x, y),
          sewageField.getValueAt(position.x, position.y),
        );
        if (!validPipePositions.contains(currentPosition)) continue;

        stepsField.setValueAt(x, y, steps + 1);
        queue.add(
          (
            position: (
              x: x,
              y: y,
            ),
          ),
        );
      }
    }

    return stepsField.maxValue;
  }

  @override
  int solvePart2() {
    final lines = input.getPerLine().map((line) => line.split('')).toList();
    final sewageField = Field<String>(lines);

    final linesSteps = input
        .getPerLine()
        .map(
          (line) => line
              .split('')
              .map(
                (e) => switch (e) {
                  '.' => -2,
                  'S' => 0,
                  _ => -1,
                },
              )
              .toList(),
        )
        .toList();
    final stepsField = Field<int>(linesSteps);

    final start = sewageField.findFirstPosition('S');
    final queue = Queue<({({int x, int y}) position})>()
      ..add(
        (position: start,),
      );

    while (queue.isNotEmpty) {
      final (:position) = queue.removeFirst();
      final steps = stepsField.getValueAt(position.x, position.y);

      for (final ((x, y), direction) in sewageField.adjacentWithDirections(
        position.x,
        position.y,
      )) {
        if (stepsField.getValueAt(x, y) != -1) continue;

        final currentPosition = (
          direction,
          sewageField.getValueAt(x, y),
          sewageField.getValueAt(position.x, position.y),
        );
        if (!validPipePositions.contains(currentPosition)) continue;

        stepsField.setValueAt(x, y, steps + 1);
        queue.add(
          (
            position: (
              x: x,
              y: y,
            ),
          ),
        );
      }
    }

    final (startX, endX) = (sewageField.width / 4, sewageField.width / 4 * 3);
    final (startY, endY) = (sewageField.height / 4, sewageField.height / 4 * 3);

    return stepsField.positions
        .where(
          (position) => stepsField.getValueAt(position.$1, position.$2) < 0,
        )
        .map(
          (position) => (
            x: position.$1,
            y: position.$2,
          ),
        )
        .where(
          (position) =>
              position.x >= startX &&
              position.x <= endX &&
              position.y >= startY &&
              position.y <= endY,
        )
        .length;
  }
}
