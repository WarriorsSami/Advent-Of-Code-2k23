import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  List<String> parseInput() {
    return input.getPerWhitespace();
  }

  @override
  int solvePart1() {
    final lines = parseInput();

    final seeds =
        lines[0].split(':')[1].trim().split(' ').map(int.parse).toList();

    final transitions = lines
        .sublist(1)
        .map(
          (line) => line
              .split(':')[1]
              .trim()
              .split(RegExp(r'\s|\n'))
              .slices(3)
              .map((slice) => slice.map(int.parse).toList())
              .toList(),
        )
        .map(
          (transition) => transition.map(
            (interval) {
              final [destStart, srcStart, step] = interval;
              return (
                src: (srcStart: srcStart, srcEnd: srcStart + step - 1),
                dest: (destStart: destStart, destEnd: destStart + step - 1),
              );
            },
          ).toList(),
        )
        .toList();

    return min(
          seeds.map(
            (seed) {
              var value = seed;
              for (final transition in transitions) {
                final match = transition.firstWhere(
                  (interval) =>
                      interval.src.srcStart <= value &&
                      value <= interval.src.srcEnd,
                  orElse: () => (
                    src: (srcStart: value, srcEnd: 0),
                    dest: (destStart: value, destEnd: 0),
                  ),
                );

                value = match.dest.destStart + (value - match.src.srcStart);
              }
              return value;
            },
          ).toList(),
        ) ??
        0;
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    final seeds = lines[0]
        .split(':')[1]
        .trim()
        .split(' ')
        .map(int.parse)
        .slices(2)
        .map(
          (slice) => (start: slice[0], end: slice[0] + slice[1] - 1),
        )
        .toList();

    final transitions = lines
        .sublist(1)
        .map(
          (line) => line
              .split(':')[1]
              .trim()
              .split(RegExp(r'\s|\n'))
              .slices(3)
              .map((slice) => slice.map(int.parse).toList())
              .toList(),
        )
        .map(
          (transition) => transition.map(
            (interval) {
              final [destStart, srcStart, step] = interval;
              return (
                src: (srcStart: srcStart, srcEnd: srcStart + step - 1),
                dest: (destStart: destStart, destEnd: destStart + step - 1),
              );
            },
          ).toList(),
        )
        .toList();

    var value = -1;
    var solutionFound = false;

    while (!solutionFound) {
      var seed = ++value;
      for (final transition in transitions.reversed) {
        final match = transition.firstWhere(
          (interval) =>
              interval.dest.destStart <= seed && seed <= interval.dest.destEnd,
          orElse: () => (
            src: (srcStart: seed, srcEnd: 0),
            dest: (destStart: seed, destEnd: 0),
          ),
        );

        seed = match.src.srcStart + (seed - match.dest.destStart);
      }

      solutionFound = seeds.any(
        (seedInterval) =>
            seedInterval.start <= seed && seed <= seedInterval.end,
      );
    }

    return value;
  }
}
