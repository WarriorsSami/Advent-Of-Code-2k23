import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  List<String> parseInput() {
    return input.getPerWhitespace();
  }

  @override
  int solvePart1() {
    return parseInput().map((grid) {
      final lines = grid
          .split('\n')
          .map(
            (line) => line.split(''),
          )
          .where((line) => line.isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        return (verticalSplitIndex: 0, horizontalSplitIndex: 0);
      }

      final mirrorField = Field<String>(lines);

      var verticalSplitIndex = -1;
      for (var i = 0; i < mirrorField.width - 1; i++) {
        var isMirror = true;
        for (var p1 = i, p2 = i + 1;
            p1 >= 0 && p2 < mirrorField.width;
            p1--, p2++) {
          if (mirrorField.getColumn(p1).join() !=
              mirrorField.getColumn(p2).join()) {
            isMirror = false;
            break;
          }
        }

        if (isMirror) {
          verticalSplitIndex = i;
          break;
        }
      }

      var horizontalSplitIndex = -1;
      for (var i = 0; i < mirrorField.height - 1; i++) {
        var isMirror = true;
        for (var p1 = i, p2 = i + 1;
            p1 >= 0 && p2 < mirrorField.height;
            p1--, p2++) {
          if (mirrorField.getRow(p1).join() != mirrorField.getRow(p2).join()) {
            isMirror = false;
            break;
          }
        }

        if (isMirror) {
          horizontalSplitIndex = i;
          break;
        }
      }

      return (
        verticalSplitIndex: verticalSplitIndex + 1,
        horizontalSplitIndex: horizontalSplitIndex + 1,
      );
    }).fold(
      0,
      (acc, curr) =>
          acc + curr.verticalSplitIndex + curr.horizontalSplitIndex * 100,
    );
  }

  @override
  int solvePart2() {
    return parseInput().map((grid) {
      final lines = grid
          .split('\n')
          .map(
            (line) => line.split(''),
          )
          .where((line) => line.isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        return (verticalSplitIndex: 0, horizontalSplitIndex: 0);
      }

      final mirrorField = Field<String>(lines);

      var verticalSplitIndex = -1;
      for (var i = 0; i < mirrorField.width - 1; i++) {
        var isMirror = true;
        var hasDiffByOne = false;
        for (var p1 = i, p2 = i + 1;
            p1 >= 0 && p2 < mirrorField.width;
            p1--, p2++) {
          if (mirrorField.getColumn(p1).join() !=
              mirrorField.getColumn(p2).join()) {
            final columnDiff = mirrorField.columnDifference(p1, p2);

            if (columnDiff > 1) {
              isMirror = false;
              break;
            }

            if (columnDiff == 1) {
              if (hasDiffByOne) {
                isMirror = false;
                break;
              }
              hasDiffByOne = true;
            }
          }
        }

        if (isMirror && hasDiffByOne) {
          verticalSplitIndex = i;
          break;
        }
      }

      var horizontalSplitIndex = -1;
      for (var i = 0; i < mirrorField.height - 1; i++) {
        var isMirror = true;
        var hasDiffByOne = false;
        for (var p1 = i, p2 = i + 1;
            p1 >= 0 && p2 < mirrorField.height;
            p1--, p2++) {
          if (mirrorField.getRow(p1).join() != mirrorField.getRow(p2).join()) {
            final rowDiff = mirrorField.rowDifference(p1, p2);

            if (rowDiff > 1) {
              isMirror = false;
              break;
            }

            if (rowDiff == 1) {
              if (hasDiffByOne) {
                isMirror = false;
                break;
              }
              hasDiffByOne = true;
            }
          }
        }

        if (isMirror && hasDiffByOne) {
          horizontalSplitIndex = i;
          break;
        }
      }

      return (
        verticalSplitIndex: verticalSplitIndex + 1,
        horizontalSplitIndex: horizontalSplitIndex + 1,
      );
    }).fold(
      0,
      (acc, curr) =>
          acc + curr.verticalSplitIndex + curr.horizontalSplitIndex * 100,
    );
  }
}
