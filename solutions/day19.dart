import 'dart:collection';

import 'package:dartz/dartz.dart';

import '../utils/index.dart';

enum Rating {
  x,
  m,
  a,
  s;

  static Rating fromString(String rating) {
    switch (rating) {
      case 'x':
        return Rating.x;
      case 'm':
        return Rating.m;
      case 'a':
        return Rating.a;
      case 's':
        return Rating.s;
      default:
        throw Exception('Invalid rating: $rating');
    }
  }
}

enum Status {
  A,
  R;

  static Status fromString(String status) {
    switch (status) {
      case 'A':
        return Status.A;
      case 'R':
        return Status.R;
      default:
        throw Exception('Invalid status: $status');
    }
  }
}

enum Operator {
  greaterThan,
  lessThan;

  static Operator fromString(String op) {
    switch (op) {
      case '>':
        return Operator.greaterThan;
      case '<':
        return Operator.lessThan;
      default:
        throw Exception('Invalid operator: $op');
    }
  }
}

typedef Destination = Either<Status, String>;

typedef Rule = ({
  Rating rating,
  Operator op,
  int value,
  Destination dest,
});

class Day19 extends GenericDay {
  Day19() : super(19);

  @override
  List<String> parseInput() {
    return input.getPerWhitespace();
  }

  @override
  int solvePart1() {
    final [workflowsPart, ratingsPart] = parseInput();

    final workflowRegex = RegExp(r'(?<label>\w+){(?<rules>.+)}');
    final ruleRegex = RegExp(
      r'(?<rating>\w+)(?<operator>[><]+)(?<value>\d+):(?<destination>\w+)',
    );
    final ratingRegex = RegExp(
      r'{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}',
    );

    final workflowMap =
        Map<String, List<Either<Destination, Rule>>>.fromEntries(
      workflowsPart.split('\n').map((workflow) {
        final match = workflowRegex.firstMatch(workflow);

        final label = match!.namedGroup('label');
        final rules = match!.namedGroup('rules')!.split(',').map((rule) {
          if (!rule.contains(':')) {
            return left<Destination, Rule>(
              rule.length == 1 ? left(Status.fromString(rule)) : right(rule),
            );
          }

          final match = ruleRegex.firstMatch(rule);

          final rating = match!.namedGroup('rating');
          final operator = match!.namedGroup('operator');
          final value = int.parse(match!.namedGroup('value')!);
          final destination = match!.namedGroup('destination');

          return right<Destination, Rule>(
            (
              rating: Rating.fromString(rating!),
              op: Operator.fromString(operator!),
              value: value,
              dest: destination!.length == 1
                  ? left(Status.fromString(destination))
                  : right(destination),
            ),
          );
        }).toList();

        return MapEntry(label!, rules);
      }),
    );

    final ratings = ratingsPart
        .split('\n')
        .where(
          (line) => line.isNotEmpty,
        )
        .map((rating) {
      final match = ratingRegex.firstMatch(rating);

      final x = int.parse(match!.namedGroup('x')!);
      final m = int.parse(match!.namedGroup('m')!);
      final a = int.parse(match!.namedGroup('a')!);
      final s = int.parse(match!.namedGroup('s')!);

      return (x: x, m: m, a: a, s: s);
    }).toList();

    return ratings
        .map((rating) {
          var currentWorkflow = 'in';
          var status = none<Status>();

          while (status.isNone()) {
            final currentRules = workflowMap[currentWorkflow]!;

            currentRules
                .map(some)
                .firstWhere(
                  (rule) => rule.fold(
                    () => false,
                    (rule) => rule.fold(
                      (dest) {
                        return dest.fold(
                          (innerStatus) {
                            status = some(innerStatus);
                            return false;
                          },
                          (workflow) {
                            currentWorkflow = workflow;
                            return false;
                          },
                        );
                      },
                      (rule) => _compareRatingAgainstRule(
                        rating: rating,
                        rule: rule,
                      ),
                    ),
                  ),
                  orElse: none,
                )
                .fold(
                  () {},
                  (rule) => rule.fold(
                    (dest) {},
                    (rule) => rule.dest.fold(
                      (innerStatus) {
                        status = some(innerStatus);
                      },
                      (workflow) {
                        currentWorkflow = workflow;
                      },
                    ),
                  ),
                );
          }

          return (
            x: rating.x,
            m: rating.m,
            a: rating.a,
            s: rating.s,
            status: status.getOrElse(() => Status.R),
          );
        })
        .where((rating) => rating.status == Status.A)
        .map((rating) => rating.x + rating.m + rating.a + rating.s)
        .sum;
  }

  @override
  int solvePart2() {
    final [workflowsPart, ratingsPart] = parseInput();

    final workflowRegex = RegExp(r'(?<label>\w+){(?<rules>.+)}');
    final ruleRegex = RegExp(
      r'(?<rating>\w+)(?<operator>[><]+)(?<value>\d+):(?<destination>\w+)',
    );

    final workflowMap =
        Map<String, List<Either<Destination, Rule>>>.fromEntries(
      workflowsPart.split('\n').map((workflow) {
        final match = workflowRegex.firstMatch(workflow);

        final label = match!.namedGroup('label');
        final rules = match!.namedGroup('rules')!.split(',').map((rule) {
          if (!rule.contains(':')) {
            return left<Destination, Rule>(
              rule.length == 1 ? left(Status.fromString(rule)) : right(rule),
            );
          }

          final match = ruleRegex.firstMatch(rule);

          final rating = match!.namedGroup('rating');
          final operator = match!.namedGroup('operator');
          final value = int.parse(match!.namedGroup('value')!);
          final destination = match!.namedGroup('destination');

          return right<Destination, Rule>(
            (
              rating: Rating.fromString(rating!),
              op: Operator.fromString(operator!),
              value: value,
              dest: destination!.length == 1
                  ? left(Status.fromString(destination))
                  : right(destination),
            ),
          );
        }).toList();

        return MapEntry(label!, rules);
      }),
    );

    return _countAccepted(
      workflowMap: workflowMap,
      current: right('in'),
      ranges: HashMap.fromIterables(
        Rating.values,
        Rating.values.map(
          (_) => List.generate(4000, (i) => i + 1),
        ),
      ),
    );
  }

  bool _compareRatingAgainstRule({
    required ({int x, int m, int a, int s}) rating,
    required Rule rule,
  }) {
    return switch (rule.rating) {
      Rating.x => switch (rule.op) {
          Operator.greaterThan => rating.x > rule.value,
          Operator.lessThan => rating.x < rule.value,
        },
      Rating.m => switch (rule.op) {
          Operator.greaterThan => rating.m > rule.value,
          Operator.lessThan => rating.m < rule.value,
        },
      Rating.a => switch (rule.op) {
          Operator.greaterThan => rating.a > rule.value,
          Operator.lessThan => rating.a < rule.value,
        },
      Rating.s => switch (rule.op) {
          Operator.greaterThan => rating.s > rule.value,
          Operator.lessThan => rating.s < rule.value,
        },
    };
  }

  bool _compareValueAgainstRule({
    required int value,
    required Rule rule,
  }) {
    return switch (rule.op) {
      Operator.greaterThan => value > rule.value,
      Operator.lessThan => value < rule.value,
    };
  }

  int _countAccepted({
    required Map<String, List<Either<Destination, Rule>>> workflowMap,
    required Destination current,
    required HashMap<Rating, List<int>> ranges,
  }) {
    return current.fold(
      (status) {
        if (status == Status.A) {
          return ranges.values
              .map(
                (range) => range.length,
              )
              .fold(
                1,
                (a, b) => a * b,
              );
        }

        return 0;
      },
      (workflow) => workflowMap[workflow]!
          .map(
            (rule) => rule.fold(
              (dest) => _countAccepted(
                workflowMap: workflowMap,
                current: dest,
                ranges: ranges,
              ),
              (rule) {
                final newRanges = HashMap<Rating, List<int>>.from(ranges);
                final range = ranges[rule.rating]!;

                final oldRange = range
                    .where(
                      (value) =>
                          !_compareValueAgainstRule(value: value, rule: rule),
                    )
                    .toList();
                final newRange = range
                    .where(
                      (value) =>
                          _compareValueAgainstRule(value: value, rule: rule),
                    )
                    .toList();

                newRanges[rule.rating] = newRange;
                ranges[rule.rating] = oldRange;

                return _countAccepted(
                  workflowMap: workflowMap,
                  current: rule.dest,
                  ranges: newRanges,
                );
              },
            ),
          )
          .sum,
    );
  }
}
