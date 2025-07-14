part of 'matrix_type.dart';

/// Linear algebra related operations on matrices.
mixin MatrixLinalg<T extends MatrixBase<T>> on MatrixBase<T> {
  /// The [trace] of the matrix. If it is not a square matrix,
  /// the trace of the square matrix is taken as the minimum value of the row and column.
  double trace() => self.trace;

  /// Elementary transformation of matrices - swapping.
  void elementaryExchange({
    required int index1, required int index2, bool horizontal = true
  }) => self.elementaryExchange(
    index1: index1,
    index2: index2,
    horizontal: horizontal
  );

  /// Elementary transformation of a matrix - multiply a row(column), where 0 is allowed.
  void elementaryMultiply({
    required int index, required double number, bool horizontal = true
  }) => self.elementaryMultiply(
    index: index,
    number: number,
    horizontal: horizontal
  );

  /// Elementary transformation of matrices - multiply a row (column) [index2] and add it to another row (column) [index1].
  void elementaryAdd({
    required int index1,
    required int index2,
    required double number,
    bool horizontal = true
  }) => self.elementaryAdd(
    index1: index1,
    index2: index2,
    number: number,
    horizontal: horizontal
  );

  /// Transpose a matrix.
  T transpose() => _fromList(self.transpose);
  T get T_ => _fromList(self.transpose);

  /// The determinant of a square matrix.
  double get det => self.det;

  /// Get the adjoint matrix of a square matrix.
  T get adjugate => _fromList(self.adjugate);

  /// Get the inverse of a nonsingular square matrix.
  T get inverse => _fromList(self.inverse);

  /// Get the rank of a square matrix.
  int get rank => self.rank;

  /// Reducing the number of elements to the simplest row echelon form by Gaussian elimination.
  T get rref => _fromList(self.rref);

  /// Get the remainder of the matrix without [row] and [column].
  T coincidental({required int row, required int column}) => _fromList(self.coincidental(row: row, column: column));

  /// Standard matrix multiplication.
  T product({required T other}) => _fromList(self.product(other: other.self));

  /// Kronecker product.
  T kronecker({required T other}) => _fromList(self.kronecker(other: other.self));
}