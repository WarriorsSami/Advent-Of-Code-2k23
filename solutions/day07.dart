import 'dart:collection';

import '../utils/index.dart';
import '../utils/list_extensions.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    const cardRanking = {
      '2': 1,
      '3': 2,
      '4': 3,
      '5': 4,
      '6': 5,
      '7': 6,
      '8': 7,
      '9': 8,
      'T': 9,
      'J': 10,
      'Q': 11,
      'K': 12,
      'A': 13,
    };

    final cardDeck = parseInput()
        .map((line) => line.split(' '))
        .map(
          (parts) => (
            hand: parts[0],
            bid: int.parse(parts[1]),
          ),
        )
        .map((pair) {
      final handRanking = pair.hand
          .split('')
          .map(
            (card) => cardRanking[card]!,
          )
          .toList();

      final handMap = pair.hand.split('').fold(
            HashMap<String, int>(),
            (map, card) => map
              ..update(
                card,
                (value) => value + 1,
                ifAbsent: () => 1,
              ),
          );

      final handType = handMap.entries
          .where((card) => card.value != 0)
          .map((card) => card.value)
          .toList()
        ..sort((a, b) => b.compareTo(a));

      return (handRanking: handRanking, handType: handType, bid: pair.bid);
    }).toList()
      ..sort((a, b) {
        if (a.handType.compareTo(b.handType) != 0) {
          return a.handType.compareTo(b.handType);
        }

        return a.handRanking.compareTo(b.handRanking);
      });

    return cardDeck
        .mapIndexed((index, hand) => hand.bid * (index + 1))
        .reduce((a, b) => a + b);
  }

  @override
  int solvePart2() {
    const cardRanking = {
      'J': 0, // the Joker
      '2': 1,
      '3': 2,
      '4': 3,
      '5': 4,
      '6': 5,
      '7': 6,
      '8': 7,
      '9': 8,
      'T': 9,
      'Q': 10,
      'K': 11,
      'A': 12,
    };

    final cardDeck = parseInput()
        .map((line) => line.split(' '))
        .map(
          (parts) => (
            hand: parts[0],
            bid: int.parse(parts[1]),
          ),
        )
        .map((pair) {
      final handRanking = pair.hand
          .split('')
          .map(
            (card) => cardRanking[card]!,
          )
          .toList();

      final handMap = pair.hand.split('').fold(
            HashMap<String, int>(),
            (map, card) => map
              ..update(
                card,
                (value) => value + 1,
                ifAbsent: () => 1,
              ),
          );

      // get the count of the joker,
      // add it to the card with the highest count
      // and remove the joker by setting it to 0
      final jokerCount = handMap['J'] ?? 0;
      final cardWithHighestCount = maxBy(
        handMap.entries
            .where((card) => card.value != 0 && card.key != 'J')
            .toList(),
        (card) => card.value,
      );

      if (cardWithHighestCount != null) {
        handMap[cardWithHighestCount.key] =
            cardWithHighestCount.value + jokerCount;
        handMap['J'] = 0;
      }

      final handType = handMap.entries
          .where((card) => card.value != 0)
          .map((card) => card.value)
          .toList()
        ..sort((a, b) => b.compareTo(a));

      return (handRanking: handRanking, handType: handType, bid: pair.bid);
    }).toList()
      ..sort((a, b) {
        if (a.handType.compareTo(b.handType) != 0) {
          return a.handType.compareTo(b.handType);
        }

        return a.handRanking.compareTo(b.handRanking);
      });

    return cardDeck
        .mapIndexed((index, hand) => hand.bid * (index + 1))
        .reduce((a, b) => a + b);
  }
}
