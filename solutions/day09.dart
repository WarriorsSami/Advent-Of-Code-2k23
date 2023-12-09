import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    return parseInput()
        .map((line) => line.split(' ').map(int.parse).toList())
        .map(
      (seq) {
        final seqList = [seq];
        var diffSeq = _getDiffSeq(seq);
        while (diffSeq.any((element) => element != 0)) {
          seqList.add(diffSeq);
          diffSeq = _getDiffSeq(diffSeq);
        }

        return seqList.fold(
          0,
          (previousValue, list) => previousValue + list.last,
        );
      },
    ).sum;
  }

  @override
  int solvePart2() {
    return parseInput()
        .map((line) => line.split(' ').map(int.parse).toList())
        .map(
      (seq) {
        final seqList = [seq];
        var diffSeq = _getDiffSeq(seq);
        while (diffSeq.any((element) => element != 0)) {
          seqList.add(diffSeq);
          diffSeq = _getDiffSeq(diffSeq);
        }

        return seqList.reversed.fold(
          0,
          (previousValue, list) => list.first - previousValue,
        );
      },
    ).sum;
  }

  List<int> _getDiffSeq(List<int> seq) {
    final diffSeq = <int>[];
    for (var i = 0; i < seq.length - 1; i++) {
      diffSeq.add(seq[i + 1] - seq[i]);
    }
    return diffSeq;
  }
}
