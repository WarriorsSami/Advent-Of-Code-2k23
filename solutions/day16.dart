import 'dart:collection';

import '../utils/index.dart';

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput().map((line) => line.split('')).toList();
    final lightField = Field<String>(lines);

    final stack = Queue<NamedPositionWithDirection>();
    final seen = List.generate(
      lightField.height,
      (_) => List.filled(lightField.width, 0),
    );

    stack.addLast(
      (direction: Direction.east, position: (x: 0, y: 0)),
    );

    while (stack.isNotEmpty) {
      final current = stack.removeLast();

      if (_getSeenForDirection(
            current.direction,
            seen[current.position.y][current.position.x],
          ) !=
          0) {
        continue;
      }

      seen[current.position.y][current.position.x] = _applyDirection(
        current.direction,
        seen[current.position.y][current.position.x],
      );

      final device =
          lightField.getValueAt(current.position.x, current.position.y);

      final nextPositions = switch ((current.direction, device)) {
        // pointy side of a splitter
        (Direction.east, '-') => [
            (
              position: (x: current.position.x + 1, y: current.position.y),
              direction: Direction.east,
            ),
          ],
        (Direction.west, '-') => [
            (
              position: (x: current.position.x - 1, y: current.position.y),
              direction: Direction.west,
            ),
          ],
        (Direction.north, '|') => [
            (
              position: (x: current.position.x, y: current.position.y - 1),
              direction: Direction.north,
            ),
          ],
        (Direction.south, '|') => [
            (
              position: (x: current.position.x, y: current.position.y + 1),
              direction: Direction.south,
            ),
          ],
        // flat side of a splitter
        (Direction.east, '|') => [
            (
              position: (x: current.position.x, y: current.position.y - 1),
              direction: Direction.north,
            ),
            (
              position: (x: current.position.x, y: current.position.y + 1),
              direction: Direction.south,
            ),
          ],
        (Direction.west, '|') => [
            (
              position: (x: current.position.x, y: current.position.y - 1),
              direction: Direction.north,
            ),
            (
              position: (x: current.position.x, y: current.position.y + 1),
              direction: Direction.south,
            ),
          ],
        (Direction.north, '-') => [
            (
              position: (x: current.position.x + 1, y: current.position.y),
              direction: Direction.east,
            ),
            (
              position: (x: current.position.x - 1, y: current.position.y),
              direction: Direction.west
            ),
          ],
        (Direction.south, '-') => [
            (
              position: (x: current.position.x + 1, y: current.position.y),
              direction: Direction.east,
            ),
            (
              position: (x: current.position.x - 1, y: current.position.y),
              direction: Direction.west,
            ),
          ],
        // mirrors
        (Direction.east, '/') => [
            (
              position: (x: current.position.x, y: current.position.y - 1),
              direction: Direction.north,
            ),
          ],
        (Direction.west, '/') => [
            (
              position: (x: current.position.x, y: current.position.y + 1),
              direction: Direction.south,
            ),
          ],
        (Direction.north, '/') => [
            (
              position: (x: current.position.x + 1, y: current.position.y),
              direction: Direction.east,
            ),
          ],
        (Direction.south, '/') => [
            (
              position: (x: current.position.x - 1, y: current.position.y),
              direction: Direction.west,
            ),
          ],
        (Direction.east, r'\') => [
            (
              position: (x: current.position.x, y: current.position.y + 1),
              direction: Direction.south,
            ),
          ],
        (Direction.west, r'\') => [
            (
              position: (x: current.position.x, y: current.position.y - 1),
              direction: Direction.north,
            ),
          ],
        (Direction.north, r'\') => [
            (
              position: (x: current.position.x - 1, y: current.position.y),
              direction: Direction.west,
            ),
          ],
        (Direction.south, r'\') => [
            (
              position: (x: current.position.x + 1, y: current.position.y),
              direction: Direction.east,
            ),
          ],
        (_, '.') => switch (current.direction) {
            Direction.east => [
                (
                  position: (x: current.position.x + 1, y: current.position.y),
                  direction: Direction.east,
                ),
              ],
            Direction.west => [
                (
                  position: (x: current.position.x - 1, y: current.position.y),
                  direction: Direction.west,
                ),
              ],
            Direction.north => [
                (
                  position: (x: current.position.x, y: current.position.y - 1),
                  direction: Direction.north,
                ),
              ],
            Direction.south => [
                (
                  position: (x: current.position.x, y: current.position.y + 1),
                  direction: Direction.south,
                ),
              ],
            Direction.none => <NamedPositionWithDirection>[],
          },
        _ => <NamedPositionWithDirection>[],
      }
        ..removeWhere(
          (cell) =>
              lightField.isOnField((cell.position.x, cell.position.y)) == false,
        );

      stack.addAll(nextPositions);
    }

    return seen.expand((row) => row).where((e) => e != 0).length;
  }

  @override
  int solvePart2() {
    final lines = parseInput().map((line) => line.split('')).toList();
    final lightField = Field<String>(lines);

    final beamStartingPositions = <NamedPositionWithDirection>[
      ...List.generate(
        lightField.width,
        (x) => (
          direction: Direction.south,
          position: (x: x, y: 0),
        ),
      ),
      ...List.generate(
        lightField.width,
        (x) => (
          direction: Direction.north,
          position: (x: x, y: lightField.height - 1),
        ),
      ),
      ...List.generate(
        lightField.height,
        (y) => (
          direction: Direction.east,
          position: (x: 0, y: y),
        ),
      ),
      ...List.generate(
        lightField.height,
        (y) => (
          direction: Direction.west,
          position: (x: lightField.width - 1, y: y),
        ),
      ),
    ];

    return max(
      beamStartingPositions.map(
        (pos) {
          final stack = Queue<NamedPositionWithDirection>();
          final seen = List.generate(
            lightField.height,
            (_) => List.filled(lightField.width, 0),
          );

          stack.addLast(
            pos,
          );

          while (stack.isNotEmpty) {
            final current = stack.removeLast();

            if (_getSeenForDirection(
                  current.direction,
                  seen[current.position.y][current.position.x],
                ) !=
                0) {
              continue;
            }

            seen[current.position.y][current.position.x] = _applyDirection(
              current.direction,
              seen[current.position.y][current.position.x],
            );

            final device =
                lightField.getValueAt(current.position.x, current.position.y);

            final nextPositions = switch ((current.direction, device)) {
              // pointy side of a splitter
              (Direction.east, '-') => [
                  (
                    position: (
                      x: current.position.x + 1,
                      y: current.position.y
                    ),
                    direction: Direction.east,
                  ),
                ],
              (Direction.west, '-') => [
                  (
                    position: (
                      x: current.position.x - 1,
                      y: current.position.y
                    ),
                    direction: Direction.west,
                  ),
                ],
              (Direction.north, '|') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y - 1
                    ),
                    direction: Direction.north,
                  ),
                ],
              (Direction.south, '|') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y + 1
                    ),
                    direction: Direction.south,
                  ),
                ],
              // flat side of a splitter
              (Direction.east, '|') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y - 1
                    ),
                    direction: Direction.north,
                  ),
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y + 1
                    ),
                    direction: Direction.south,
                  ),
                ],
              (Direction.west, '|') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y - 1
                    ),
                    direction: Direction.north,
                  ),
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y + 1
                    ),
                    direction: Direction.south,
                  ),
                ],
              (Direction.north, '-') => [
                  (
                    position: (
                      x: current.position.x + 1,
                      y: current.position.y
                    ),
                    direction: Direction.east,
                  ),
                  (
                    position: (
                      x: current.position.x - 1,
                      y: current.position.y
                    ),
                    direction: Direction.west
                  ),
                ],
              (Direction.south, '-') => [
                  (
                    position: (
                      x: current.position.x + 1,
                      y: current.position.y
                    ),
                    direction: Direction.east,
                  ),
                  (
                    position: (
                      x: current.position.x - 1,
                      y: current.position.y
                    ),
                    direction: Direction.west,
                  ),
                ],
              // mirrors
              (Direction.east, '/') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y - 1
                    ),
                    direction: Direction.north,
                  ),
                ],
              (Direction.west, '/') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y + 1
                    ),
                    direction: Direction.south,
                  ),
                ],
              (Direction.north, '/') => [
                  (
                    position: (
                      x: current.position.x + 1,
                      y: current.position.y
                    ),
                    direction: Direction.east,
                  ),
                ],
              (Direction.south, '/') => [
                  (
                    position: (
                      x: current.position.x - 1,
                      y: current.position.y
                    ),
                    direction: Direction.west,
                  ),
                ],
              (Direction.east, r'\') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y + 1
                    ),
                    direction: Direction.south,
                  ),
                ],
              (Direction.west, r'\') => [
                  (
                    position: (
                      x: current.position.x,
                      y: current.position.y - 1
                    ),
                    direction: Direction.north,
                  ),
                ],
              (Direction.north, r'\') => [
                  (
                    position: (
                      x: current.position.x - 1,
                      y: current.position.y
                    ),
                    direction: Direction.west,
                  ),
                ],
              (Direction.south, r'\') => [
                  (
                    position: (
                      x: current.position.x + 1,
                      y: current.position.y
                    ),
                    direction: Direction.east,
                  ),
                ],
              (_, '.') => switch (current.direction) {
                  Direction.east => [
                      (
                        position: (
                          x: current.position.x + 1,
                          y: current.position.y
                        ),
                        direction: Direction.east,
                      ),
                    ],
                  Direction.west => [
                      (
                        position: (
                          x: current.position.x - 1,
                          y: current.position.y
                        ),
                        direction: Direction.west,
                      ),
                    ],
                  Direction.north => [
                      (
                        position: (
                          x: current.position.x,
                          y: current.position.y - 1
                        ),
                        direction: Direction.north,
                      ),
                    ],
                  Direction.south => [
                      (
                        position: (
                          x: current.position.x,
                          y: current.position.y + 1
                        ),
                        direction: Direction.south,
                      ),
                    ],
                  Direction.none => <NamedPositionWithDirection>[],
                },
              _ => <NamedPositionWithDirection>[],
            }
              ..removeWhere(
                (cell) =>
                    lightField.isOnField((cell.position.x, cell.position.y)) ==
                    false,
              );

            stack.addAll(nextPositions);
          }

          return seen.expand((row) => row).where((e) => e != 0).length;
        },
      ),
    )!;
  }

  int _applyDirection(Direction direction, int oldMask) {
    switch (direction) {
      case Direction.north:
        return oldMask | (1 << 3);
      case Direction.east:
        return oldMask | (1 << 2);
      case Direction.south:
        return oldMask | (1 << 1);
      case Direction.west:
        return oldMask | (1 << 0);
      case Direction.none:
        return oldMask;
    }
  }

  int _getSeenForDirection(Direction direction, int mask) {
    switch (direction) {
      case Direction.north:
        return (mask >> 3) & 1;
      case Direction.east:
        return (mask >> 2) & 1;
      case Direction.south:
        return (mask >> 1) & 1;
      case Direction.west:
        return (mask >> 0) & 1;
      case Direction.none:
        return 0;
    }
  }
}
