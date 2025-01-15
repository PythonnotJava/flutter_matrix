part of 'matrix_type.dart';

typedef Range = List<double>;
extension MatrixVisualization on Matrix {
  /// Generates a visual abstraction that matches the histogram.
  /// [start] is the starting point of the count value, and [end] is the end point of the count value.
  /// [counts] indicates the number of intervals, and the interval follows the principle of left-closed and right-open.
  /// The flexibility of this method is that it can count the histogram of some interval data.
  /// Please extract and handle special values.
  Map<Range, int> toHist({
    required double start,
    required double end,
    required int counts
  }){
    assert(start < end && counts > 1);
    double intervalSize = (end - start) / counts;
    Map<Range, int> histogram = {};
    for (int c = 0;c < counts;c++){
      histogram[[start + c * intervalSize, start + (c + 1) * intervalSize]] = 0;
    }
    for (var list in self) {
      for (var e in list) {
        for (var range in histogram.keys) {
          double lower = range[0];
          double upper = range[1];
          if (e >= lower && e < upper) {
            histogram[range] = histogram[range]! + 1;
            break;
          }
        }
      }
    }
    return histogram;
  }

  /// Abstract histogram statistics.
  Map<double, int> toBar(){
    Map<double, int> bar = {};
    for (var list in self) {
      for (var e in list) {
        if (bar.containsKey(e)) {
          bar[e] = bar[e]! + 1;
        } else {
          bar[e] = 1;
        }
      }
    }
    return bar;
  }
}
