import 'dart:collection';

import 'package:dartz/dartz.dart';

import '../utils/index.dart';
import '../utils/list_util.dart';

class Day20 extends GenericDay {
  Day20() : super(20);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final connectionsMap = Map<
        String,
        ({
          String type,
          List<String> destinations,
        })>.fromEntries(
      parseInput().map(
        (line) {
          final [type!, label!, destinationsPart!] = RegExp(
            r'(.)(\w+) -> (.+)',
          ).firstMatch(line)!.groups([1, 2, 3]);
          final destinations = destinationsPart.split(', ');

          return MapEntry(
            label,
            (
              type: type,
              destinations: destinations,
            ),
          );
        },
      ),
    );

    final flipFlopsSet = HashSet<String>();
    final conjunctionsMap = HashMap<String, HashMap<String, bool>>();

    for (final MapEntry(:key, :value) in connectionsMap.entries) {
      for (final label in value.destinations) {
        switch (connectionsMap[label]) {
          case final value?:
            {
              if (value.type == '&') {
                conjunctionsMap.putIfAbsent(label, HashMap<String, bool>.new);
                conjunctionsMap[label]![key] = false;
              }
            }
          case null:
            break;
        }
      }
    }

    var (high, low) = (0, 0);
    for (final step in List.generate(1000, (i) => i)) {
      final deque =
          DoubleLinkedQueue<({String node, String prev, bool pulse})>()
            ..addFirst(
              (
                node: 'roadcaster',
                prev: 'button',
                pulse: false,
              ),
            );

      while (deque.isNotEmpty) {
        final (:node, :prev, :pulse) = deque.removeFirst();

        switch (pulse) {
          case true:
            high++;
          case false:
            low++;
        }

        if (!connectionsMap.containsKey(node)) {
          continue;
        }

        final (:type, :destinations) = connectionsMap[node]!;

        var newPulse = pulse;
        switch (type) {
          case 'b':
            {
              newPulse = false;
            }
          case '%':
            {
              if (pulse) {
                continue;
              }

              final on = flipFlopsSet.contains(node);
              if (on) {
                flipFlopsSet.remove(node);
              } else {
                flipFlopsSet.add(node);
              }

              newPulse = !on;
            }
          case '&':
            {
              conjunctionsMap[node]![prev] = pulse;
              newPulse = !conjunctionsMap[node]!.values.every((e) => e);
            }
        }

        deque.addAll(
          destinations.map(
            (label) => (
              node: label,
              prev: node,
              pulse: newPulse,
            ),
          ),
        );
      }
    }

    return high * low;
  }

  @override
  int solvePart2() {
    final connectionsMap = Map<
        String,
        ({
          String type,
          List<String> destinations,
        })>.fromEntries(
      parseInput().map(
        (line) {
          final [type!, label!, destinationsPart!] = RegExp(
            r'(.)(\w+) -> (.+)',
          ).firstMatch(line)!.groups([1, 2, 3]);
          final destinations = destinationsPart.split(', ');

          return MapEntry(
            label,
            (
              type: type,
              destinations: destinations,
            ),
          );
        },
      ),
    );

    final flipFlopsSet = HashSet<String>();
    final conjunctionsMap = HashMap<String, HashMap<String, bool>>();

    for (final MapEntry(:key, :value) in connectionsMap.entries) {
      for (final label in value.destinations) {
        switch (connectionsMap[label]) {
          case final value?:
            {
              if (value.type == '&') {
                conjunctionsMap.putIfAbsent(label, HashMap<String, bool>.new);
                conjunctionsMap[label]![key] = false;
              }
            }
          case null:
            break;
        }
      }
    }

    final cycles = List.generate(4, (index) => none<int>());
    var t = 1;
    while (true) {
      final deque =
          DoubleLinkedQueue<({String node, String prev, bool pulse})>()
            ..addFirst(
              (
                node: 'roadcaster',
                prev: 'button',
                pulse: false,
              ),
            );

      while (deque.isNotEmpty) {
        final (:node, :prev, :pulse) = deque.removeFirst();
        if (pulse && node == 'cn') {
          final next = switch (prev) {
            'th' => 0,
            'sv' => 1,
            'gh' => 2,
            'ch' => 3,
            String() => throw Exception('Unexpected prev: $prev'),
          };

          cycles[next] = some(t);
        }

        if (!connectionsMap.containsKey(node)) {
          continue;
        }

        final (:type, :destinations) = connectionsMap[node]!;

        var newPulse = pulse;
        switch (type) {
          case 'b':
            {
              newPulse = false;
            }
          case '%':
            {
              if (pulse) {
                continue;
              }

              final on = flipFlopsSet.contains(node);
              if (on) {
                flipFlopsSet.remove(node);
              } else {
                flipFlopsSet.add(node);
              }

              newPulse = !on;
            }
          case '&':
            {
              conjunctionsMap[node]![prev] = pulse;
              newPulse = !conjunctionsMap[node]!.values.every((e) => e);
            }
        }

        deque.addAll(
          destinations.map(
            (label) => (
              node: label,
              prev: node,
              pulse: newPulse,
            ),
          ),
        );
      }

      if (cycles.every((e) => e.isSome())) {
        break;
      }

      t++;
    }

    return cycles
        .map(
          (element) => element.getOrElse(() => 1),
        )
        .reduce(lcm);
  }
}
