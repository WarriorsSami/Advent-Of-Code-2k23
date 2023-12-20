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

extension ListStringExtensions on List<String> {
  Iterator<String> toCircularIterator() {
    return _CircularIterator(this);
  }
}

class _CircularIterator<T> implements Iterator<T> {
  _CircularIterator(this._list);

  final List<T> _list;
  int _index = 0;

  @override
  T get current => _list[_index];

  @override
  bool moveNext() {
    _index = (_index + 1) % _list.length;
    return true;
  }
}

int lcm(int a, int b) => (a * b) ~/ a.gcd(b);
