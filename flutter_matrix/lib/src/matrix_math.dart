part of 'matrix_type.dart';

extension MatrixMath on Matrix {
  /// Get the minimum
  Object min({int dim = -1}){
    if (dim == 0){
      return List.generate(shape[0], (r) => self[r].min);
    }else if (dim == 1){
      return List.generate(shape[1], (c) => column_(c).min);
    } else {
      return List.generate(shape[0], (r) => self[r].min).min;
    }
  }


  /// Get the maximum
  Object max({int dim = -1}){
    if (dim == 0){
      return List.generate(shape[0], (r) => self[r].max);
    }else if (dim == 1){
      return List.generate(shape[1], (c) => column_(c).max);
    } else {
      return List.generate(shape[0], (r) => self[r].max).max;
    }
  }

  /// Get the minimum or maximum's index.
  Object _argmin_max(bool isMin, {int dim = -1}){
    var _min_max = isMin ? min(dim: dim) : max(dim: dim);
    if (dim == 0){
      _min_max as List<double>;
      return List.generate(shape[0], (r) => self[r].indexOf(_min_max[r]));
    }else if (dim == 1){
      _min_max as List<double>;
      return List.generate(shape[1], (c) => column_(c).indexOf(_min_max[c]));
    } else {
      _min_max as double;
      var [row, column] = shape;
      for (int r = 0;r < row;r++){
        var v = self[r].indexOf(_min_max);
        if (v != -1){
          return v + column * r;
        }
      }
      return -1; // Never gonna get here!
    }
  }
  Object argmin({int dim = -1}) => _argmin_max(true, dim: dim);
  Object argmax({int dim = -1}) => _argmin_max(false, dim: dim);

  /// Get the range.
  Object get_range({int dim = -1}){
    if (dim == 0){
      return List.generate(shape[0], (r){
        final row_list = self[r];
        return [row_list.min, row_list.max];
      });
    }else if (dim == 1){
      return List.generate(shape[1], (c){
        final column_list = column_(c);
        return [column_list.min, column_list.max];
      });
    } else {
      return [min(), max()];
    }
  }

  /// Sum.
  Object sum({int dim = -1}){
    if (dim == 0){
      return reduce((x, y) => x + y, dim: 0);
    }else if (dim == 1){
      return reduce((x, y) => x + y, dim: 1);
    } else {
      return reduce((x, y) => x + y, dim: -1);
    }
  }

  /// Basic mathematical functions.
  /// - 0 => math.sin,
  /// - 1 => math.cos,
  /// - 2 => math.tan,
  /// - 3 => math.asin,
  /// - 4 => math.acos,
  /// - 5 => math.atan,
  /// - 6 => sinh,
  /// - 7 => cosh,
  /// - 8 => tanh,
  /// - 9 => asinh,
  /// - 10 => acosh,
  /// - 11 => atanh,
  /// - 12 => math.exp,
  /// - 13 => math.log,
  /// - 14 => math.sqrt,
  /// - 15 => log10,
  /// - 16 => square,
  /// - 17 => cube,
  /// - 18 => math.abs,
  /// - 19 => math.ceil,
  /// - 20 => math.floor,
  /// - 21 => math.round,
  /// - 22 => degree,
  /// - 23 => radian,
  Matrix _math_basement_single_realize(int mode) {
    final func = _math_basement_single(mode);
    return Matrix.fromList(
      self.map((row_list) => row_list.map((e) => func(e)).toList()).toList(),
      known_row: shape[0],
      known_column: shape[1]
    );
  }
  Matrix get sin => _math_basement_single_realize(0);
  Matrix get cos => _math_basement_single_realize(1);
  Matrix get tan => _math_basement_single_realize(2);
  Matrix get asin => _math_basement_single_realize(3);
  Matrix get acos => _math_basement_single_realize(4);
  Matrix get atan => _math_basement_single_realize(5);
  Matrix get sinh => _math_basement_single_realize(6);
  Matrix get cosh => _math_basement_single_realize(7);
  Matrix get tanh => _math_basement_single_realize(8);
  Matrix get asinh => _math_basement_single_realize(9);
  Matrix get acosh => _math_basement_single_realize(10);
  Matrix get atanh => _math_basement_single_realize(11);
  Matrix get exp => _math_basement_single_realize(12);
  Matrix get log => _math_basement_single_realize(13);
  Matrix get sqrt => _math_basement_single_realize(14);
  Matrix get log10 => _math_basement_single_realize(15);
  Matrix get square => _math_basement_single_realize(16);
  Matrix get cube => _math_basement_single_realize(17);
  Matrix get abs => _math_basement_single_realize(18);
  Matrix get ceil => _math_basement_single_realize(19);
  Matrix get floor => _math_basement_single_realize(20);
  Matrix get round => _math_basement_single_realize(21);
  Matrix get degree => _math_basement_single_realize(22);
  Matrix get radian => _math_basement_single_realize(23);

  Matrix _math_basement_double_realize(int mode, {required double number, bool reverse = false}){
    final func = _math_basement_double(mode);
    return !reverse ? Matrix.fromList(
        self.map((row_list) => row_list.map((e) => func(e, number)).toList()).toList(),
        known_row: shape[0],
        known_column: shape[1]
    ) : Matrix.fromList(
        self.map((row_list) => row_list.map((e) => func(number, e)).toList()).toList(),
        known_row: shape[0],
        known_column: shape[1]
    );
  }
  /// Realizes the power of the matrix. When reverse is true, it means that number is the base.
  Matrix power({required double number, bool reverse = false}) => _math_basement_double_realize(0, number: number, reverse: reverse);
  /// Inverse tangent function, when reverse is true, it means number is the denominator.
  Matrix atan2({required double number, bool reverse = false}) => _math_basement_double_realize(1, number: number, reverse: reverse);

  /// Central Difference Derivative
  Matrix diff(double Function(double) func){
    return Matrix.fromList(
      self.map((row_list) => row_list.map((x) => diffCentral(x, func)).toList()).toList(),
      known_row: shape[0],
      known_column: shape[1]
    );
  }

  /// Discrete Fourier Transform.
  /// Treat each row of data as the real and imaginary parts of a [Complex] number.
  Matrix dft_complex(){
    var [row, column] = shape;
    assert (column == 2);
    List<List<double>> data = [];
    for (int k = 0;k < row;k++){
      Complex complex = Complex();
      for (int n = 0;n < row;n++){
        double angle = -2 * math.pi * k * n / row;
        var [real, imaginary] = self[n];
        complex = complex + Complex(real: real, imaginary: imaginary) * Complex(real: 0.0, imaginary: angle).exp;
      }
      data.add(complex.toList);
    }
    return Matrix.fromList(
      data,
      known_row: row,
      known_column: 2
    );
  }

  /// Fast Fourier transform, the number of complex numbers must be a power of 2.
  Matrix fft_complex() {
    var [row, column] = shape;
    assert ((row & (row - 1) == 0) && row >= 2 && column == 2);
    return Matrix.fromList(
      _fft(mt_self: self, mt_shape: shape).map((complex) => complex.toList).toList(),
      known_row: shape[0],
      known_column: 2
    );
  }

  /// Convert to Complex-like matrix.
  Matrix toComplex(){
    var [row, column] = shape;
    List<List<double>> data = [];
    for (int r = 0;r < row;r++){
      for (int c = 0;c < column;c++){
        data.add([self[r][c], 0.0]);
      }
    }
    return Matrix.fromList(
      data,
      known_column: 2,
      known_row: size
    );
  }

  /// Discrete Fourier Transform.
  List<List<Complex>> dft() {
    int rows = shape[0];
    int cols = shape[1];
    List<List<Complex>> result = [];
    for (int u = 0; u < rows; u++) {
      List<Complex> ls = [];
      for (int v = 0; v < cols; v++) {
        Complex sum = Complex();
        for (int x = 0; x < rows; x++) {
          for (int y = 0; y < cols; y++) {
            double angle = -2 * math.pi * ((u * x / rows) + (v * y / cols));
            Complex exponent = Complex(imaginary: angle).exp;
            sum += exponent * Complex(real: self[x][y].toDouble());
          }
        }
        ls.add(sum);
      }
      result.add(ls);
    }
    return result;
  }
}
