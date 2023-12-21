import 'dart:collection';

import '../utils/index.dart';

class Day21 extends GenericDay {
  Day21() : super(21);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput().map((e) => e.split('')).toList();
    final gardenField = Field<String>(lines);
    final startingPosition = gardenField.findFirstPosition('S');

    return _bfsPart1(
      gardenField: gardenField,
      startingPosition: startingPosition,
      steps: 64,
    );
  }

  @override
  int solvePart2() {
    final lines = parseInput().map((e) => e.split('')).toList();
    final gardenField = Field<String>(lines);
    final startingPosition = gardenField.findFirstPosition('S');

    const steps = 26501365;

    final (n1, n2, n3) = (
      _bfsPart2(
        gardenField: gardenField,
        startingPosition: startingPosition,
        steps: steps % gardenField.height + gardenField.height * 0,
      ),
      _bfsPart2(
        gardenField: gardenField,
        startingPosition: startingPosition,
        steps: steps % gardenField.height + gardenField.height * 1,
      ),
      _bfsPart2(
        gardenField: gardenField,
        startingPosition: startingPosition,
        steps: steps % gardenField.height + gardenField.height * 2,
      ),
    );

    // quadratic interpolation using 3 points
    final n = steps ~/ gardenField.height;
    final (a, b, c) = (
      (n1 - 2 * n2 + n3) ~/ 2,
      (-3 * n1 + 4 * n2 - n3) ~/ 2,
      n1,
    );

    return a * n * n + b * n + c;
  }

  int _bfsPart1({
    required Field<String> gardenField,
    required NamedPosition startingPosition,
    required int steps,
  }) {
    final distLines = List.generate(
      gardenField.height,
      (y) => List.generate(
        gardenField.width,
        (x) => switch (gardenField.getValueAt(x, y)) {
          'S' => 0,
          '#' => -2,
          _ => -1,
        },
      ),
    );
    final distField = Field<int>(distLines);

    final queue = Queue<({NamedPosition position, int distance})>()
      ..add(
        (
          position: startingPosition,
          distance: 0,
        ),
      );

    while (queue.isNotEmpty) {
      final (:position, :distance) = queue.removeFirst();

      for (final neighbor in gardenField
          .adjacent(
            position.x,
            position.y,
          )
          .map(
            (element) => (x: element.$1, y: element.$2),
          )) {
        if (distField.getValueAt(neighbor.x, neighbor.y) == -1) {
          distField.setValueAt(neighbor.x, neighbor.y, distance + 1);
          queue.add(
            (
              position: neighbor,
              distance: distance + 1,
            ),
          );
        }
      }
    }

    return 1 +
        distField.countPattern(
          (e) => e % 2 == steps % 2 && 0 < e && e <= steps,
        );
  }

  int _bfsPart2({
    required Field<String> gardenField,
    required NamedPosition startingPosition,
    required int steps,
  }) {
    final currentPositions = <NamedPosition>{startingPosition};
    final nextPositions = <NamedPosition>{};

    for (var i = 0; i < steps; i++) {
      for (final position in currentPositions) {
        for (final neighbor in gardenField
            .allAdjacent(
              position.x,
              position.y,
            )
            .map(
              (element) => (x: element.$1, y: element.$2),
            )) {
          final neighborInField = (
            x: neighbor.x % gardenField.width,
            y: neighbor.y % gardenField.height,
          );
          if (gardenField.getValueAt(
                neighborInField.x,
                neighborInField.y,
              ) !=
              '#') {
            nextPositions.add(neighbor);
          }
        }
      }

      currentPositions
        ..clear()
        ..addAll(nextPositions);
      nextPositions.clear();
    }

    return currentPositions.length;
  }
}
