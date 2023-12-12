import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    return parseInput().map(
      (line) {
        var [pattern, partGroups] = line.split(' ');
        final groups = partGroups.split(',').map(int.parse).toList();

        // add a dot at the end to avoid special cases
        pattern = '$pattern.';
        final (n, g, l) = (pattern.length, groups.length, pattern.length);
        // dp[i][j][k] = number of ways to split the first i characters into j
        // groups with k characters in the last group
        final dp = List.generate(
          n + 1,
          (_) => List.generate(
            g + 2,
            (_) => List.generate(
              l + 2,
              (_) => 0,
            ),
          ),
        );

        dp[0][0][0] = 1;
        for (var i = 0; i < n; i++) {
          for (var j = 0; j < g + 1; j++) {
            for (var k = 0; k < l + 1; k++) {
              if (dp[i][j][k] == 0) continue;

              // continue the current group or start a new one
              if (pattern[i] == '#' || pattern[i] == '?') {
                dp[i + 1][j + (k == 0 ? 1 : 0)][k + 1] += dp[i][j][k];
              }

              // end the current group or continue without one
              if (pattern[i] == '.' || pattern[i] == '?') {
                if (k == 0 || k == groups[j - 1]) {
                  dp[i + 1][j][0] += dp[i][j][k];
                }
              }
            }
          }
        }

        return dp[n][g][0];
      },
    ).sum;
  }

  @override
  int solvePart2() {
    return parseInput().map(
      (line) {
        var [pattern, partGroups] = line.split(' ');
        pattern = List.generate(5, (_) => pattern).join('?');
        partGroups = List.generate(5, (_) => partGroups).join(',');
        final groups = partGroups.split(',').map(int.parse).toList();

        // add a dot at the end to avoid special cases
        pattern = '$pattern.';
        final (n, g, l) = (pattern.length, groups.length, pattern.length);
        // dp[i][j][k] = number of ways to split the first i characters into j
        // groups with k characters in the last group
        final dp = List.generate(
          n + 1,
          (_) => List.generate(
            g + 2,
            (_) => List.generate(
              l + 2,
              (_) => 0,
            ),
          ),
        );

        dp[0][0][0] = 1;
        for (var i = 0; i < n; i++) {
          for (var j = 0; j < g + 1; j++) {
            for (var k = 0; k < l + 1; k++) {
              if (dp[i][j][k] == 0) continue;

              // continue the current group or start a new one
              if (pattern[i] == '#' || pattern[i] == '?') {
                dp[i + 1][j + (k == 0 ? 1 : 0)][k + 1] += dp[i][j][k];
              }

              // end the current group or continue without one
              if (pattern[i] == '.' || pattern[i] == '?') {
                if (k == 0 || k == groups[j - 1]) {
                  dp[i + 1][j][0] += dp[i][j][k];
                }
              }
            }
          }
        }

        return dp[n][g][0];
      },
    ).sum;
  }
}
