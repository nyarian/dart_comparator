// ignore: avoid_relative_lib_imports
import '../lib/comparator.dart';

void main() {
  print("I am sure that this will be equal to zero..."
      "\nA-a-and..."
      "\n..."
      "\n..."
      "\n${compareBy<DateTime, num>((DateTime dateTime) => dateTime.year)
      .thenCompareBy<num>((DateTime dateTime) => dateTime.month)
      .thenCompareBy<num>((DateTime dateTime) => dateTime.day)
      .compare(DateTime.utc(2011, 5, 28, 14),
      DateTime.utc(2011, 5, 28, 15))}!");
}
