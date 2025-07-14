part of 'matrix_type.dart';

/// Visual abstraction of matrix data.
mixin MatrixVisualization<T extends MatrixBase<T>> on MatrixBase<T> {
  /// Generates a visual abstraction that matches the histogram.
  /// [start] is the starting point of the count value, and [end] is the end point of the count value.
  /// [counts] indicates the number of intervals, and the interval follows the principle of left-closed and right-open.
  /// The flexibility of this method is that it can count the histogram of some interval data.
  /// Please extract and handle special values.
  Map<Range, int> toHist(
          {required double start, required double end, required int counts}) =>
      self.toHist(start: start, end: end, counts: counts);

  /// Abstract histogram statistics.
  Map<double, int> toBar() => self.toBar();
}
