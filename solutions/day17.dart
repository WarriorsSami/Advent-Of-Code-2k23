import 'dart:collection';

import '../utils/index.dart';

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    const minStep = 1;
    const maxStep = 3;

    final lines = parseInput()
        .map(
          (line) => line.split('').map(int.parse).toList(),
        )
        .toList();
    final gridField = Field<int>(lines);

    final distances = HashMap<NamedPositionWithDirection, int>();
    final queue =
        PriorityQueue<({NamedPositionWithDirection node, int distance})>(
      (a, b) => a.distance.compareTo(b.distance),
    )..add(
            (
              node: (
                position: (x: 0, y: 0),
                direction: Direction.none,
              ),
              distance: 0,
            ),
          );

    while (queue.isNotEmpty) {
      final (:distance, :node) = queue.removeFirst();

      if (node.position == (x: gridField.width - 1, y: gridField.height - 1)) {
        return distance;
      }

      if (distances.containsKey(node) && distance > distances[node]!) {
        continue;
      }

      for (final newDirection in Direction.validValues) {
        if (node.direction.getOpposite() == newDirection ||
            node.direction == newDirection) {
          continue;
        }

        final newDirectionCoords = newDirection.coordinates;
        var newDistance = distance;

        for (var step = 1; step <= maxStep; step++) {
          final newPosition = (
            x: node.position.x + step * newDirectionCoords.x,
            y: node.position.y + step * newDirectionCoords.y,
          );

          if (!gridField.isOnField((newPosition.x, newPosition.y))) {
            continue;
          }

          final newPositionWithDirection = (
            position: newPosition,
            direction: newDirection,
          );
          newDistance += gridField.getValueAt(
            newPosition.x,
            newPosition.y,
          );

          if (step < minStep) {
            continue;
          }

          if (distances.containsKey(newPositionWithDirection) &&
              newDistance >= distances[newPositionWithDirection]!) {
            continue;
          }

          distances[newPositionWithDirection] = newDistance;
          queue.add(
            (
              node: newPositionWithDirection,
              distance: newDistance,
            ),
          );
        }
      }
    }

    throw Exception('No path found');
  }

  @override
  int solvePart2() {
    const minStep = 4;
    const maxStep = 10;

    final lines = parseInput()
        .map(
          (line) => line.split('').map(int.parse).toList(),
        )
        .toList();
    final gridField = Field<int>(lines);

    final distances = HashMap<NamedPositionWithDirection, int>();
    final queue =
        PriorityQueue<({NamedPositionWithDirection node, int distance})>(
      (a, b) => a.distance.compareTo(b.distance),
    )..add(
            (
              node: (
                position: (x: 0, y: 0),
                direction: Direction.none,
              ),
              distance: 0,
            ),
          );

    while (queue.isNotEmpty) {
      final (:distance, :node) = queue.removeFirst();

      if (node.position == (x: gridField.width - 1, y: gridField.height - 1)) {
        return distance;
      }

      if (distances.containsKey(node) && distance > distances[node]!) {
        continue;
      }

      for (final newDirection in Direction.validValues) {
        if (node.direction.getOpposite() == newDirection ||
            node.direction == newDirection) {
          continue;
        }

        final newDirectionCoords = newDirection.coordinates;
        var newDistance = distance;

        for (var step = 1; step <= maxStep; step++) {
          final newPosition = (
            x: node.position.x + step * newDirectionCoords.x,
            y: node.position.y + step * newDirectionCoords.y,
          );

          if (!gridField.isOnField((newPosition.x, newPosition.y))) {
            continue;
          }

          final newPositionWithDirection = (
            position: newPosition,
            direction: newDirection,
          );
          newDistance += gridField.getValueAt(
            newPosition.x,
            newPosition.y,
          );

          if (step < minStep) {
            continue;
          }

          if (distances.containsKey(newPositionWithDirection) &&
              newDistance >= distances[newPositionWithDirection]!) {
            continue;
          }

          distances[newPositionWithDirection] = newDistance;
          queue.add(
            (
              node: newPositionWithDirection,
              distance: newDistance,
            ),
          );
        }
      }
    }

    throw Exception('No path found');
  }
}
