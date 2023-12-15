import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  String parseInput() {
    return input.asString;
  }

  @override
  int solvePart1() {
    return parseInput().split(RegExp(r'[,|\n]')).map(
      (step) {
        return step.split('').map((c) => c.codeUnitAt(0)).fold(
              0,
              (previousValue, code) => (previousValue + code) * 17 % 256,
            );
      },
    ).sum;
  }

  @override
  int solvePart2() {
    final boxes = List.generate(256, (index) => <String, int>{});

    for (final step in parseInput().split(RegExp(r'[,|\n]'))) {
      switch ((step.contains('='), step.contains('-'))) {
        case (true, false):
          {
            final [key, value] = step.split('=');
            boxes[_hash(key)][key] = int.parse(value);
            break;
          }
        case (false, true):
          {
            final [key, _] = step.split('-');
            boxes[_hash(key)].remove(key);
            break;
          }
        default:
          {
            break;
          }
      }
    }

    return boxes.mapIndexed(
      (boxIndex, box) {
        return switch (box.isEmpty) {
          true => 0,
          false => box.values
              .mapIndexed(
                (lensIndex, value) => (boxIndex + 1) * (lensIndex + 1) * value,
              )
              .sum,
        };
      },
    ).sum;
  }

  int _hash(String input) {
    return input.split('').map((c) => c.codeUnitAt(0)).fold(
          0,
          (previousValue, code) => (previousValue + code) * 17 % 256,
        );
  }
}
