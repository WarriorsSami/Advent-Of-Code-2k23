import 'dart:math';

extension ListIntExtensions on List<int> {
  int compareTo(
    List<int> other, [
    int Function(List<int>, List<int>)? compare,
  ]) {
    for (var i = 0; i < min(length, other.length); i++) {
      if (this[i] != other[i]) {
        return compare?.call(this, other) ?? this[i].compareTo(other[i]);
      }
    }
    return 0;
  }
}
