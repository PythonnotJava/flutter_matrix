part of 'matrix_type.dart';

/// Precision error allowable value.
double tolerance_round = 1e-10;

/// Data output format.
String data_format = '%0.5f';

/// The relative starting point of the point, the default is the origin.
const List<double> OriginVector = [0.0, 0.0];

const _deepEq = const DeepCollectionEquality();

/// This module is an extension module for two-dimensional floating-point arrays
/// and is also the underlying implementation of matrix logic.
extension MatrixExtension on List<List<double>> {
  /// -------------------------------Basement--------------------------------------------
  List<int> get shape => [length, this[0].length];
  int get size => shape[0] * shape[1];
  List<double> get flattened => expand((e) => e).toList();
  bool get isSquare => shape[0] == shape[1];

  /// Does not account for uneven list composition.
  List<List<double>> get deepcopy =>
      map((row) => List<double>.from(row)).toList();

  static double _powDouble(num base, num exponent) =>
      math.pow(base, exponent).toDouble();

  static double Function(double, double) _mathBasementDouble(int mode) {
    final double Function(double, double) func =
        switch (mode) { 0 => _powDouble, 1 => math.atan2, _ => _powDouble };
    return func;
  }

  List<List<double>> _mathBasementDoubleRealize(int mode,
      {required double number, bool reverse = false}) {
    final func = _mathBasementDouble(mode);
    return !reverse
        ? map((row_list) => row_list.map((e) => func(e, number)).toList())
            .toList()
        : map((row_list) => row_list.map((e) => func(number, e)).toList())
            .toList();
  }

  List<List<double>> _mathBasementSingleRealize(int mode) {
    final func = _mathBasementSingle(mode);
    return map((row_list) => row_list.map((e) => func(e)).toList()).toList();
  }

  void align(
      {int mode = 0,
      double number = double.nan,
      double Function(List<double> list)? func}) {
    int maxLength =
        fold<int>(0, (max, row) => row.length > max ? row.length : max);
    for (int i = 0; i < length; i++) {
      List<double> row = this[i];
      int deficit = maxLength - row.length;
      if (deficit <= 0) continue;
      if (mode == 0) {
        row.addAll([for (int k = 0; k < deficit; k++) number]);
      } else if (mode == 1) {
        if (row.isEmpty) {
          row.addAll(List.filled(deficit, double.nan));
        } else {
          row.addAll(List.generate(deficit, (j) => row[j % row.length]));
        }
      } else {
        assert(func != null);
        double value = func!.call(row);
        row.addAll(List.filled(deficit, value));
      }
    }
  }

  static double Function(double, double) _abstractOperator(int mode) {
    final double Function(double, double) func = switch (mode) {
      0 => (x, y) => x + y,
      1 => (x, y) => x - y,
      2 => (x, y) => x * y,
      3 => (x, y) => x / y,
      4 => (x, y) => (x ~/ y).toDouble(), // non-support
      5 => (x, y) => (x % y).toDouble(), // non-support
      _ => (x, y) => double.nan
    };
    return func;
  }

  static List<List<double>> _transpose(
      {required List<List<double>> mt_this, required List<int> mt_shape}) {
    var [row, column] = mt_shape;
    return List.generate(
        column, (r) => List.generate(row, (c) => mt_this[c][r]));
  }

  static List<List<double>> _coincidental(
      {required int row,
      required int column,
      required List<int> mt_shape,
      required List<List<double>> mt_this}) {
    var [its_row, its_column] = mt_shape;
    final data = List.generate(
        its_row - 1, (i) => List.filled(its_column - 1, 0.0, growable: true));
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        data[r][c] = mt_this[r][c];
      }
    }
    for (int r = 0; r < row; r++) {
      for (int c = column; c < its_column - 1; c++) {
        data[r][c] = mt_this[r][c + 1];
      }
    }
    for (int r = row; r < its_row - 1; r++) {
      for (int c = 0; c < column; c++) {
        data[r][c] = mt_this[r + 1][c];
      }
    }
    for (int r = row; r < its_row - 1; r++) {
      for (int c = column; c < its_column - 1; c++) {
        data[r][c] = mt_this[r + 1][c + 1];
      }
    }
    return data;
  }

  static double _det(
      {required List<List<double>> mt_this, required List<int> mt_shape}) {
    var [row, column] = mt_shape;
    assert(row == column);
    double detValue = 1.0;
    int n = row;
    final matrixcpy =
        mt_this.map((row_list) => row_list.map((e) => e).toList()).toList();

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

  static List<List<double>> _rref(
      {required List<List<double>> mt_this, required List<int> mt_shape}) {
    final data =
        mt_this.map((row_list) => row_list.map((e) => e).toList()).toList();
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
        for (int c = 0; c < column; c++) {
          temp = data[i][c];
          data[i][c] = data[r][c];
          data[r][c] = temp;
        }
      }

      double lv = data[r][lead];
      for (int c = 0; c < column; c++) {
        data[r][c] /= lv;
      }

      for (int r1 = 0; r1 < row; r1++) {
        if (r1 != r) {
          lv = data[r1][lead];
          for (int c = 0; c < column; c++) {
            data[r1][c] -= lv * data[r][c];
          }
        }
      }
      lead++;
    }
    return data;
  }

  static double Function(double) _mathBasementSingle(int mode) {
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

  String prettyPrint({String? format, String color = '#ffd700'}) {
    format ??= data_format;
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
        final value = this[r][c];
        buffer.write(rgbColor);
        buffer.write(
            value.toStringAsFixed(precision).padLeft(width + precision + 1));
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

  void definePrint(
      {String? format,
      String color = '#ffd700',
      String? start_point,
      String? end_point}) {
    if (start_point != null) {
      print(start_point);
    }
    print(prettyPrint(format: format, color: color));
    if (end_point != null) {
      print(end_point);
    }
  }

  void setMask({double? nan_mask, double? inf_mask, double? nag_inf_mask}) {
    final _nan = nan_mask ?? double.nan;
    final _pos = inf_mask ?? double.infinity;
    final _neg = nag_inf_mask ?? double.negativeInfinity;
    forEach((list) {
      for (int c = 0; c < list.length; c++) {
        final v = list[c];
        if (v.isNaN) {
          list[c] = _nan;
        } else if (v == double.infinity) {
          list[c] = _pos;
        } else if (v == double.negativeInfinity) {
          list[c] = _neg;
        }
      }
    });
  }

  bool equalTo(Object other) {
    if (identical(this, other)) return true;
    if (other is List<List<double>>) {
      assert(hasSameShape(other));
      return _deepEq.equals(this, other);
    } else if (other is num) {
      return !(anyExtension((x) => x != other, dim: -1) as bool);
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  bool containExtension(double element) {
    for (List<double> list in this) {
      if (list.contains(element)) {
        return true;
      }
    }
    return false;
  }

  List<dynamic> toListExtension(Typed T) {
    switch (T) {
      case Typed.int:
        return map((rowList) => rowList.map((e) => e.toInt()).toList())
            .toList();
      case Typed.double:
        return map((rowList) => rowList.toList()).toList();
      case Typed.bool:
        return map((rowList) => rowList.map((e) => e != 0).toList()).toList();
      case Typed.float32:
        return map((rowList) => Float32List.fromList(rowList)).toList();
      case Typed.float64:
        return map((rowList) => Float64List.fromList(rowList)).toList();
      case Typed.uint8:
        return map((rowList) =>
                Uint8List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.uint16:
        return map((rowList) =>
                Uint16List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.uint32:
        return map((rowList) =>
                Uint32List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.uint64:
        return map((rowList) =>
                Uint64List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.int8:
        return map((rowList) =>
            Int8List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.int16:
        return map((rowList) =>
                Int16List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.int32:
        return map((rowList) =>
                Int32List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.int64:
        return map((rowList) =>
                Int64List.fromList(rowList.map((e) => e.toInt()).toList()))
            .toList();
      case Typed.complex:
        assert(shape[1] == 2);
        return map((rowList) {
          var [r, i] = rowList;
          return Complex(real: r, imaginary: i);
        }).toList();
    }
  }

  void append(List<double> data, {bool horizontal = true}) {
    if (horizontal) {
      add([...data]);
      shape[0] += 1;
    } else {
      for (int r = 0; r < shape[0]; r++) {
        this[r].add(data[r]);
      }
      shape[1] += 1;
    }
  }

  List<double> row_(int index) {
    int row = shape[0];
    assert(index >= 0 && index < row);
    return [...this[index]];
  }

  List<double> column_(int index) {
    var [row, column] = shape;
    assert(index >= 0 && index < column);
    return List.generate(row, (r) => this[r][index]);
  }

  bool hasSameShape(List<List<double>> other) =>
      shape[0] == other.shape[0] && shape[1] == other.shape[1];

  static List<List<double>> constructor(List<List<num>> data) =>
      List.generate(data.length, (r) {
        return List.generate(data[r].length, (c) => data[r][c].toDouble());
      });

  List<List<double>> _abstractOperatorAny(int mode, Object other) {
    final List<List<double>> Function(
        {int dim,
        double? number,
        List<List<double>>? other}) func = switch (mode) {
      == 0 => addExtension,
      == 1 => minusExtension,
      == 2 => multiplyExtension,
      == 3 => divideExtension,
      _ => addExtension
    };
    if (other is List<List<double>>) {
      return func(other: other);
    } else if (other is num) {
      return func(number: other.toDouble());
    } else {
      throw ArgumentError('Unsupported type: ${other.runtimeType}');
    }
  }

  List<List<double>> _abstractOperatorMethod(int mode,
      {List<List<double>>? other, double? number, int dim = -1}) {
    assert(other != null || number != null);
    final double Function(double, double) func = _abstractOperator(mode);
    var [row, column] = shape;
    late final List<List<double>> data;
    if (other != null) {
      var [other_row, other_column] = other.shape;
      if (dim == 0) {
        assert(column == other_column && other_row == 1);
        data = List.generate(row,
            (r) => List.generate(column, (c) => func(this[r][c], other[0][c])));
      } else if (dim == 1) {
        assert(row == other_row && other_column == 1);
        data = List.generate(row,
            (r) => List.generate(column, (c) => func(this[r][c], other[r][0])));
      } else {
        assert(row == other_row && column == other_column);
        data = List.generate(row,
            (r) => List.generate(column, (c) => func(this[r][c], other[r][c])));
      }
    } else {
      number!;
      data = List.generate(
          row, (r) => List.generate(column, (c) => func(this[r][c], number)));
    }
    return data;
  }

  List<List<double>> concat(
      {required List<List<double>> other, bool horizontal = true}) {
    var [row, column] = shape;
    var [other_row, other_column] = other.shape;
    if (horizontal) {
      assert(row == other_row);
      return List.generate(row, (r) => [...this[r], ...other[r]]);
    } else {
      assert(column == other_column);
      return List.generate(row + other_row, (r) {
        return r < row ? [...this[r]] : [...other[r - row]];
      });
    }
  }

  List<List<double>> reshape({required int row, required int column}) {
    assert(row > 0 && row * column == size);
    var origin_column = shape[1];
    int index = 0;
    return List.generate(
        row,
        (_) => List.generate(column, (_) {
              var v = this[index ~/ origin_column][index % origin_column];
              index++;
              return v;
            }));
  }

  List<List<double>> resize(
      {required int row, required int column, double number = 0.0}) {
    assert(row > 0 && column > 0);
    final new_size = row * column;
    var [origin_row, origin_column] = shape;
    int index = 0;
    late final List<List<double>> data;
    if (new_size <= size) {
      data = List.generate(
          row,
          (_) => List.generate(column, (_) {
                var v = this[index ~/ origin_column][index % origin_column];
                index++;
                return v;
              }));
    } else {
      data = List.generate(
          row, (_) => List.filled(column, number, growable: true));
      for (int r = 0; r < origin_row; r++) {
        for (int c = 0; c < origin_column; c++) {
          data[index ~/ column][index % column] = this[r][c];
          index++;
        }
      }
    }
    return data;
  }

  List<List<double>> flatten({bool horizontal = true}) {
    if (horizontal) {
      return [expand((e) => e).toList()];
    } else {
      int row = shape[0];
      final data = [
        List.generate(size, (index) => this[index % row][index ~/ row])
      ];
      return data;
    }
  }

  List<List<double>> slice(
      {required int start, int? end, bool horizontal = true}) {
    var [row, column] = shape;
    if (horizontal) {
      end ??= row - 1;
      assert(start >= 0 && start < row && end >= 0 && end < row);
      int step = start <= end ? 1 : -1;
      int new_row = (start - end).abs() + 1;
      final data = List.generate(new_row, (r) {
        return [...this[start + step * r]];
      });
      return data;
    } else {
      end ??= column - 1;
      assert(start >= 0 && end >= 0 && start < column && end < column);
      final data = (start <= end)
          ? List.generate(row, (r) {
              return this[r].sublist(start, end! + 1);
            })
          : List.generate(row, (r) {
              return this[r].sublist(end!, start + 1).reversed.toList();
            });
      return data;
    }
  }

  List<List<double>> select(
      {required List<int> target, bool horizontal = true}) {
    var [row, column] = shape;
    var target_len = target.length;
    if (horizontal) {
      assert(target.min >= 0 && target.max < row);
      return List.generate(target_len, (r) => row_(target[r]));
    } else {
      assert(target.min >= 0 && target.max < column);
      return List.generate(row,
          (r) => List<double>.generate(target_len, (c) => this[r][target[c]]));
    }
  }

  List<List<double>> drop({required Set<int> target, bool horizontal = true}) {
    var [row, column] = shape;
    List<int> select_target =
        List.generate(horizontal ? row : column, (r) => r);
    for (var v in target) {
      select_target.remove(v);
    }
    return select(target: select_target, horizontal: horizontal);
  }

  void sortExtension({bool reverse = false, int dim = -1}) {
    var [row, column] = shape;
    if (dim == 0) {
      for (var list in this) {
        reverse
            ? list.sort((a, b) => b.compareTo(a))
            : list.sort((a, b) => a.compareTo(b));
      }
    } else if (dim == 1) {
      final transposed = transpose;
      for (int i = 0; i < column; i++) {
        reverse
            ? transposed[i].sort((a, b) => b.compareTo(a))
            : transposed[i].sort((a, b) => a.compareTo(b));
      }
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          this[r][c] = transposed[c][r];
        }
      }
    } else {
      final data = flattened;
      reverse
          ? data.sort((a, b) => b.compareTo(a))
          : data.sort((a, b) => a.compareTo(b));
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          this[r][c] = data[r * column + c];
        }
      }
    }
  }

  static List<List<double>> fill(
      {required double number, required int row, required int column}) {
    assert(row > 0 && column > 0);
    return List.generate(
        row, (_) => List<double>.filled(column, number, growable: true));
  }

  static List<List<double>> arrange(
      {double start = 0.0, required int row, required int column}) {
    int index = 0;
    final data = List.generate(
        row, (_) => List.generate(column, (_) => start + index++));
    return data;
  }

  static List<List<double>> linspace(
      {required double start,
      required double end,
      bool keep = true,
      required int row,
      required int column}) {
    assert(row > 0 && column > 0);
    final size = row * column;
    final step = keep ? (end - start) / (size - 1) : (end - start) / size;
    int index = 0;
    return List.generate(
        row, (_) => List.generate(column, (_) => start + index++ * step));
  }

  List<List<double>> _broadcastTo(int rows, int cols) {
    List<List<double>> newSelf = List.generate(rows, (i) {
      List<double> row = this[i % this.length];
      return List.generate(cols, (j) => row[j % row.length]);
    });
    return newSelf;
  }

  static List<List<List<double>>> broadcast(List<List<List<double>>> mts) {
    assert(mts.length > 1);
    int maxRows = 0;
    int maxCols = 0;
    for (var m in mts) {
      maxRows = maxRows > m.shape[0] ? maxRows : m.shape[0];
      maxCols = maxCols > m.shape[1] ? maxCols : m.shape[1];
    }
    List<List<List<double>>> result = [];
    for (var m in mts) {
      int rows = m.shape[0];
      int cols = m.shape[1];
      bool rowsOk = (rows == maxRows) || (rows == 1);
      bool colsOk = (cols == maxCols) || (cols == 1);
      if (!rowsOk || !colsOk) {
        throw Exception(
            'Matrix shape ${m.shape} cannot be broadcast to [$maxRows, $maxCols]');
      }
      result.add(m._broadcastTo(maxRows, maxCols));
    }
    return result;
  }

  static List<List<double>> range(
      {double start = 0.0,
      double step = 1.0,
      required int row,
      required int column}) {
    assert(row > 0 && column > 0);
    int index = 0;
    final data = List.generate(
        row, (_) => List.generate(column, (_) => start + index++ * step));
    return data;
  }

  static List<List<double>> E({required int n}) {
    assert(n > 0);
    final data = List.generate(
      n,
      (i) => List.filled(n, 0.0, growable: true),
    );
    for (int i = 0; i < n; i++) {
      data[i][i] = 1;
    }
    return data;
  }

  static List<List<double>> ELike({required int row, required int column}) {
    assert(row > 0 && column > 0);
    final data = List.generate(
      row,
      (i) => List.filled(column, 0.0, growable: true),
    );
    for (int i = 0; i < math.min(row, column); i++) {
      data[i][i] = 1;
    }
    return data;
  }

  /// ----------------------------------------operator-------------------------------------------
  List<List<double>> operator ^(num number) =>
      map((row_list) => row_list.map((e) => _powDouble(e, number)).toList())
          .toList();

  List<List<double>> operator +(Object other) => _abstractOperatorAny(0, other);
  List<List<double>> operator -(Object other) => _abstractOperatorAny(1, other);
  List<List<double>> operator *(Object other) => _abstractOperatorAny(2, other);
  List<List<double>> operator /(Object other) => _abstractOperatorAny(3, other);

  bool operator >(Object other) {
    if (identical(this, other)) return false;
    if (other is List<List<double>>) {
      final data = compareExtension(other: other, which: 0);
      for (var list in data) {
        if (list.contains(false)) {
          return false;
        }
      }
      return true;
    } else if (other is num) {
      return !(anyExtension((x) => x <= other, dim: -1) as bool);
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  bool operator >=(Object other) {
    if (identical(this, other)) return true;
    if (other is List<List<double>>) {
      final data = compareExtension(other: other, which: 2);
      for (var list in data) {
        if (list.contains(false)) {
          return false;
        }
      }
      return true;
    } else if (other is num) {
      return !(anyExtension((x) => x < other, dim: -1) as bool);
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  bool operator <(Object other) {
    if (identical(this, other)) return false;
    if (other is List<List<double>>) {
      final data = compareExtension(other: other, which: 1);
      for (var list in data) {
        if (list.contains(false)) {
          return false;
        }
      }
      return true;
    } else if (other is num) {
      return !(anyExtension((x) => x >= other, dim: -1) as bool);
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  bool operator <=(Object other) {
    if (identical(this, other)) return true;
    if (other is List<List<double>>) {
      final data = compareExtension(other: other, which: 3);
      for (var list in data) {
        if (list.contains(false)) {
          return false;
        }
      }
      return true;
    } else if (other is num) {
      return !(anyExtension((x) => x > other, dim: -1) as bool);
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  /// -------------------------------------------------------------------------------

  /// -------------------------------Math--------------------------------------------

  List<List<double>> powerExtension(
          {required double number, bool reverse = false}) =>
      _mathBasementDoubleRealize(0, number: number, reverse: reverse);

  List<List<double>> atan2Extension(
          {required double number, bool reverse = false}) =>
      _mathBasementDoubleRealize(1, number: number, reverse: reverse);

  List<List<double>> get sinExtension => _mathBasementSingleRealize(0);
  List<List<double>> get cosExtension => _mathBasementSingleRealize(1);
  List<List<double>> get tanExtension => _mathBasementSingleRealize(2);
  List<List<double>> get asinExtension => _mathBasementSingleRealize(3);
  List<List<double>> get acosExtension => _mathBasementSingleRealize(4);
  List<List<double>> get atanExtension => _mathBasementSingleRealize(5);
  List<List<double>> get sinhExtension => _mathBasementSingleRealize(6);
  List<List<double>> get coshExtension => _mathBasementSingleRealize(7);
  List<List<double>> get tanhExtension => _mathBasementSingleRealize(8);
  List<List<double>> get asinhExtension => _mathBasementSingleRealize(9);
  List<List<double>> get acoshExtension => _mathBasementSingleRealize(10);
  List<List<double>> get atanhExtension => _mathBasementSingleRealize(11);
  List<List<double>> get expExtension => _mathBasementSingleRealize(12);
  List<List<double>> get logExtension => _mathBasementSingleRealize(13);
  List<List<double>> get sqrtExtension => _mathBasementSingleRealize(14);
  List<List<double>> get log10Extension => _mathBasementSingleRealize(15);
  List<List<double>> get squareExtension => _mathBasementSingleRealize(16);
  List<List<double>> get cubeExtension => _mathBasementSingleRealize(17);
  List<List<double>> get absExtension => _mathBasementSingleRealize(18);
  List<List<double>> get ceilExtension => _mathBasementSingleRealize(19);
  List<List<double>> get floorExtension => _mathBasementSingleRealize(20);
  List<List<double>> get roundExtension => _mathBasementSingleRealize(21);
  List<List<double>> get degreeExtension => _mathBasementSingleRealize(22);
  List<List<double>> get radianExtension => _mathBasementSingleRealize(23);

  List<List<double>> addExtension(
          {List<List<double>>? other, double? number, int dim = -1}) =>
      _abstractOperatorMethod(0, other: other, number: number, dim: dim);

  List<List<double>> minusExtension(
          {List<List<double>>? other, double? number, int dim = -1}) =>
      _abstractOperatorMethod(1, other: other, number: number, dim: dim);

  List<List<double>> multiplyExtension(
          {List<List<double>>? other, double? number, int dim = -1}) =>
      _abstractOperatorMethod(2, other: other, number: number, dim: dim);

  List<List<double>> divideExtension(
          {List<List<double>>? other, double? number, int dim = -1}) =>
      _abstractOperatorMethod(3, other: other, number: number, dim: dim);

  static List<T> _selectEveryNth<T>(List<T> list, int step, int from) {
    return [for (int i = from; i < list.length; i += step) list[i]];
  }

  static List<Complex> _fft(
      {required List<List<double>> mt_this, required List<int> mt_shape}) {
    var [row, column] = mt_shape;
    if (row <= 1) {
      var [r, i] = mt_this[0];
      return [Complex(real: r, imaginary: i)];
    }
    List<Complex> even =
        _fft(mt_this: _selectEveryNth(mt_this, 2, 0), mt_shape: [row ~/ 2, 2]);
    List<Complex> odd =
        _fft(mt_this: _selectEveryNth(mt_this, 2, 1), mt_shape: [row ~/ 2, 2]);
    List<Complex> T = List.generate(row ~/ 2, (r) {
      var omega = Complex.fromPolar(r: 1, theta: -2 * math.pi * r / row);
      return omega * odd[r];
    });
    return List.generate(row, (r) {
      return r < row ~/ 2
          ? even[r] + T[r]
          : even[r - row ~/ 2] - T[r - row ~/ 2];
    });
  }

  Object sumExtension({int dim = -1}) {
    if (dim == 0) {
      return reduceExtension((x, y) => x + y, dim: 0);
    } else if (dim == 1) {
      return reduceExtension((x, y) => x + y, dim: 1);
    } else {
      return reduceExtension((x, y) => x + y, dim: -1);
    }
  }

  Object minExtension({int dim = -1}) {
    if (dim == 0) {
      return List.generate(shape[0], (r) => this[r].min);
    } else if (dim == 1) {
      return List.generate(shape[1], (c) => column_(c).min);
    } else {
      return List.generate(shape[0], (r) => this[r].min).min;
    }
  }

  Object maxExtension({int dim = -1}) {
    if (dim == 0) {
      return List.generate(shape[0], (r) => this[r].max);
    } else if (dim == 1) {
      return List.generate(shape[1], (c) => column_(c).max);
    } else {
      return List.generate(shape[0], (r) => this[r].max).max;
    }
  }

  Object _argMinMax(bool isMin, {int dim = -1}) {
    var _min_max = isMin ? minExtension(dim: dim) : maxExtension(dim: dim);
    if (dim == 0) {
      _min_max as List<double>;
      return List.generate(shape[0], (r) => this[r].indexOf(_min_max[r]));
    } else if (dim == 1) {
      _min_max as List<double>;
      return List.generate(shape[1], (c) => column_(c).indexOf(_min_max[c]));
    } else {
      _min_max as double;
      var [row, column] = shape;
      for (int r = 0; r < row; r++) {
        var v = this[r].indexOf(_min_max);
        if (v != -1) {
          return v + column * r;
        }
      }
      return -1; // Never gonna get here!
    }
  }

  Object argmin({int dim = -1}) => _argMinMax(true, dim: dim);
  Object argmax({int dim = -1}) => _argMinMax(false, dim: dim);

  Object getRangeExtension({int dim = -1}) {
    if (dim == 0) {
      return List.generate(shape[0], (r) {
        final row_list = this[r];
        return Range(
            start: row_list.min, end: row_list.max, closure_right: true);
      });
    } else if (dim == 1) {
      return List.generate(shape[1], (c) {
        final column_list = column_(c);
        return Range(
            start: column_list.min, end: column_list.max, closure_right: true);
      });
    } else {
      return Range(
          start: minExtension() as double,
          end: maxExtension() as double,
          closure_right: true);
    }
  }

  List<List<double>> diff(double Function(double) func) {
    return map((row_list) => row_list.map((x) => diffCentral(x, func)).toList())
        .toList();
  }

  List<List<double>> dftComplex() {
    var [row, column] = shape;
    assert(column == 2);
    List<List<double>> data = [];
    for (int k = 0; k < row; k++) {
      Complex complex = Complex();
      for (int n = 0; n < row; n++) {
        double angle = -2 * math.pi * k * n / row;
        var [real, imaginary] = this[n];
        complex = complex +
            Complex(real: real, imaginary: imaginary) *
                Complex(real: 0.0, imaginary: angle).exp;
      }
      data.add(complex.toList);
    }
    return data;
  }

  List<List<double>> fftComplex() {
    var [row, column] = shape;
    assert((row & (row - 1) == 0) && row >= 2 && column == 2);
    return _fft(mt_this: this, mt_shape: shape)
        .map((complex) => complex.toList)
        .toList();
  }

  List<List<double>> toComplexLike([bool isReal = true]) {
    var [row, column] = shape;
    List<List<double>> data = [];
    if (isReal) {
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          data.add([this[r][c], 0.0]);
        }
      }
    } else {
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          data.add([0.0, this[r][c]]);
        }
      }
    }
    return data;
  }

  List<List<Complex>> dft() {
    var [rows, cols] = shape;
    List<List<Complex>> result = [];
    for (int u = 0; u < rows; u++) {
      List<Complex> ls = [];
      for (int v = 0; v < cols; v++) {
        Complex sum = Complex();
        for (int x = 0; x < rows; x++) {
          for (int y = 0; y < cols; y++) {
            double angle = -2 * math.pi * ((u * x / rows) + (v * y / cols));
            Complex exponent = Complex(imaginary: angle).exp;
            sum += exponent * Complex(real: this[x][y]);
          }
        }
        ls.add(sum);
      }
      result.add(ls);
    }
    return result;
  }

  List<List<double>> get sgn =>
      map((row) => row.map((c) => c.sign).toList()).toList();

  /// ------------------------------------------------------------------------------------
  /// -------------------------------Functool--------------------------------------------
  List<List<double>> customize(double Function(double) condition) {
    return map((row_list) => row_list.map((e) => condition(e)).toList())
        .toList();
  }

  List<List<double>> confront(double Function(double, double) condition,
      {required List<List<double>> other}) {
    assert(hasSameShape(other));
    var [row, column] = shape;
    return List.generate(
        row,
        (r) => List<double>.generate(
            column, (c) => condition(this[r][c], other[r][c])));
  }

  List<List<double>> clip(double Function(double) condition,
      {required double lb, required double ub, bool reverse = false}) {
    assert(lb <= ub);
    var [row, column] = shape;
    final data = !reverse
        ? List.generate(
            row,
            (r) => List.generate(column, (c) {
                  double v = this[r][c];
                  if (v < lb || v > ub) {
                    v = condition(v);
                  }
                  return v;
                }))
        : List.generate(
            row,
            (r) => List.generate(column, (c) {
                  double v = this[r][c];
                  if (lb < v && v < ub) {
                    v = condition(v);
                  }
                  return v;
                }));
    return data;
  }

  Object reduceExtension(double Function(double, double) condition,
      {double? element, int dim = -1}) {
    var [row, column] = shape;
    if (dim == 0) {
      return List.generate(row, (r) {
        final list = element == null ? this[r] : [element, ...this[r]];
        return list.reduce(condition);
      });
    } else if (dim == 1) {
      return List.generate(column, (c) {
        final list = element == null ? column_(c) : [element, ...column_(c)];
        return list.reduce(condition);
      });
    } else {
      if (element == null) {
        return List.generate(row, (r) => this[r].reduce(condition))
            .reduce(condition);
      }
      var v = this[0][0];
      this[0][0] = condition(element, v);
      final result = List.generate(row, (r) => this[r].reduce(condition))
          .reduce(condition);
      this[0][0] = v;
      return result;
    }
  }

  Object anyExtension(bool Function(double) condition, {int dim = -1}) {
    if (dim == 0) {
      return List.generate(shape[0], (r) => this[r].any(condition));
    } else if (dim == 1) {
      return List.generate(shape[1], (c) => column_(c).any(condition));
    } else {
      return List.generate(shape[0], (r) => this[r].any(condition))
          .contains(true);
    }
  }

  Object allExtension(bool Function(double) conditon, {int dim = -1}) {
    if (dim == 0) {
      return List.generate(shape[0], (r) => this[r].every(conditon));
    } else if (dim == 1) {
      return List.generate(shape[1], (c) => column_(c).every(conditon));
    } else {
      return List.generate(shape[0], (r) => this[r].every(conditon))
          .every((e) => e);
    }
  }

  List<BoolList> compareExtension(
      {required List<List<double>> other, int which = -1}) {
    assert(hasSameShape(other));
    var [row, column] = shape;
    switch (which) {
      case 0:
        return List.generate(row,
            (r) => BoolList.generate(column, (c) => this[r][c] > other[r][c]));
      case 1:
        return List.generate(row,
            (r) => BoolList.generate(column, (c) => this[r][c] < other[r][c]));
      case 2:
        return List.generate(row,
            (r) => BoolList.generate(column, (c) => this[r][c] >= other[r][c]));
      case 3:
        return List.generate(row,
            (r) => BoolList.generate(column, (c) => this[r][c] <= other[r][c]));
      case 4:
        return List.generate(row,
            (r) => BoolList.generate(column, (c) => this[r][c] != other[r][c]));
      default:
        return List.generate(row,
            (r) => BoolList.generate(column, (c) => this[r][c] == other[r][c]));
    }
  }

  void replaceExtension(bool Function(double) condition,
      {required double Function(double) cope}) {
    for (var list in this) {
      for (int c = 0; c < shape[1]; c++) {
        var v = list[c];
        if (condition(v)) {
          list[c] = cope(v);
        }
      }
    }
  }

  Object countExtension(bool Function(double) condition, {int dim = -1}) {
    if (dim == 0) {
      return List.generate(shape[0], (r) {
        int c = 0;
        for (var v in this[r]) {
          if (condition(v)) {
            c++;
          }
        }
        return c;
      });
    } else if (dim == 1) {
      return List.generate(shape[1], (c) {
        int v = 0;
        for (int r = 0; r < shape[0]; r++) {
          if (condition(this[r][c])) {
            v++;
          }
        }
        return v;
      });
    } else {
      int c = 0;
      this.forEach((list) {
        for (var v in list) {
          if (condition(v)) {
            c++;
          }
        }
      });
      return c;
    }
  }

  /// ------------------------------------------------------------------------------------

  /// -------------------------------Linalg--------------------------------------------
  List<List<double>> get transpose =>
      _transpose(mt_this: this, mt_shape: shape);
  List<List<double>> get T_ => transpose;

  double get det => _det(mt_this: this, mt_shape: shape);
  List<List<double>> get rref => _rref(mt_this: this, mt_shape: shape);
  double get trace {
    double sums = 0.0;
    for (int i = 0; i < math.min(shape[0], shape[1]); i++) {
      sums += this[i][i];
    }
    return sums;
  }

  List<List<double>> coincidental({required int row, required int column}) =>
      _coincidental(row: row, column: column, mt_shape: shape, mt_this: this);

  void elementaryExchange(
      {required int index1, required int index2, bool horizontal = true}) {
    var [row, column] = shape;
    if (horizontal) {
      assert(index1 >= 0 && index2 >= 0 && index1 < row && index2 < row);
      swap(index1, index2);
    } else {
      assert(index1 >= 0 && index2 >= 0 && index1 < column && index2 < column);
      for (int r = 0; r < row; r++) {
        var v = this[r][index1];
        this[r][index1] = this[r][index2];
        this[r][index2] = v;
      }
    }
  }

  void elementaryMultiply(
      {required int index, required double number, bool horizontal = true}) {
    var [row, column] = shape;
    if (horizontal) {
      assert(index >= 0 && index < row);
      for (int c = 0; c < column; c++) {
        this[index][c] *= number;
      }
    } else {
      assert(index >= 0 && index < column);
      for (int r = 0; r < row; r++) {
        this[r][index] *= number;
      }
    }
  }

  void elementaryAdd(
      {required int index1,
      required int index2,
      required double number,
      bool horizontal = true}) {
    var [row, column] = shape;
    if (horizontal) {
      assert(index1 >= 0 && index2 >= 0 && index1 < row && index2 < row);
      for (int c = 0; c < column; c++) {
        this[index1][c] += this[index2][c] * number;
      }
    } else {
      assert(index1 >= 0 && index1 < column && index2 >= 0 && index2 < column);
      for (int r = 0; r < row; r++) {
        this[r][index1] += this[r][index2] * number;
      }
    }
  }

  List<List<double>> product({required List<List<double>> other}) {
    var [row, column] = shape;
    var [other_row, other_column] = other.shape;
    assert(column == other_row);
    final data = List.generate(
        row, (i) => List.filled(other_column, 0.0, growable: true));
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < other_column; j++) {
        var sum = 0.0;
        for (var k = 0; k < column; k++) {
          sum += this[i][k] * other[k][j];
        }
        data[i][j] = sum;
      }
    }
    return data;
  }

  List<List<double>> kronecker({required List<List<double>> other}) {
    var [row, column] = shape;
    var [other_row, other_column] = other.shape;

    var data = List.generate(row * other_row,
        (i) => List.filled(column * other_column, 0.0, growable: true));

    int result_row, result_column;
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < column; j++) {
        for (var k = 0; k < other_row; k++) {
          for (var l = 0; l < other_column; l++) {
            result_row = i * other_row + k;
            result_column = j * other_column + l;
            data[result_row][result_column] = this[i][j] * other[k][l];
          }
        }
      }
    }
    return data;
  }

  List<List<double>> get adjugate {
    assert(isSquare);
    int n = shape[0];
    final data = List.generate(n, (r) => List.filled(n, 0.0, growable: true));
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        final cof =
            _coincidental(row: r, column: c, mt_this: this, mt_shape: [n, n]);
        data[c][r] = ((r + c) % 2 == 0 ? 1 : -1) *
            _det(mt_shape: [n - 1, n - 1], mt_this: cof);
      }
    }
    return data;
  }

  List<List<double>> get inverse {
    final adj = adjugate;
    int n = shape[0];
    double detV = det;
    assert(detV.abs() > tolerance_round.abs());

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        adj[r][c] /= detV;
      }
    }
    return adj;
  }

  int get rank {
    final rref_list = rref;
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
      if (isZeroRow == 0) {
        counter++;
      }
    }
    return counter;
  }

  /// ------------------------------------------------------------------------------------

  /// --------------------------------Geometry--------------------------------------------
  static List<List<double>> curve(
      {required double Function(double) func,
      required double x1,
      required double x2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    assert(size >= 2 && vec.length == 2);
    final random = math.Random(seed);
    bias ??= 0.0;
    bias = bias.abs();
    var [offset_x, offset_y] = vec;
    if (uniform) {
      double delta = (x2 - x1) / (size - 1);
      return List.generate(size, (r) {
        double x = x1 + r * delta;
        double y = random.nextBool()
            ? func(x) + random.nextDouble() * bias!
            : func(x) - random.nextDouble() * bias!;
        return <double>[x + offset_x, y + offset_y];
      });
    } else {
      double gap = x2 - x1;
      return List.generate(size, (r) {
        double x = x1 + random.nextDouble() * gap;
        double y = random.nextBool()
            ? func(x) + random.nextDouble() * bias!
            : func(x) - random.nextDouble() * bias!;
        return <double>[x + offset_x, y + offset_y];
      });
    }
  }

  static List<List<double>> custom_curve(
      {required double Function(double) xfunc,
      required double Function(double) yfunc,
      required double theta_from,
      required double theta_to,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    assert(size >= 2);
    final random = math.Random(seed);
    bias ??= 0.0;
    bias = bias.abs();
    var [offset_x, offset_y] = vec;
    if (uniform) {
      double delta = (theta_to - theta_from) / (size - 1);
      return List.generate(size, (r) {
        double theta = theta_from + delta * r;
        double x = xfunc(theta);
        double y = random.nextBool()
            ? yfunc(theta) + random.nextDouble() * bias!
            : yfunc(theta) - random.nextDouble() * bias!;
        return <double>[x + offset_x, y + offset_y];
      });
    } else {
      double gap = theta_to - theta_from;
      return List.generate(size, (r) {
        double theta = theta_from + random.nextDouble() * gap;
        double x = xfunc(theta);
        double y = random.nextBool()
            ? yfunc(theta) + random.nextDouble() * bias!
            : yfunc(theta) - random.nextDouble() * bias!;
        return <double>[x + offset_x, y + offset_y];
      });
    }
  }

  static List<List<double>> ellipse_edge(
      {required double a,
      required double b,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    assert(a > 0 && b > 0);
    return MatrixExtension.custom_curve(
        xfunc: (t) => a * math.cos(t),
        yfunc: (t) => b * math.sin(t),
        theta_from: 0.0,
        theta_to: 2.0 * math.pi,
        size: size,
        vec: vec);
  }

  static List<List<double>> circle_edge(
          {required double r,
          required int size,
          int? seed,
          double? bias,
          bool uniform = true,
          List<double> vec = OriginVector}) =>
      MatrixExtension.ellipse_edge(
          a: r,
          b: r,
          size: size,
          seed: seed,
          bias: bias,
          uniform: uniform,
          vec: vec);

  static List<List<double>> ellipse_area(
      {required double a,
      required double b,
      required int size,
      int? seed,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    assert(size >= 2 && vec.length == 2);
    final random = math.Random(seed);
    var [offset_x, offset_y] = vec;
    if (uniform) {
      return List.generate(size, (i) {
        double theta = 2 * math.pi * i / size;
        double x = a * math.cos(theta) * random.nextDouble();
        double y = b * math.sin(theta) * random.nextDouble();
        return <double>[x + offset_x, y + offset_y];
      });
    } else {
      return List.generate(size, (_) {
        double theta = random.nextDouble() * 2 * math.pi;
        double x = a * math.cos(theta) * random.nextDouble();
        double y = b * math.sin(theta) * random.nextDouble();
        return <double>[x + offset_x, y + offset_y];
      });
    }
  }

  static List<List<double>> circle_area(
          {required double r,
          required int size,
          int? seed,
          bool uniform = true,
          List<double> vec = OriginVector}) =>
      MatrixExtension.ellipse_area(
          a: r, b: r, size: size, seed: seed, uniform: uniform, vec: vec);

  static List<List<double>> line(
          {required double k,
          required double b,
          required double x1,
          required double x2,
          required int size,
          int? seed,
          double? bias,
          bool uniform = true,
          List<double> vec = OriginVector}) =>
      MatrixExtension.curve(
          func: (x) => k * x + b,
          x1: x1,
          x2: x2,
          size: size,
          seed: seed,
          uniform: uniform,
          vec: vec,
          bias: bias);

  static List<List<double>> xline(
          {required double a,
          required double x1,
          required double x2,
          required int size,
          int? seed,
          double? bias,
          bool uniform = true,
          List<double> vec = OriginVector}) =>
      MatrixExtension.curve(
          func: (_) => a,
          x1: x1,
          x2: x2,
          size: size,
          seed: seed,
          bias: bias,
          uniform: uniform,
          vec: vec);

  static List<List<double>> yline(
          {required double a,
          required double y1,
          required double y2,
          required int size,
          int? seed,
          double? bias,
          bool uniform = true,
          List<double> vec = OriginVector}) =>
      MatrixExtension.custom_curve(
          xfunc: (_) => a,
          yfunc: (theta) => theta,
          theta_from: y1,
          theta_to: y2,
          size: size,
          seed: seed,
          bias: bias,
          uniform: uniform,
          vec: vec);

  List<List<double>> rotateTransform(
      {required double theta, bool radian = true}) {
    assert(shape[1] == 2);
    if (!radian) {
      theta = theta * (math.pi / 180.0);
    }
    double C = math.cos(theta), S = math.sin(theta);
    return map((list) {
      var [x, y] = list;
      return <double>[C * x - S * y, S * x + C * y];
    }).toList();
  }

  List<List<double>> projectTransform(
      {required double ux, required double uy}) {
    assert(shape[1] == 2);
    double delta11 = ux * ux, delta12 = ux * uy;
    double delta21 = delta12, delta22 = uy * uy;
    return map((list) {
      var [x, y] = list;
      return <double>[delta11 * x + delta12 * y, delta21 * x + delta22 * y];
    }).toList();
  }

  List<List<double>> shearTransform({required double k, bool alongX = true}) {
    assert(shape[1] == 2);
    return alongX
        ? map((list) {
            var [x, y] = list;
            return <double>[x + k * y, y];
          }).toList()
        : map((list) {
            var [x, y] = list;
            return <double>[x, y + x * k];
          }).toList();
  }

  List<List<double>> scaleTransform({required double sx, required double sy}) {
    assert(shape[1] == 2);
    return map((list) => <double>[list[0] * sx, list[1] * sy]).toList();
  }

  static List<List<double>> camera({
    required List<double> eye,
    required List<List<double>> target,
    required double a,
    required double b,
    required double c,
    required double d,
  }) {
    assert(eye.length == 3 && target.isNotEmpty && target[0].length == 3);
    final [ex, ey, ez] = eye;
    List<List<double>> projections = [];
    for (var p in target) {
      final [px, py, pz] = p;
      final vx = px - ex;
      final vy = py - ey;
      final vz = pz - ez;
      double numerator = -(a * ex + b * ey + c * ez + d);
      double denominator = a * vx + b * vy + c * vz;
      if (denominator.abs() <= tolerance_round) {
        projections.add([ex, ey, ez]);
        continue;
      }
      double t = numerator / denominator;
      double qx = ex + t * vx;
      double qy = ey + t * vy;
      double qz = ez + t * vz;

      projections.add([qx, qy, qz]);
    }
    return projections;
  }

  /// -------------------------------------------------------------------------------
  /// ----------------------------------------ML------------------------------------
  List<List<double>> Softmax({int dim = -1}) {
    var [row, column] = shape;
    late List<List<double>> ls;
    if (dim == 0) {
      ls = [];
      this.forEach((list) {
        List<double> inner = [];
        double sums = 0;
        list.forEach((x) {
          double v = math.exp(x);
          inner.add(v);
          sums += v;
        });
        ls.add(inner.map((e) => e / sums).toList());
      });
    } else if (dim == 1) {
      ls = List.generate(row, (_) => List.filled(column, 0.0, growable: true));
      for (int c = 0; c < column; c++) {
        double sums = 0;
        List<double> inner = [];
        for (int r = 0; r < row; r++) {
          double v = math.exp(this[r][c]);
          inner.add(v);
          sums += v;
        }
        for (int r = 0; r < row; r++) {
          ls[r][c] = inner[r] / sums;
        }
      }
    } else {
      ls = [];
      double sums = 0, v;
      this.forEach((list) {
        List<double> inner = [];
        list.forEach((x) {
          v = math.exp(x);
          inner.add(v);
          sums += v;
        });
        ls.add(inner);
      });
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          ls[r][c] /= sums;
        }
      }
    }
    return ls;
  }

  List<List<double>> LeakyReLU({double alpha = 0.01}) {
    var [row, column] = shape;
    return List.generate(
        row,
        (r) => List.generate(column, (c) {
              double v = this[r][c];
              return v > 0 ? v : alpha * v;
            }));
  }

  List<List<double>> ReLU() => LeakyReLU(alpha: 0.0);

  List<List<double>> Sigmoid() {
    var [row, column] = shape;
    return List.generate(
        row,
        (r) =>
            List.generate(column, (c) => 1.0 / (1.0 + math.exp(-this[r][c]))));
  }

  List<List<double>> ELU({required double alpha}) {
    var [row, column] = shape;
    return List.generate(
        row,
        (r) => List.generate(column, (c) {
              double v = this[r][c];
              return v > 0 ? v : alpha * (math.exp(v) - 1);
            }));
  }

  List<List<double>> Swish() {
    var [row, column] = shape;
    return List.generate(
        row,
        (r) => List.generate(column, (c) {
              double v = this[r][c];
              return v / (1.0 + math.exp(-v));
            }));
  }

  List<List<double>> Softsign() {
    var [row, column] = shape;
    return List.generate(
        row,
        (r) => List.generate(column, (c) {
              double v = this[r][c];
              return v / (1.0 + v.abs());
            }));
  }

  List<List<double>> Softplus() {
    var [row, column] = shape;
    return List.generate(
        row,
        (r) => List.generate(column, (c) {
              return math.log(1 + math.exp(this[r][c]));
            }));
  }

  Object MAE({required List<List<double>> other, int dim = -1}) {
    assert(hasSameShape(other));
    var [row, column] = shape;
    if (dim == 0) {
      return List.generate(row, (r) {
        double sum = 0;
        for (int c = 0; c < column; c++) {
          sum += (this[r][c] - other[r][c]).abs();
        }
        return sum / column;
      });
    } else if (dim == 1) {
      return List.generate(column, (c) {
        double sum = 0;
        for (int r = 0; r < row; r++) {
          sum += (this[r][c] - other[r][c]).abs();
        }
        return sum / row;
      });
    } else {
      double sums = 0;
      for (int c = 0; c < column; c++) {
        for (int r = 0; r < row; r++) {
          sums += (this[r][c] - other[r][c]).abs();
        }
      }
      return sums / (row * column);
    }
  }

  Object MSE({required List<List<double>> other, int dim = -1}) {
    assert(hasSameShape(other));
    var [row, column] = shape;
    double v;
    if (dim == 0) {
      return List.generate(row, (r) {
        double sum = 0;
        for (int c = 0; c < column; c++) {
          v = this[r][c] - other[r][c];
          sum += v * v;
        }
        return sum / column;
      });
    } else if (dim == 1) {
      return List.generate(column, (c) {
        double sum = 0;
        for (int r = 0; r < row; r++) {
          v = this[r][c] - other[r][c];
          sum += v * v;
        }
        return sum / row;
      });
    } else {
      double sums = 0;
      for (int c = 0; c < column; c++) {
        for (int r = 0; r < row; r++) {
          v = this[r][c] - other[r][c];
          sums += v * v;
        }
      }
      return sums / (row * column);
    }
  }

  /// ----------------------------------------------------------------------------
  /// ---------------------------------Random-------------------------------------
  void shuffleExtension({int? seed, int dim = -1}) {
    var random = math.Random(seed);
    var [row, column] = shape;
    if (dim == 0) {
      this.forEach((row_list) {
        row_list.shuffle(random);
      });
    } else if (dim == 1) {
      final transposed = transpose;
      transposed.forEach((list) {
        list.shuffle(random);
      });
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          this[r][c] = transposed[c][r];
        }
      }
    } else {
      final data = flattened..shuffle(random);
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          this[r][c] = data[r * column + c];
        }
      }
    }
  }

  Object meanExtension({int dim = -1}) {
    var [row, column] = shape;
    if (dim == 0) {
      final list = sumExtension(dim: 0) as List<double>;
      return List.generate(row, (r) => list[r] / column);
    } else if (dim == 1) {
      final list = sumExtension(dim: 1) as List<double>;
      return List.generate(column, (c) => list[c] / row);
    } else {
      return (sumExtension(dim: -1) as double) / size;
    }
  }

  Object medianExtension({int dim = -1}) {
    var [row, column] = shape;
    if (dim == 0) {
      return column.isOdd
          ? List.generate(row, (r) {
              final list = [...this[r]]..sort();
              return list[column ~/ 2];
            })
          : List.generate(row, (r) {
              final list = [...this[r]]..sort();
              return (list[column ~/ 2] + list[column ~/ 2 - 1]) / 2;
            });
    } else if (dim == 1) {
      return row.isOdd
          ? List.generate(column, (r) {
              final list = column_(r)..sort();
              return list[row ~/ 2];
            })
          : List.generate(column, (r) {
              final list = column_(r)..sort();
              return (list[row ~/ 2] + list[row ~/ 2 - 1]) / 2;
            });
    } else {
      if (size.isOdd) {
        return (List.generate(
            size, (index) => this[index ~/ column][index % column])
          ..sort())[size ~/ 2];
      } else {
        final target = List.generate(
            size, (index) => this[index ~/ column][index % column])
          ..sort();
        return (target[size ~/ 2] + target[size ~/ 2 - 1]) / 2;
      }
    }
  }

  dynamic modeExtension({int dim = -1}) {
    var [row, column] = shape;
    late Map<Object, int> dict;

    final _allEqual = (Iterable<int> values) => values.toSet().length == 1;
    if (dim == 0) {
      List<Object?> result = [];
      for (var list in this) {
        dict = {};
        for (var e in list) {
          dict[e] = (dict[e] ?? 0) + 1;
        }
        if (_allEqual(dict.values)) {
          result.add(null);
        } else {
          var maxCount = dict.values.reduce((a, b) => a > b ? a : b);
          result.add(dict.keys.firstWhere((key) => dict[key] == maxCount));
        }
      }
      return result;
    } else if (dim == 1) {
      List<Object?> result = [];
      for (int col = 0; col < column; col++) {
        dict = {};
        for (int rowIndex = 0; rowIndex < row; rowIndex++) {
          var element = this[rowIndex][col];
          dict[element] = (dict[element] ?? 0) + 1;
        }
        if (_allEqual(dict.values)) {
          result.add(null);
        } else {
          var maxCount = dict.values.reduce((a, b) => a > b ? a : b);
          result.add(dict.keys.firstWhere((key) => dict[key] == maxCount));
        }
      }
      return result;
    } else {
      dict = {};
      for (var list in this) {
        for (var e in list) {
          dict[e] = (dict[e] ?? 0) + 1;
        }
      }
      if (_allEqual(dict.values)) {
        return null;
      } else {
        var maxCount = dict.values.reduce((a, b) => a > b ? a : b);
        return dict.keys.firstWhere((key) => dict[key] == maxCount);
      }
    }
  }

  void shakeTotal({double bias = 1.0, int? seed}) {
    bias = bias.abs();
    if (bias != 0.0) {
      final random = math.Random(seed);
      this.forEach((list) {
        for (int c = 0; c < shape[1]; c++) {
          random.nextBool()
              ? list[c] += bias * random.nextDouble()
              : list[c] -= bias * random.nextDouble();
        }
      });
    }
  }

  void shakePercent({double bias = 1.0, double percent = 0.5, int? seed}) {
    assert(percent > 0 && percent <= 1);
    bias = bias.abs();
    if (bias != 0.0) {
      final random = math.Random(seed);
      final indices = choose(
          list: List.generate(size, (r) => r),
          n: (size * percent).round(),
          m: size,
          back: false,
          seed: seed);
      int column = shape[1];
      for (var index in indices) {
        final r = index ~/ column;
        final c = index % column;
        random.nextBool()
            ? this[r][c] += bias * random.nextDouble()
            : this[r][c] -= bias * random.nextDouble();
      }
    }
  }

  void shakeProbably({double bias = 1.0, double p = 0.5, int? seed}) {
    assert(p > 0 && p <= 1);
    bias = bias.abs();
    if (bias != 0.0) {
      final random = math.Random(seed);
      int column = shape[1];
      for (var list in this) {
        for (int c = 0; c < column; c++) {
          if (random.nextDouble() <= p) {
            random.nextBool()
                ? list[c] += bias * random.nextDouble()
                : list[c] -= bias * random.nextDouble();
          }
        }
      }
    }
  }

  static List<List<double>> uniform(
      {double lb = 0.0,
      double ub = 1.0,
      required int row,
      required int column,
      int? seed}) {
    assert(lb < ub && row > 0 && column > 0);
    final random = math.Random(seed);
    double gap = ub - lb;
    return List.generate(
        row,
        (_) => List<double>.generate(
            column, (_) => lb + gap * random.nextDouble()));
  }

  static List<List<double>> normal(
      {double mu = 0.0,
      double sigma = 1.0,
      required int row,
      required int column,
      int? seed}) {
    assert(sigma >= 0 && row > 0 && column > 0 && row > 0 && column > 0);
    final random = math.Random(seed);
    return List.generate(
        row,
        (_) => List<double>.generate(
            column, (_) => _randomGenerator.Normal(random, sigma, mu)));
  }

  static List<List<double>> binomial(
      {required int n,
      required double p,
      required int row,
      required int column,
      int? seed}) {
    assert(n > 0 && p >= 0 && p <= 1 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Binomial(random, n: n, p: p).toDouble()));
  }

  static List<List<double>> chisquare(
      {required int df, required int row, required int column, int? seed}) {
    assert(df > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Chisquare(random, df: df)));
  }

  static List<List<double>> exponential(
      {required double lambda,
      required int row,
      required int column,
      int? seed}) {
    assert(lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Exponential(random, lambda: lambda)));
  }

  static List<List<double>> f(
      {required int d1,
      required int d2,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && d1 > 0 && d2 > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.F(random, d1: d1, d2: d2)));
  }

  static List<List<double>> gamma(
      {required double k,
      required double theta,
      required int row,
      required int column,
      int? seed}) {
    assert(k > 0 && theta > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Gamma(random, k: k, theta: theta)));
  }

  static List<List<double>> beta(
      {required double a,
      required double b,
      required int row,
      required int column,
      int? seed}) {
    assert(a > 0 && b > 0 && row > 0 && column > 0);
    double Function(math.Random, {required double a0, required double b0}) _f;
    if (a == a.toInt() && b == b.toInt()) {
      _f = _randomGenerator.Beta_by_Gamma2;
    } else if (math.min(a, b) > 1) {
      _f = _randomGenerator.Beta_BB;
    } else {
      _f = _randomGenerator.Beta_BC;
    }
    var random = math.Random(seed);
    return List.generate(
        row, (_) => List.generate(column, (_) => _f(random, a0: a, b0: b)));
  }

  static List<List<double>> dirichlet(
      {required List<double> alpha, required int row, int? seed}) {
    int column = alpha.length;
    assert(column > 1 && row > 0 && !alpha.contains(0.0));
    var random = math.Random(seed);
    return List.generate(
        row, (_) => _randomGenerator.Dirichlet(random, alpha: alpha));
  }

  static List<List<double>> geometric(
      {required double p, required int row, required int column, int? seed}) {
    assert(p > 0 && p <= 1 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Geometric(random, p: p).toDouble()));
  }

  static List<List<double>> gumbel(
      {required double loc,
      required double scale,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && scale > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Gumbel(random, loc: loc, scale: scale)));
  }

  static List<List<double>> hypergeometric(
      {required int N,
      required int K,
      required int n,
      required int row,
      required int column,
      int? seed}) {
    assert(K >= 0 && K <= N && n >= 0 && n <= N && column > 0 && row > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column,
            (_) => _randomGenerator.Hypergeometric(random, N: N, K: K, n: n)
                .toDouble()));
  }

  static List<List<double>> laplace(
      {required double mu,
      required double b,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && b > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Laplace(random, mu: mu, b: b)));
  }

  static List<List<double>> logistic(
      {required double mu,
      required double s,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && s > 0);
    var random = math.Random(seed);
    return List.generate(
        (row),
        (_) => List.generate(
            column, (_) => _randomGenerator.Logistic(random, mu: mu, s: s)));
  }

  static List<List<double>> lognormal(
      {required double mu,
      required double sigma,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && sigma > 0);
    var random = math.Random(seed);
    return List.generate(
        (row),
        (_) => List.generate(column,
            (_) => _randomGenerator.Lognormal(random, mu: mu, sigma: sigma)));
  }

  static List<List<double>> multinomial(
      {required int n, required List<double> p, required int row, int? seed}) {
    int len = p.length;
    assert(len >= 1 && p.sum == 1 && n > 0 && row > 0);
    var random = math.Random(seed);
    return List.generate(
        (row),
        (_) => _randomGenerator.Multinomial(random, n: n, p: p)
            .map((e) => e.toDouble())
            .toList());
  }

  static List<List<double>> poisson(
      {required double lambda,
      required int row,
      required int column,
      int? seed}) {
    assert(lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column,
            (_) =>
                _randomGenerator.Poisson(random, lambda: lambda).toDouble()));
  }

  static List<List<double>> cauchy(
      {required double x0,
      required double gamma,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && gamma > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Cauchy(random, x0: x0, gamma: gamma)));
  }

  static List<List<double>> pareto(
      {required double xm,
      required double alpha,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && alpha > 0 && xm > 0);
    double ia = 1.0 / alpha;
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Pareto(random, xm: xm, ia: ia)));
  }

  static List<List<double>> rayleigh(
      {required double sigma,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && sigma > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Rayleigh(random, sigma: sigma)));
  }

  static List<List<double>> triangular(
      {required double a,
      required double b,
      required double c,
      required int row,
      required int column,
      int? seed}) {
    assert(a <= c && c <= b && a < b && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Triangular(random, a: a, b: b, c: c)));
  }

  static List<List<double>> wald(
      {required double mu,
      required double lambda,
      required int row,
      required int column,
      int? seed}) {
    assert(mu > 0 && lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Wald(random, mu: mu, lambda: lambda)));
  }

  static List<List<double>> weibull(
      {required double k,
      required double lambda,
      required int row,
      required int column,
      int? seed}) {
    assert(k > 0 && lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Weibull(random, k: k, lambda: lambda)));
  }

  static List<List<double>> vonmises(
      {required double k,
      required double mu,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && k > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Vonmises(random, k: k, mu: mu)));
  }

  static List<List<double>> t(
      {required int v,
      required double mu,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && v > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(
            column, (_) => _randomGenerator.Student_t(random, v: v, mu: mu)));
  }

  static List<List<double>> frechet(
      {required double alpha,
      double s = 1.0,
      double m = 0.0,
      required int row,
      required int column,
      int? seed}) {
    assert(row > 0 && column > 0 && s > 0 && alpha > 0);
    var random = math.Random(seed);
    return List.generate(
        row,
        (_) => List.generate(column,
            (_) => _randomGenerator.Frechet(random, alpha: alpha, s: s, m: m)));
  }

  /// ----------------------------------------------------------------------------
  /// ------------------------------Visualization----------------------------------
  Map<Range, int> toHist(
      {required double start, required double end, required int counts}) {
    assert(start < end && counts > 1);
    double intervalSize = (end - start) / counts;
    Map<Range, int> histogram = {};
    for (int c = 0; c < counts; c++) {
      histogram[Range(
          start: start + c * intervalSize,
          end: start + (c + 1) * intervalSize)] = 0;
    }
    for (var list in this) {
      for (var e in list) {
        for (var range in histogram.keys) {
          double lower = range.start;
          double upper = range.end;
          if (e >= lower && e < upper) {
            histogram[range] = histogram[range]! + 1;
            break;
          }
        }
      }
    }
    return histogram;
  }

  Map<double, int> toBar() {
    Map<double, int> bar = {};
    for (var list in this) {
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

  /// ---------------------------------------------------------------------------
}
