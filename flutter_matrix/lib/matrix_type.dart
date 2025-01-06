import 'dart:convert';
import 'dart:ffi';
import 'dart:math' as math;
import 'dart:core';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'unrelated_util.dart';

part 'matrix_auxiliary.dart';
part 'matrix_math.dart';
part 'matrix_base.dart';
part 'matrix_linalg.dart';
part 'matrix_functools.dart';
part 'matrix_random.dart';
part 'matrix_geometry.dart';

/// Precision error allowable value.
double tolerance_round = 1e-10;

/// Matrix is matrix class.
/// - It uses [List] to store core data internally.
/// - When constructed by default, it does not consider whether it is empty or not.
/// - If a shape is passed in, it will be based on the passed in shape.
/// - To increase flexibility, Lists in a [Matrix] are all *growable* by default when they are created.
/// The implementation of Matrix follows the simple approach.
/// ```
/// For example, to find a minimum value for each column, I will not use better measures such as bubble
/// algorithm for each column element one by one, but get the list corresponding to the current column and
/// then use the min method of the list. Because I have already implemented the method of getting the list
/// corresponding to the current column, I only consider the logic and abandon some performance.
/// ```
base class Matrix extends Object with MatrixAuxiliary{
  late final List<int> shape;
  late final List<List<double>> self;

  /// Basic constructor, copy the target list data.
  /// If the shape is known, you can optionally pass it in, otherwise it will be calculated by itself.
  Matrix(List<List<num>> data, {int? known_row, int? known_column}){
    self = data.map((row_list) {
      return row_list.map((e) => e.toDouble()).toList();
    }).cast<List<double>>().toList();
    shape = [known_row ?? data.length, known_column ?? data[0].length];
  }

  /// Shared Target List.
  Matrix.fromList(List<List<num>> data, {int? known_row, int? known_column}) :
        self = data.cast<List<double>>(),
        shape = [known_row ?? data.length, known_column ?? data[0].length];

  /// Fill with specified number.
  Matrix.fill({required double number, required int row, required int column}) :
    assert (row > 0 && column > 0){
    shape = [row, column];
    self = List.generate(row, (_){
      return List<double>.filled(column, number, growable: true);
    });
  }

  /// Starting from start, generate a matrix with an interval of 1.
  Matrix.arrange({double start = 0.0, required int row, required int column}) :
    assert(row > 0 && column > 0){
    shape = [row, column];
    int index = 0;
    self = List.generate(row, (_) => List.generate(column, (_) => start + index++));
  }

  /// Only data can be generated that is evenly distributed from start to end.
  /// If keep is true, end is retained. Start is allowed to be greater than or equal to end
  Matrix.linspace({
    required double start,
    required double end,
    bool keep = true,
    required int row,
    required int column,
  }) {
    assert(row > 0 && column > 0);
    final size = row * column;
    final step = keep ? (end - start) / (size - 1) : (end - start) / size;
    int index = 0;
    self = List.generate(row, (_) => List.generate(column, (_) => start + index++ * step));
  }

  /// Deepcopy
  factory Matrix.deepcopy(Matrix other) {
    final data = other.self.map((row) => List<double>.from(row)).toList();
    var [row, column] = other.shape;
    return Matrix.fromList(data, known_row: row, known_column: column);
  }

  /// Generate an identity matrix.
  Matrix.E({required int n}) : assert (n > 0){
    shape = [n, n];
    self = List.generate(
      n,
      (i) => List.filled(n, 0.0, growable: true)..[i] = 1.0,
    );
  }

  /// According to the step size, the step size can be negative.
  Matrix.range({double start = 0.0, double step = 1.0, required int row, required int column}) :
      assert(row > 0 && column > 0){
    shape = [row, column];
    int index = 0;
    self = List.generate(row, (_) => List.generate(column, (_) => start + index++ * step));
  }

  /// Quasi-identity matrix with 1s on the main diagonal
  Matrix.E_like({required int row, required int column}) : assert(row > 0 && column > 0){
    shape = [row, column];
    self = List.generate(
      row,
      (i) => List.filled(column, 0.0, growable: true),
    );
    for (int i = 0;i < math.min(row, column);i++){
      self[i][i] = 1;
    }
  }

  /// format is *%x.y* format, color is a *HEX color* string, such as #000fff
  @override
  String toString({String format = '%0.5f', String color = '#ffd700'}) {
    final rgbColor = hexToAnsi(color);
    const resetColor = '\x1B[0m';
    final regex = RegExp(r'%([0-9]+)\.([0-9]+)f');
    final match = regex.firstMatch(format);
    if (match == null) {
      throw ArgumentError("Invalid format string. Use format like '%x.yf'.");
    }
    final width = int.parse(match.group(1)!);
    final precision = int.parse(match.group(2)!);

    final buffer = StringBuffer();
    buffer.writeln("[");

    for (var r = 0; r < shape[0]; r++) {
      buffer.write(" [");
      for (var c = 0; c < shape[1]; c++) {
        final value = self[r][c];
        buffer.write(rgbColor);
        buffer.write(value.toStringAsFixed(precision).padLeft(width + precision + 1));
        if (c < shape[1] - 1) {
          buffer.write(" ");
        }
        buffer.write(resetColor);
      }
      buffer.write("]");
      if (r < shape[0] - 1) {
        buffer.writeln();
      }
    }

    buffer.writeln();
    buffer.write("]");
    return buffer.toString();
  }

  // Determine whether the data is the same.
  // Finally, [DeepCollectionEquality] is used for data determination.
  @override
  bool operator == (Object other){
    if (identical(this, other)) return true;
    if (other is Matrix) {
      assert(hasSameShape(other));
      return const DeepCollectionEquality().equals(self, other.self);
    } else if (other is num){
      return !(any((x) => x != other, dim: -1) as bool);
    } else {
      return false;
    }
  }

  bool operator > (Object other){
    if (identical(this, other)) return false;
    if (other is Matrix) {
      final data = compare(other: other, which: 0);
      for (var list in data){
        if (list.contains(false)){
          return false;
        }
      }
      return true;
    }else if (other is num){
      return !(any((x) => x <= other, dim: -1) as bool);
    } else {
      return false;
    }
  }

  bool operator >= (Object other){
    if (identical(this, other)) return true;
    if (other is Matrix) {
      final data = compare(other: other, which: 2);
      for (var list in data){
        if (list.contains(false)){
          return false;
        }
      }
      return true;
    }else if (other is num){
      return !(any((x) => x < other, dim: -1) as bool);
    } else {
      return false;
    }
  }

  bool operator < (Object other){
    if (identical(this, other)) return false;
    if (other is Matrix) {
      final data = compare(other: other, which: 1);
      for (var list in data){
        if (list.contains(false)){
          return false;
        }
      }
      return true;
    }else if (other is num){
      return !(any((x) => x >= other, dim: -1) as bool);
    } else {
      return false;
    }
  }

  bool operator <= (Object other){
    if (identical(this, other)) return true;
    if (other is Matrix) {
      final data = compare(other: other, which: 3);
      for (var list in data){
        if (list.contains(false)){
          return false;
        }
      }
      return true;
    }else if (other is num){
      return !(any((x) => x > other, dim: -1) as bool);
    } else {
      return false;
    }
  }

  Matrix operator ^ (num other) => power(number: other.toDouble(), reverse: false);

  /// Modify a row element. Note that this does not copy the element, but points to the list address.
  void operator []= (int index, List<double> value){
    var [row, column] = shape;
    assert(index >= 0 && index < row);
    self[index] = value;
  }

  /// Get point value by location.
  List<double> operator [] (int index) => this.self[index];
  /// Addtion/subtraction/multiplication/division, value is a Matrix type or a number.
  Matrix _abstract_operator_any(int mode, Object other){
    final Matrix Function({int dim, double? number, Matrix? other}) func = switch(mode){
      == 0 => add,
      == 1 => minus,
      == 2 => multiply,
      == 3 => divide,
      _ => add
    };
    if (other is Matrix) {
      return func(other: other);
    } else if (other is num) {
      return func(number: other.toDouble());
    } else {
      throw ArgumentError('Unsupported type: ${other.runtimeType}');
    }
  }
  Matrix operator + (Object other) => _abstract_operator_any(0, other);
  Matrix operator - (Object other) => _abstract_operator_any(1, other);
  Matrix operator * (Object other) => _abstract_operator_any(2, other);
  Matrix operator / (Object other) => _abstract_operator_any(3, other);

  /// Get numbers of element.
  int get size => shape[0] * shape[1];
  /// Transpose
  Matrix get T_ => transpose();
  /// Deepcopy as attribute
  Matrix get deecopy => Matrix.deepcopy(this);
  /// Horizontal flattening
  List<double> get flattened => self.expand((e) => e).toList();
}
