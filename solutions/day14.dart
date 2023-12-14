import 'dart:collection';

import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput().map((e) => e.split('')).toList();
    final rockField = Field<String>(lines);

    final dpLines = List.generate(
      lines.length,
      (_) => List.generate(
        lines[0].length,
        (_) => 0,
      ),
    );
    // dp[i][j] = no of square rocks on the column j below the row i including
    final dpField = Field<int>(dpLines);

    for (var y = rockField.height - 1; y >= 0; y--) {
      for (var x = 0; x < rockField.width; x++) {
        if (rockField.getValueAt(x, y) != '#') {
          dpField.setValueAt(
            x,
            y,
            y == rockField.height - 1 ? 0 : dpField.getValueAt(x, y + 1),
          );
          continue;
        }

        dpField.setValueAt(
          x,
          y,
          y == rockField.height - 1 ? 1 : 1 + dpField.getValueAt(x, y + 1),
        );
      }
    }

    var ans = 0;
    for (var y = 0; y < rockField.height; y++) {
      for (var x = 0; x < rockField.width; x++) {
        if (rockField.getValueAt(x, y) != 'O') {
          continue;
        }

        // find the first empty spot above with dp[i][x] == dp[y][x]
        final i = List.generate(
          y,
          (index) => index,
        ).firstWhere(
          (i) =>
              dpField.getValueAt(x, i) == dpField.getValueAt(x, y) &&
              rockField.getValueAt(x, i) == '.',
          orElse: () => y,
        );

        if (i != y) {
          rockField
            ..setValueAt(x, y, '.')
            ..setValueAt(x, i, 'O');
        }

        ans += rockField.height - i;
      }
    }

    return ans;
  }

  @override
  int solvePart2() {
    const noCycles = 1000000000;

    final lines = parseInput().map((e) => e.split('')).toList();
    final rockField = Field<String>(lines);

    final dpLines = List.generate(
      lines.length,
      (_) => List.generate(
        lines[0].length,
        (_) => 0,
      ),
    );

    // dp[i][j] = no of square rocks on the column j below the row i including
    final dpFieldNorth = Field<int>(dpLines);

    for (var y = rockField.height - 1; y >= 0; y--) {
      for (var x = 0; x < rockField.width; x++) {
        if (rockField.getValueAt(x, y) != '#') {
          dpFieldNorth.setValueAt(
            x,
            y,
            y == rockField.height - 1 ? 0 : dpFieldNorth.getValueAt(x, y + 1),
          );
          continue;
        }

        dpFieldNorth.setValueAt(
          x,
          y,
          y == rockField.height - 1 ? 1 : 1 + dpFieldNorth.getValueAt(x, y + 1),
        );
      }
    }

    // dp[i][j] = no of square rocks on the row i to the right of column j including
    final dpFieldEast = Field<int>(dpLines);

    for (var x = rockField.width - 1; x >= 0; x--) {
      for (var y = 0; y < rockField.height; y++) {
        if (rockField.getValueAt(x, y) != '#') {
          dpFieldEast.setValueAt(
            x,
            y,
            x == rockField.width - 1 ? 0 : dpFieldEast.getValueAt(x + 1, y),
          );
          continue;
        }

        dpFieldEast.setValueAt(
          x,
          y,
          x == rockField.width - 1 ? 1 : 1 + dpFieldEast.getValueAt(x + 1, y),
        );
      }
    }

    // dp[i][j] = no of square rocks on the column j above the row i including
    final dpFieldSouth = Field<int>(dpLines);

    for (var y = 0; y < rockField.height; y++) {
      for (var x = 0; x < rockField.width; x++) {
        if (rockField.getValueAt(x, y) != '#') {
          dpFieldSouth.setValueAt(
            x,
            y,
            y == 0 ? 0 : dpFieldSouth.getValueAt(x, y - 1),
          );
          continue;
        }

        dpFieldSouth.setValueAt(
          x,
          y,
          y == 0 ? 1 : 1 + dpFieldSouth.getValueAt(x, y - 1),
        );
      }
    }

    // dp[i][j] = no of square rocks on the row i to the left of column j including
    final dpFieldWest = Field<int>(dpLines);

    for (var x = 0; x < rockField.width; x++) {
      for (var y = 0; y < rockField.height; y++) {
        if (rockField.getValueAt(x, y) != '#') {
          dpFieldWest.setValueAt(
            x,
            y,
            x == 0 ? 0 : dpFieldWest.getValueAt(x - 1, y),
          );
          continue;
        }

        dpFieldWest.setValueAt(
          x,
          y,
          x == 0 ? 1 : 1 + dpFieldWest.getValueAt(x - 1, y),
        );
      }
    }

    final dpFields = [
      (dpField: dpFieldNorth, dir: Direction.north),
      (dpField: dpFieldWest, dir: Direction.west),
      (dpField: dpFieldSouth, dir: Direction.south),
      (dpField: dpFieldEast, dir: Direction.east),
    ];

    // find the cycle
    final seen = HashMap<String, int>();

    for (var i = 1; i <= noCycles; i++) {
      for (var dir = 0; dir < 4; dir++) {
        _roll(rockField, dpFields[dir]);
      }

      final rockFieldString = rockField.toString();
      if (seen.containsKey(rockFieldString)) {
        if ((noCycles - i) % (i - seen[rockFieldString]!) == 0) {
          break;
        }
      }
      seen[rockFieldString] = i;
    }

    var ans = 0;
    for (var y = 0; y < rockField.height; y++) {
      for (var x = 0; x < rockField.width; x++) {
        if (rockField.getValueAt(x, y) != 'O') {
          continue;
        }

        ans += rockField.height - y;
      }
    }

    return ans;
  }

  void _roll(
    Field<String> rockField,
    ({Field<int> dpField, Direction dir}) dp,
  ) {
    final (:dpField, :dir) = dp;

    for (var y = 0; y < rockField.height; y++) {
      for (var x = 0; x < rockField.width; x++) {
        if (rockField.getValueAt(x, y) != 'O') {
          continue;
        }

        switch (dir) {
          case Direction.north:
            {
              final i = List.generate(
                y,
                (index) => index,
              ).firstWhere(
                (i) =>
                    dpField.getValueAt(x, i) == dpField.getValueAt(x, y) &&
                    rockField.getValueAt(x, i) == '.',
                orElse: () => y,
              );

              if (i != y) {
                rockField
                  ..setValueAt(x, y, '.')
                  ..setValueAt(x, i, 'O');
              }
              break;
            }

          case Direction.west:
            {
              final i = List.generate(
                x,
                (index) => index,
              ).firstWhere(
                (i) =>
                    dpField.getValueAt(i, y) == dpField.getValueAt(x, y) &&
                    rockField.getValueAt(i, y) == '.',
                orElse: () => x,
              );

              if (i != x) {
                rockField
                  ..setValueAt(x, y, '.')
                  ..setValueAt(i, y, 'O');
              }
              break;
            }

          case Direction.south:
            {
              final i = List.generate(
                rockField.height - y,
                (index) => index,
              ).firstWhere(
                (i) =>
                    dpField.getValueAt(x, rockField.height - i - 1) ==
                        dpField.getValueAt(x, y) &&
                    rockField.getValueAt(x, rockField.height - i - 1) == '.',
                orElse: () => rockField.height - y - 1,
              );

              if (i != rockField.height - y - 1) {
                rockField
                  ..setValueAt(x, y, '.')
                  ..setValueAt(x, rockField.height - i - 1, 'O');
              }
              break;
            }

          case Direction.east:
            {
              final i = List.generate(
                rockField.width - x,
                (index) => index,
              ).firstWhere(
                (i) =>
                    dpField.getValueAt(rockField.width - i - 1, y) ==
                        dpField.getValueAt(x, y) &&
                    rockField.getValueAt(rockField.width - i - 1, y) == '.',
                orElse: () => rockField.width - x - 1,
              );

              if (i != rockField.width - x - 1) {
                rockField
                  ..setValueAt(x, y, '.')
                  ..setValueAt(rockField.width - i - 1, y, 'O');
              }
              break;
            }

          case Direction.none:
            {
              print('Direction.none is not allowed');
              break;
            }
        }
      }
    }
  }
}
