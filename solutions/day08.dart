import 'dart:collection';

import '../utils/index.dart';
import '../utils/list_util.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    final directions = lines[0].split('');

    final map = HashMap.fromEntries(
      lines.sublist(2).map(
        (nodeLine) {
          final parts = nodeLine.split(' = ');
          final node = parts[0];
          final [left, right] =
              RegExp(r'\((\w+), (\w+)\)').firstMatch(parts[1])!.groups([1, 2]);
          return MapEntry(
            node,
            (left: left!, right: right!),
          );
        },
      ),
    );

    final dirCircularIter = directions.toCircularIterator();
    var steps = 0;
    var node = 'AAA';
    while (node != 'ZZZ') {
      final dir = dirCircularIter.current;
      final (:left, :right) = map[node]!;
      node = dir == 'L' ? left : right;

      steps++;
      dirCircularIter.moveNext();
    }

    return steps;
  }

  @override
  int solvePart2() {
    final lines = parseInput();
    final directions = lines[0].split('');

    final map = HashMap.fromEntries(
      lines.sublist(2).map(
        (nodeLine) {
          final parts = nodeLine.split(' = ');
          final node = parts[0];
          final [left, right] =
              RegExp(r'\((\w+), (\w+)\)').firstMatch(parts[1])!.groups([1, 2]);
          return MapEntry(
            node,
            (left: left!, right: right!),
          );
        },
      ),
    );

    final dirCircularIter = directions.toCircularIterator();
    final nodes =
        map.keys.where((node) => node[node.length - 1] == 'A').toList();
    final steps = HashMap.fromEntries(
      nodes.map(
        (node) => MapEntry(node, 0),
      ),
    );

    while (nodes.any((node) => node[node.length - 1] != 'Z')) {
      for (final node in nodes) {
        if (node[node.length - 1] == 'Z') {
          continue;
        }

        final dir = dirCircularIter.current;
        final (:left, :right) = map[node]!;
        final nextNode = dir == 'L' ? left : right;

        steps[nextNode] = steps[node]! + 1;
        steps.remove(node);
        nodes[nodes.indexOf(node)] = nextNode;
      }

      dirCircularIter.moveNext();
    }

    return steps.entries
        .reduce(
          (value, element) => MapEntry(
            value.key,
            _lcm(value.value, element.value),
          ),
        )
        .value;
  }

  int _lcm(int a, int b) => (a * b) ~/ a.gcd(b);
}
