part of 'matrix_type.dart';

extension MatrixLinalg on Matrix{
  /// Transpose a matrix
  Matrix transpose()
    => Matrix.fromList(_transpose(mt_self: self, mt_shape: shape), known_row: shape[1], known_column: shape[0]);

  /// Gets the trace of the main diagonal of the matrix (not just the square).
  double trace() {
    double sums = 0.0;
    for (int i = 0;i < math.min(shape[0], shape[1]);i++){
      sums += self[i][i];
    }
    return sums;
  }

  /// 是否是方阵
  bool get isSquare => shape[0] == shape[1];

  /// Gets the cocontinuum formula of the matrix.
  Matrix coincidental({required int row, required int column}){
    var [its_row, its_column] = shape;
    assert (row >= 0 && row < its_row && column < its_column && column >= 0);
    return Matrix.fromList(
      _coincidental_list(row: row, column: column, mt_shape: shape, mt_self: self),
      known_row: its_row - 1,
      known_column: its_column - 1
    );
  }

  /// Elementary transformations: swapping rows or columns.
  void elementary_exchange({required int index1, required int index2, bool horizontal = true}) {
    var [row, column] = shape;
    if(horizontal){
      assert(index1 >= 0 && index2 >= 0 && index1 < row && index2 < row);
      self.swap(index1, index2);
    }else{
      assert(index1 >= 0 && index2 >= 0 && index1 < column && index2 < column);
      for (int r = 0;r < row;r++){
        var v = self[r][index1];
        self[r][index1] = self[r][index2];
        self[r][index2] = v;
      }
    }
  }

  /// Elementary transformations: multiplying rows or columns.
  void elementary_multiply({required int index, required double number, bool horizontal = true}){
    var [row, column] = shape;
    if (horizontal){
      assert(index >= 0 && index < row);
      for (int c = 0;c < column;c++){
        self[index][c] *= number;
      }
    }else{
      assert(index >= 0 && index < column);
      for (int r = 0;r < row;r++){
        self[r][index] *= number;
      }
    }
  }

  /// Elementary transformations: adding rows or columns.
  /// Add the target of index 2 times number to the target of index 1.
  void elementary_add({required int index1, required int index2, required double number, bool horizontal = true}){
    var [row, column] = shape;
    if (horizontal){
      assert(index1 >= 0 && index2 >= 0 && index1 < row && index2 < row);
      for (int c = 0;c < column;c++){
        self[index1][c] += self[index2][c] * number;
      }
    }else{
      assert(index1 >= 0 && index1 < column && index2 >= 0 && index2 < column);
      for (int r = 0;r < row;r++){
        self[r][index1] += self[r][index2] * number;
      }
    }
  }

  /// Compute the dot product of the left row and right column.
  Matrix dot({required Matrix other}){
    var [row, column] = shape;
    var [other_row, other_column] = other.shape;
    assert(column == other_row);
    final data = List.generate(row, (i) => List.filled(column, 0.0, growable: true));
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < other_column; j++) {
        var sum = 0.0;
        for (var k = 0; k < column; k++) {
          sum += self[i][k] * other[k][j];
        }
        data[i][j] = sum;
      }
    }
    return Matrix.fromList(data, known_row: row, known_column: other_column);
  }

  /// Kronecker Product.
  Matrix kronecker({required Matrix other}){
    var [row, column] = shape;
    var [other_row, other_column] = other.shape;
    final data = List.generate(
      row * other_row,
      (i) => List.filled(column * other_column, 0.0, growable: true)
    );
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < other_row; j++) {
        for (var k = 0; k < column; k++) {
          for (var l = 0; l < other_column; l++) {
            data[i * other_row + k][j * other_column + l] = self[i][j] * other[k][l];
          }
        }
      }
    }
    return Matrix.fromList(
        data,
        known_row: row * other_row,
        known_column: column * other_column
    );
  }

  /// Determinant of a square matrix.
  double get det => _det(mt_self: self, mt_shape: shape);

  /// Get the adjoint matrix.
  Matrix get adjugate {
    assert(isSquare);
    int n = shape[0];
    final data = List.generate(n, (r) => List.filled(n, 0.0, growable: true));
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c ++) {
        final cof = _coincidental_list(row: r, column: c, mt_self: self, mt_shape: [n, n]);
        data[c][r] = ((r + c) % 2 == 0 ? 1 : -1) * _det(mt_shape: [n - 1, n - 1], mt_self: cof);
      }
    }
    return Matrix.fromList(data, known_row: n, known_column: n);
  }

  /// Inverse Matrix.
  Matrix get inverse {
    final adj = adjugate;
    int n = shape[0];
    double detV = det;
    assert(detV.abs() > tolerance_round.abs());

    for (int r = 0; r < n; r++) {
      for (int c = 0;c < n;c++) {
        adj[r][c] /= detV;
      }
    }
    return adj;
  }

  /// Use Gaussian elimination to reduce the matrix to row minimum form.
  Matrix get rref => Matrix.fromList(
    _rref(mt_self: self, mt_shape: shape),
    known_row: shape[0],
    known_column: shape[1]
  );

  /// Get the rank.
  int get rank {
    final rref_list = _rref(mt_self: self, mt_shape: shape);
    int counter = 0;
    var [row, column] = shape;
    int n = math.min(row, column);
    for (int r = 0; r < n; r++) {
      int isZeroRow = 1;
      for (int c = 0; c < column; c++) {
        if (rref_list[r][c].abs() > tolerance_round) {
          isZeroRow = 0;
          break;
        }
      }
      if (isZeroRow == 0){
        counter++;
      }
    }
    return counter;
  }
}