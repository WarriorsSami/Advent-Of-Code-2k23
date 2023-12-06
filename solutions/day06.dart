import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final timeDistanceParts = parseInput()
        .map((line) => line.split(':')[1].trim().split(RegExp(r'\s+')))
        .map((part) => part.map(int.parse).toList())
        .toList();

    final timeDistance = zip(timeDistanceParts)
        .map((part) => (time: part[0], distance: part[1]))
        .toList();

    return timeDistance.map((part) {
      final (:time, :distance) = part;
      var boostTime = time;
      var speed = 0;

      final distanceOutcome = List.generate(((time + 1) / 2).floor(), (index) {
        return speed++ * boostTime--;
      });

      final distanceOutcomeReversed = distanceOutcome.reversed.toList();

      if (time.isEven) {
        distanceOutcome.add(speed * boostTime);
      }

      distanceOutcome.addAll(distanceOutcomeReversed);

      return distanceOutcome.where((element) => element > distance).length;
    }).fold(1, (a, b) => a * b);
  }

  @override
  int solvePart2() {
    final timeDistanceParts = parseInput()
        .map((line) => line.split(':')[1].trim().split(RegExp(r'\s+')))
        .map((part) => part.join())
        .map(int.parse)
        .toList();

    final [time, distance] = timeDistanceParts;
    var boostTime = time;
    var speed = 0;

    final distanceOutcome = List.generate(((time + 1) / 2).floor(), (index) {
      return speed++ * boostTime--;
    });

    final distanceOutcomeReversed = distanceOutcome.reversed.toList();

    if (time.isEven) {
      distanceOutcome.add(speed * boostTime);
    }

    distanceOutcome.addAll(distanceOutcomeReversed);

    return distanceOutcome.where((element) => element > distance).length;
  }
}
