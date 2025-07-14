import 'dart:math' as math;
import 'dart:core';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'unrelated_util.dart';
import 'complex.dart';

part 'matrix_base.dart';
part 'matrix_math.dart';
part 'matrix_linalg.dart';
part 'matrix_functools.dart';
part 'matrix_random.dart';
part 'matrix_geometry.dart';
part 'matrix_visualization.dart';
part 'matrix_ml.dart';
part 'matrix_extension.dart';

class MatrixWrapper<T extends MatrixBase<T>> extends MatrixBase<T>
    with
        MatrixFunctools<T>,
        MatrixGeometry<T>,
        MatrixLinalg<T>,
        MatrixMath<T>,
        MatrixML<T>,
        MatrixRandom<T>,
        MatrixVisualization<T> {
  MatrixWrapper(List<List<num>> data, {int? known_row, int? known_column}) {
    super.self = MatrixExtension.constructor(data);
    super.shape = [known_row ?? data.length, known_column ?? data[0].length];
  }

  MatrixWrapper.fromList(List<List<double>> data,
      {int? known_row, int? known_column}) {
    super.self = data;
    super.shape = [known_row ?? data.length, known_column ?? data[0].length];
  }

  @override
  T _fromList(List<List<double>> data, {int? known_row, int? known_column}) {
    return MatrixWrapper<T>.fromList(data, known_row: known_row, known_column: known_column)
    as T;
  }
}

class Matrix extends MatrixWrapper<Matrix>{

  Matrix(List<List<num>> data, {int? known_row, int? known_column}) :
      super(data, known_row: known_row, known_column: known_column);

  Matrix.fromList(List<List<double>> data, {int? known_row, int? known_column}) :
        super.fromList(data, known_row: known_row, known_column: known_column);

  @override
  Matrix _fromList(List<List<double>> data, {int? known_row, int? known_column}) {
    return Matrix.fromList(data, known_row: known_row, known_column: known_column);
  }
}

/// MatrixCollection不同于Matrix，它内置了一个拓展属性并且根据不同的实例进行哈希
/// Dart标准规定，
/// ✅ 如果 a == b 为 true，那么 a.hashCode == b.hashCode 必须为 true。
/// ✅ 如果 a.hashCode == b.hashCode，a == b 可以是 false。
class MatrixCollection extends MatrixWrapper<MatrixCollection>{
  final Map<String, dynamic> binds = {};

  MatrixCollection(List<List<double>> data,
      {int? known_row, int? known_column}) :
        super(data, known_row: known_row, known_column: known_column);

  MatrixCollection.fromList(List<List<double>> data,
      {int? known_row, int? known_column}) :
        super.fromList(data, known_row: known_row, known_column: known_column);

  @override
  MatrixCollection _fromList(List<List<double>> data,
      {int? known_row, int? known_column}) {
    return MatrixCollection.fromList(data,
        known_row: known_row, known_column: known_column);
  }

  @override
  int get hashCode => identityHashCode(this);

  @override
  bool operator == (Object other) => identical(this, other);

  dynamic getter(String key) => binds[key];
  void setter(String key, dynamic value) => binds[key] = value;
}
