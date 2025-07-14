part of 'matrix_type.dart';

/// Function modules operate matrix data according to conditions.
mixin MatrixFunctools<T extends MatrixBase<T>> on MatrixBase<T> {
  /// Determine whether there are elements that meet the conditions.
  Object any(bool Function(double) condition, {int dim = -1}) =>
      self.anyExtension(condition, dim: dim);

  /// Determine whether all elements meet the conditions.
  Object all(bool Function(double) conditon, {int dim = -1}) =>
      self.allExtension(conditon, dim: dim);

  /// Perform cumulative operations on the matrix,
  /// [element] is used to initialize and record the accumulated value if set.
  Object reduce(double Function(double, double) condition,
          {double? element, int dim = -1}) =>
      self.reduceExtension(condition, dim: dim);

  /// Replace the value that meets the [condition]. [cope] is the replacement method.
  void replace(bool Function(double) condition,
          {required double Function(double) cope}) =>
      self.replaceExtension(condition, cope: cope);

  /// Count the values that meet a [condition].
  Object count(bool Function(double) condition, {int dim = -1}) =>
      self.countExtension(condition, dim: dim);

  /// Customize data mapping.
  T customize(double Function(double) condition) =>
      _fromList(self.customize(condition));

  /// Conditional mapping of data at the same position in two matrices.
  T confront(double Function(double, double) condition, {required T other}) =>
      _fromList(self.confront(condition, other: other.self));

  /// Clip data, [lb] represents the lower limit, [ub] represents the upper limit.
  /// If [reverse] is true, keep the data on both sides.
  /// Otherwise, keep the data in the range. Perform conditional mapping for those that do not meet the [condition].
  T clip(double Function(double) condition,
          {required double lb, required double ub, bool reverse = false}) =>
      _fromList(self.clip(condition, lb: lb, ub: ub, reverse: reverse));
}
