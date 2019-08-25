class ComparatorChain<T> {
  final ComparatorChain<T> _fallback;
  final Comparator<T> _comparator;

  ComparatorChain(this._comparator) : this._fallback = null;

  ComparatorChain._withFallback(this._comparator, this._fallback);

  int compare(T left, T right) {
    final int result = this._comparator(left, right);
    if (result == 0 && _fallback != null) {
      return _fallback.compare(left, right);
    } else {
      return result;
    }
  }

  ComparatorChain<T> thenCompare(ComparatorChain<T> next) =>
      ComparatorChain<T>._withFallback(_comparator, next);

  Comparator<T> asComparator() => compare;
}

class ComparatorChainBuilder<T> {
  final List<Comparator<T>> _comparators = <Comparator<T>>[];

  ComparatorChainBuilder(Comparator<T> comparator) {
    _comparators.add(comparator);
  }

  ComparatorChainBuilder.withSelector(Comparator<T> comparator) {
    _comparators.add(comparator);
  }

  ComparatorChainBuilder._empty();

  // ignore: avoid_returning_this
  ComparatorChainBuilder<T> thenCompareWith(Comparator<T> comparator) {
    _comparators.add(comparator);
    return this;
  }

  // ignore: avoid_returning_this
  ComparatorChainBuilder<T> thenCompareBy<S extends Comparable<S>>(
      Selector<T, S> selector) {
    _comparators
        .add((T left, T right) => selector(left).compareTo(selector(right)));
    return this;
  }

  ComparatorChain<T> build() =>
      _comparators.reversed.skip(1).fold(
          ComparatorChain<T>(_comparators.last),
              (ComparatorChain<T> nextChain, Comparator<T> currentComparator) =>
          ComparatorChain<T>._withFallback(currentComparator, nextChain));

  int compare(T left, T right) => build().compare(left, right);

  bool isEqual(T left, T right) => compare(left, right) == 0;

  bool isGreaterThan(T left, T right) => compare(left, right) > 0;

  bool isLesserThan(T left, T right) => compare(left, right) < 0;
}

ComparatorChainBuilder<T> compareBy<T, S extends Comparable<S>>(
    Selector<T, S> selector) =>
    ComparatorChainBuilder<T>(
            (T left, T right) => selector(left).compareTo(selector(right)));

ComparatorChainBuilder<T> compareWith<T>(Comparator<T> comparator) =>
    ComparatorChainBuilder<T>(comparator);

typedef Selector<T, S extends Comparable<S>> = S Function(T);
