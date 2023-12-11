import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = input.getPerLine().map((line) => line.split('')).toList();
    final universeField = Field<String>(lines);

    final emptyRowIndexes = List.generate(
      universeField.height,
      (index) => index,
    )
        .where(
          (index) => universeField.getRow(index).every(
                (element) => element == '.',
              ),
        )
        .toList();

    final emptyColumnIndexes = List.generate(
      universeField.width,
      (index) => index,
    )
        .where(
          (index) => universeField.getColumn(index).every(
                (element) => element == '.',
              ),
        )
        .toList();

    var rowOffset = 0;
    for (final index in emptyRowIndexes) {
      universeField.addRowAfter(
        index + rowOffset++,
        List.generate(universeField.width, (index) => '.'),
      );
    }

    var columnOffset = 0;
    for (final index in emptyColumnIndexes) {
      universeField.addColumnAfter(
        index + columnOffset++,
        List.generate(universeField.height, (index) => '.'),
      );
    }

    final galaxyPositions = universeField.positions
        .where((position) => universeField.getValueAtPosition(position) == '#')
        .toList();

    var sum = 0;
    for (var i = 0; i < galaxyPositions.length - 1; i++) {
      for (var j = i + 1; j < galaxyPositions.length; j++) {
        sum += universeField.manhattanDistance(
          galaxyPositions[i],
          galaxyPositions[j],
        );
      }
    }

    return sum;
  }

  @override
  int solvePart2() {
    const magnitude = 1000000;

    final lines = input.getPerLine().map((line) => line.split('')).toList();
    final universeField = Field<String>(lines);

    final emptyRowIndexes = List.generate(
      universeField.height,
      (index) => index,
    )
        .where(
          (index) => universeField.getRow(index).every(
                (element) => element == '.',
              ),
        )
        .toList();

    final emptyColumnIndexes = List.generate(
      universeField.width,
      (index) => index,
    )
        .where(
          (index) => universeField.getColumn(index).every(
                (element) => element == '.',
              ),
        )
        .toList();

    final galaxyPositions = universeField.positions
        .where((position) => universeField.getValueAtPosition(position) == '#')
        .map(
      (position) {
        final (x, y) = position;
        final (offsetX, offsetY) = (
          emptyColumnIndexes
                  .where(
                    (index) => index < x,
                  )
                  .length *
              (magnitude - 1),
          emptyRowIndexes
                  .where(
                    (index) => index < y,
                  )
                  .length *
              (magnitude - 1),
        );

        return (x + offsetX, y + offsetY);
      },
    ).toList();

    var sum = 0;
    for (var i = 0; i < galaxyPositions.length - 1; i++) {
      for (var j = i + 1; j < galaxyPositions.length; j++) {
        sum += universeField.manhattanDistance(
          galaxyPositions[i],
          galaxyPositions[j],
        );
      }
    }

    return sum;
  }
}
