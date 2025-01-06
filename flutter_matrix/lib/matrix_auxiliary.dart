part of 'matrix_type.dart';

/// Type specification, int and double are standard types,
/// bool is constructed using [BoolList] which saves more memory,
/// and others are related to [TypedData].
enum Typed { int8, int16, int32, int64, int, float32, float64, double, bool, uint8, uint16, uint32, uint64 }

/// Special attention content information warning by [Alert].
final class Alert {
  final String msg;
  const Alert(this.msg);
  String toString() => 'Alert : $msg';
}
/// When a change needs to be specifically marked, use the [Since] class.
final class Since {
  final String msg;
  const Since(this.msg);
  String toString() => 'Since : $msg';
}

/// The auxiliary mixin class is more about encapsulating some list extension methods
mixin MatrixAuxiliary{
  double Function(double, double) _abstract_operator(int mode) {
    final double Function(double, double) func = switch(mode){
      0 => (x, y) => x + y,
      1 => (x, y) => x - y,
      2 => (x, y) => x * y,
      3 => (x, y) => x / y,
      _ => (x, y) => double.nan
    };
    return func;
  }

  double Function(double) _math_basement_single(int mode){
    final double Function(double) func = switch (mode) {
      0 => math.sin,
      1 => math.cos,
      2 => math.tan,
      3 => math.asin,
      4 => math.acos,
      5 => math.atan,
      6 => sinh,
      7 => cosh,
      8 => tanh,
      9 => asinh,
      10 => acosh,
      11 => atanh,
      12 => math.exp,
      13 => math.log,
      14 => math.sqrt,
      15 => log10,
      16 => square,
      17 => cube,
      18 => abs,
      19 => ceil,
      20 => floor,
      21 => round,
      22 => degree,
      23 => radian,
      _ => (x) => x
    };
    return func;
  }

  double _pow_double(double base, double exponent) => math.pow(base, exponent).toDouble();

  double Function(double, double) _math_basement_double(int mode){
    final double Function(double, double) func = switch (mode){
      0 => _pow_double,
      1 => math.atan2,
      _ => _pow_double
    };
    return func;
  }

  /// Generate coincidental list.
  List<List<double>> _coincidental_list({
    required int row,
    required int column,
    required List<int> mt_shape,
    required List<List<double>> mt_self
  }){
    var [its_row, its_column] = mt_shape;
    final data = List.generate(its_row - 1, (i) => List.filled(its_column - 1, 0.0, growable: true));
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        data[r][c] = mt_self[r][c];
      }
    }
    for (int r = 0;r < row;r++){
      for (int c = column;c < its_column - 1;c++){
        data[r][c] = mt_self[r][c + 1];
      }
    }
    for (int r = row;r < its_row - 1;r++){
      for (int c = 0;c < column;c++){
        data[r][c] = mt_self[r + 1][c];
      }
    }
    for (int r = row;r < its_row - 1;r++){
      for (int c = column;c < its_column - 1;c++){
        data[r][c] = mt_self[r + 1][c + 1];
      }
    }
    return data;
  }

  /// Get det of square-matrix.
  double _det({required List<List<double>> mt_self, required List<int> mt_shape}) {
    var [row, column] = mt_shape;
    assert(row == column);
    double detValue = 1.0;
    int n = row;
    final matrixcpy = mt_self.map((row_list) => row_list.map((e) => e).toList()).toList();

    for (int i = 0; i < n; i++) {
      int max_row = i;
      for (int k = i + 1; k < n; k++) {
        if ((matrixcpy[k][i]).abs() > (matrixcpy[max_row][i]).abs()) {
          max_row = k;
        }
      }
      if (matrixcpy[max_row][i] == 0) {
        return 0;
      }

      if (max_row != i) {
        matrixcpy.swap(max_row, i);
        detValue = -detValue;
      }
      detValue *= matrixcpy[i][i];
      for (int k = i + 1; k < n; k++) {
        double factor = matrixcpy[k][i] / matrixcpy[i][i];
        for (int j = i; j < n; j++) {
          matrixcpy[k][j] -= factor * matrixcpy[i][j];
        }
      }
    }
    return detValue;
  }

  /// Use Gaussian elimination to reduce the matrix to row minimum form.
  List<List<double>> _rref({required List<List<double>> mt_self, required List<int> mt_shape}) {
    final data = mt_self.map((row_list) => row_list.map((e) => e).toList()).toList();
    var [row, column] = mt_shape;
    int lead = 0;
    for (int r = 0; r < row; r++) {
      if (lead >= column) {
        return data;
      }
      int i = r;
      while ((data[i][lead]).abs() <= tolerance_round) {
        i++;
        if (i == row) {
          i = r;
          lead++;
          if (lead == column) {
            return data;
          }
        }
      }

      if (i != r) {
        double temp = 0.0;
        for (int c= 0;c < column; c ++) {
          temp = data[i][c];
          data[i][c] = data[r][c];
          data[r][c] = temp;
        }
      }

      double lv = data[r][lead];
      for (int c= 0; c < column; c ++) {
        data[r][c] /= lv;
      }

      for (int r1= 0; r1 < row; r1++) {
        if (r1 != r) {
          lv = data[r1][lead];
          for (int c = 0; c< column; c ++) {
            data[r1][c] -= lv * data[r][c];
          }
        }
      }
      lead++;
    }
    return data;
  }

  /// Transpose of a list
  List<List<double>> _transpose({required List<List<double>> mt_self, required List<int> mt_shape}){
    var [row, column] = mt_shape;
    return List.generate(column, (r) => List.generate(row, (c) => mt_self[c][r]));
  }
}