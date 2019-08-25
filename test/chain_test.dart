import 'package:comparator/src/chain.dart';
import 'package:test/test.dart';

void main() {
  group('chain', () {
    test(
        'assert that 0 was returned if comparing chain was configured to'
        ' compare by year, month and day and dates are 14:00 28.05.2011 '
        'and 15:00 28.05.2011', () {
      final DateTime earlier = DateTime.utc(2011, 5, 28, 14);
      final DateTime later = DateTime.utc(2011, 5, 28, 15);
      expect(
          compareBy<DateTime, num>((DateTime dateTime) => dateTime.year)
              .thenCompareBy<num>((DateTime dateTime) => dateTime.month)
              .thenCompareBy<num>((DateTime dateTime) => dateTime.day)
              .compare(earlier, later),
          0);
    });
  });
}
