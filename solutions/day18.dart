import '../utils/index.dart';

class Day18 extends GenericDay {
  Day18() : super(18);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final steps = parseInput().map((line) {
      final groups = RegExp(r'(\w+) (\d+) \(#([a-z|0-9]+)\)').firstMatch(line);

      return (
        action: groups!.group(1)!,
        value: int.parse(groups!.group(2)!),
      );
    }).toList();

    final corners = <NamedPosition>[];
    corners
      ..add(
        steps.fold((x: 0, y: 0), (previousValue, step) {
          corners.add(previousValue);
          final (:x, :y) = previousValue;

          return switch (step.action) {
            'U' => (x: x, y: y - step.value),
            'D' => (x: x, y: y + step.value),
            'L' => (x: x - step.value, y: y),
            'R' => (x: x + step.value, y: y),
            _ => throw Exception('Unknown action ${step.action}'),
          };
        }),
      )
      ..removeLast();

    final borderVertices = steps.map((step) => step.value).sum;
    final area = corners.foldIndexed(
          0,
          (index, previous, element) =>
              previous +
              (element.x * corners[(index + 1) % corners.length].y -
                  corners[(index + 1) % corners.length].x * element.y),
        ) ~/
        2;

    final innerVertices = area - borderVertices ~/ 2 + 1;

    return borderVertices + innerVertices;
  }

  @override
  int solvePart2() {
    final steps = parseInput().map((line) {
      final groups = RegExp(r'(\w+) (\d+) \(#([a-z|0-9]+)\)').firstMatch(line);

      final hexEncodedStep = groups!.group(3)!;

      final value = int.parse(hexEncodedStep.substring(0, 5), radix: 16);
      final action = switch (hexEncodedStep.substring(5)) {
        '0' => 'R',
        '1' => 'D',
        '2' => 'L',
        '3' => 'U',
        _ => throw Exception('Unknown action ${hexEncodedStep.substring(6)}'),
      };

      return (
        action: action,
        value: value,
      );
    }).toList();

    final corners = <NamedPosition>[];
    corners
      ..add(
        steps.fold((x: 0, y: 0), (previousValue, step) {
          corners.add(previousValue);
          final (:x, :y) = previousValue;

          return switch (step.action) {
            'U' => (x: x, y: y - step.value),
            'D' => (x: x, y: y + step.value),
            'L' => (x: x - step.value, y: y),
            'R' => (x: x + step.value, y: y),
            _ => throw Exception('Unknown action ${step.action}'),
          };
        }),
      )
      ..removeLast();

    final borderVertices = steps.map((step) => step.value).sum;
    final area = corners.foldIndexed(
          0,
          (index, previous, element) =>
              previous +
              (element.x * corners[(index + 1) % corners.length].y -
                  corners[(index + 1) % corners.length].x * element.y),
        ) ~/
        2;

    final innerVertices = area - borderVertices ~/ 2 + 1;

    return borderVertices + innerVertices;
  }
}
