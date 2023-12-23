import 'dart:collection';

import '../utils/index.dart';

typedef Edge = ({NamedPosition neighbour, int weight});
typedef Graph = Map<NamedPosition, List<Edge>>;

class Day23 extends GenericDay {
  Day23() : super(23);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput().map((line) => line.split('')).toList();
    final gridField = Field<String>(lines);

    final startPosition = gridField.findFirstPosition('.');
    final endPosition = gridField.findLastPosition('.');
    final seen = <NamedPosition>{startPosition};

    return _dfsPart1(
      field: gridField,
      position: startPosition,
      endPosition: endPosition,
      seen: seen,
    );
  }

  @override
  int solvePart2() {
    final lines = parseInput().map((line) => line.split('')).toList();
    final gridField = Field<String>(lines);

    final startPosition = gridField.findFirstPosition('.');
    final endPosition = gridField.findLastPosition('.');
    final seen = <NamedPosition>{startPosition};

    final graph = Graph();
    for (final position in gridField.positions.map(
      (element) => (x: element.$1, y: element.$2),
    )) {
      final (:x, :y) = position;

      if (gridField.getValueAt(x, y) == '#') {
        continue;
      }

      final neighbours = gridField
          .adjacent(x, y)
          .map((element) => (x: element.$1, y: element.$2))
          .where(
            (element) =>
                gridField.getValueAtPosition((element.x, element.y)) != '#',
          )
          .toList();

      graph[position] = neighbours
          .map(
            (neighbour) => (
              neighbour: neighbour,
              weight: 1,
            ),
          )
          .toList();
    }

    // compress corridors aka edge pruning
    final corridors = graph.entries
        .where((element) => element.value.length == 2)
        .map((element) => element.key)
        .toList();

    for (final position in corridors) {
      final neighbours = graph.remove(position)!;
      final [neighbour1, neighbour2] = neighbours;

      final (position1, weight1) = (neighbour1.neighbour, neighbour1.weight);
      final (position2, weight2) = (neighbour2.neighbour, neighbour2.weight);

      final neighbours1 = graph[position1]!;
      if (neighbours1.any((element) => element.neighbour == position)) {
        graph[position1]!
          ..removeWhere((element) => element.neighbour == position)
          ..add(
            (
              neighbour: position2,
              weight: weight1 + weight2,
            ),
          );
      }

      final neighbours2 = graph[position2]!;
      if (neighbours2.any((element) => element.neighbour == position)) {
        graph[position2]!
          ..removeWhere((element) => element.neighbour == position)
          ..add(
            (
              neighbour: position1,
              weight: weight1 + weight2,
            ),
          );
      }
    }

    return _dfsPart2(
      field: gridField,
      position: startPosition,
      endPosition: endPosition,
      visited: seen,
      graph: graph,
    );
  }

  int _dfsPart1({
    required Field<String> field,
    required NamedPosition position,
    required NamedPosition endPosition,
    required Set<NamedPosition> seen,
  }) {
    if (position == endPosition) {
      return seen.length - 1;
    }

    final (:x, :y) = position;
    final neighbours = switch (field.getValueAt(x, y)) {
      '.' => field
          .adjacent(x, y)
          .map((element) => (x: element.$1, y: element.$2))
          .toList(),
      '>' => [(x: x + 1, y: y)]..removeWhere(
          (element) => !field.isOnField(
            (element.x, element.y),
          ),
        ),
      '<' => [(x: x - 1, y: y)]..removeWhere(
          (element) => !field.isOnField(
            (element.x, element.y),
          ),
        ),
      '^' => [(x: x, y: y - 1)]..removeWhere(
          (element) => !field.isOnField(
            (element.x, element.y),
          ),
        ),
      'v' => [(x: x, y: y + 1)]..removeWhere(
          (element) => !field.isOnField(
            (element.x, element.y),
          ),
        ),
      _ => <NamedPosition>[],
    };

    var longestPathLen = -1;
    for (final neighbour in neighbours) {
      if (seen.contains(neighbour) ||
          field.getValueAtPosition(
                (neighbour.x, neighbour.y),
              ) ==
              '#') {
        continue;
      }

      seen.add(neighbour);

      final result = _dfsPart1(
        field: field,
        position: neighbour,
        endPosition: endPosition,
        seen: seen,
      );
      longestPathLen = max([longestPathLen, result])!;

      seen.remove(neighbour);
    }

    return longestPathLen;
  }

  int _dfsPart2({
    required Field<String> field,
    required NamedPosition position,
    required NamedPosition endPosition,
    required Set<NamedPosition> visited,
    required Graph graph,
  }) {
    final stack = DoubleLinkedQueue<
        ({
          NamedPosition position,
          Set<NamedPosition> seen,
          int pathLen,
        })>()
      ..add(
        (
          position: position,
          seen: visited,
          pathLen: 0,
        ),
      );
    var longestPathLen = -1;

    while (stack.isNotEmpty) {
      final (:position, :seen, :pathLen) = stack.removeLast();

      if (position == endPosition) {
        longestPathLen = max([longestPathLen, pathLen])!;
        continue;
      }

      final neighbours = graph[position]!;

      for (final (:neighbour, :weight) in neighbours) {
        if (seen.contains(neighbour) ||
            field.getValueAtPosition(
                  (neighbour.x, neighbour.y),
                ) ==
                '#') {
          continue;
        }

        stack.add(
          (
            position: neighbour,
            seen: <NamedPosition>{...seen, neighbour},
            pathLen: pathLen + weight,
          ),
        );
      }
    }

    return longestPathLen;
  }
}
