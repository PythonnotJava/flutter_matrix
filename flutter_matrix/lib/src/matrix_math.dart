part of 'matrix_type.dart';

/// Matrix math support.
mixin MatrixMath<T extends MatrixBase<T>> on MatrixBase<T> {
  /// Get the minimum value of a matrix.
  Object min({int dim = -1}) => self.minExtension(dim: dim);

  /// Get the maximum value of a matrix.
  Object max({int dim = -1}) => self.maxExtension(dim: dim);

  /// Get the index of the minimum value of a matrix。
  Object argmin({int dim = -1}) => self.argmin(dim: dim);

  /// Get the index of the maximum value of a matrix.
  Object argmax({int dim = -1}) => self.argmax(dim: dim);

  /// Get the value range of the matrix. The return value is a type related to [Range].
  Object getRange({int dim = -1}) => self.getRangeExtension(dim: dim);

  /// Sum.
  Object sum({int dim = -1}) => self.sumExtension(dim: dim);

  /// The matrix data is the power of [number]. If [reverse] is true, it means that the matrix data is a power.
  T power({required double number, bool reverse = false}) => _fromList(self.powerExtension(number: number, reverse: reverse));

  /// Azimuth formula, [reverse] is true means [number] is the denominator, reverse is the numerator.
  T atan2({required double number, bool reverse = false}) => _fromList(self.atan2Extension(number: number, reverse: reverse));

  /// Some general mathematical methods for single variables.
  T get sin => _fromList(self.sinExtension);
  T get cos => _fromList(self.cosExtension);
  T get tan => _fromList(self.tanExtension);
  T get asin => _fromList(self.asinExtension);
  T get acos => _fromList(self.acosExtension);
  T get atan => _fromList(self.atanExtension);
  T get sinh => _fromList(self.sinhExtension);
  T get cosh => _fromList(self.coshExtension);
  T get tanh => _fromList(self.tanhExtension);
  T get asinh => _fromList(self.asinhExtension);
  T get acosh => _fromList(self.acoshExtension);
  T get atanh => _fromList(self.atanhExtension);
  T get exp => _fromList(self.expExtension);
  T get log => _fromList(self.logExtension);
  T get sqrt => _fromList(self.sqrtExtension);
  T get log10 => _fromList(self.log10Extension);
  T get square => _fromList(self.squareExtension);
  T get cube => _fromList(self.cubeExtension);
  T get abs => _fromList(self.absExtension);
  T get ceil => _fromList(self.ceilExtension);
  T get floor => _fromList(self.floorExtension);
  T get round => _fromList(self.roundExtension);
  T get degree => _fromList(self.degreeExtension);
  T get radian => _fromList(self.radianExtension);

  /// Internal implementation of element-wise arithmetic operations.
  /// Supports matrix-to-matrix or matrix-to-scalar operations.
  /// [dim] specifies the broadcast direction; [mode] 0~3 corresponds to add/subtract/multiply/divide.
  T _abstractOperatorMethod({required Object other, int dim = -1, int mode = 0}){
    if (other is T){
      return _fromList(self._abstractOperatorMethod(mode, other: other.self, number: null, dim: dim));
    } else if (other is num){
      return _fromList(self._abstractOperatorMethod(mode, other: null, number: other.toDouble(), dim: dim));
    } else {
      throw ArgumentError('Unsupported type: ${other.runtimeType}');
    }
  }

  /// Addition of two matrices with the same position data or a matrix and a number.
  /// This method supports broadcasting. If [dim] is 0, it is in the row direction, and if dim is 1, it is in the column direction.
  /// Otherwise, it has the same effect as adding two matrices of the same shape.
  T add({required Object other, int dim = -1}) => _abstractOperatorMethod(other: other, dim: dim, mode: 0);

  /// Subtract the data in the same position of two matrices or the matrix and the number.
  /// This method supports broadcasting. If [dim] is 0, it is in the row direction, and if dim is 1, it is in the column direction.
  /// Otherwise, it has the same effect as subtracting two matrices of the same shape.
  T minus({required Object other, int dim = -1}) => _abstractOperatorMethod(other: other, dim: dim, mode: 1);

  /// Multiply two matrices with the same position data or a matrix and a number.
  /// This method supports broadcasting. If [dim] is 0, it is in the row direction, and if dim is 1, it is in the column direction.
  /// Otherwise, it has the same effect as multiplying two matrices of the same shape.
  T multiply({required Object other, int dim = -1}) => _abstractOperatorMethod(other: other, dim: dim, mode: 2);

  /// The division of two matrices with the same position data or a matrix and a number.
  /// This method supports broadcasting. If [dim] is 0, it is divided in the row direction, and if dim is 1, it is divided in the column direction.
  /// Otherwise, it has the same effect as the division of two matrices of the same shape.
  T divide({required Object other, int dim = -1}) => _abstractOperatorMethod(other: other, dim: dim, mode: 3);

  /// Fast Fourier transform based on Cooley–Tukey FFT algorithm.
  /// By default, each row is the real and imaginary parts of a [Complex] number,
  /// and the number of [Complex] numbers must be a power of 2.
  T fftComplex() => _fromList(self.fftComplex());

  /// Convert a row * column matrix to a size complex matrix.
  /// If [isReal] is true, the elements of the matrix are the real part of the complex number, otherwise they are the imaginary part.
  T toComplexLike({bool isReal = true}) => _fromList(self.toComplexLike(isReal));

  /// Fourier transform of a complex matrix.
  T dftComplex() => _fromList(self.dftComplex());

  /// Fourier transform of a matrix.
  List<List<Complex>> dft() => self.dft();

  /// Function Derivation Based on Central Difference.
  T diff(double Function(double) func) => _fromList(self.diff(func));

  /// Mapping to symbolic matrix.
  T get sgn => _fromList(self.sgn);


}