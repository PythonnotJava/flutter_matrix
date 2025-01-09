part of 'matrix_type.dart';
extension MatrixBase on Matrix  {
  /// Quick view a matrix.
  void visible({String? format, String color = '#ffd700'}) => print(toString(format: format, color: color));

  /// Determine whether the shapes are the same.
  bool hasSameShape(Matrix other) => shape[0] == other.shape[0] && shape[1] == other.shape[1];

  /// Determine whether it is the same matrix object.
  /// That is, determine whether it meets the [deepcopy] instance requirement.
  bool isSameObj(Matrix other) => identical(this, other) && identical(self, other.self);

  /// Addition, subtraction, multiplication and division of two matrices, supporting broadcasting
  /// The dim parameter only works when the matrix type is passed in.
  Matrix _abstract_operator_method(int mode, {Matrix? other, double? number, int dim = -1}){
    assert (other != null || number != null);
    final double Function(double, double) func = _abstract_operator(mode);
    var [row, column] = shape;
    late final List<List<double>> data;
    if (other != null){
      var [other_row, other_column] = other.shape;
      if (dim == 0){
        assert (column == other_column && other_row == 1);
        data = List.generate(row, (r) => List.generate(column, (c) => func(self[r][c], other[0][c])));
      } else if (dim == 1){
        assert (row == other_row && other_column == 1);
        data = List.generate(row, (r) => List.generate(column, (c) => func(self[r][c], other[r][0])));
      } else {
        assert(row == other_row && column == other_column);
        data = List.generate(row, (r) => List.generate(column, (c) => func(self[r][c], other[r][c])));
      }
    }else {
      number!;
      data = List.generate(row, (r) => List.generate(column, (c) => func(self[r][c], number)));
    }
    return Matrix.fromList(data, known_column: column, known_row: row);
  }

  /// Addition.
  Matrix add({Matrix? other, double? number, int dim = -1}) => _abstract_operator_method(0, other: other, number: number, dim: dim);
  /// Subtraction.
  Matrix minus({Matrix? other, double? number, int dim = -1}) => _abstract_operator_method(1, other: other, number: number, dim: dim);
  /// Multiplication.
  Matrix multiply({Matrix? other, double? number, int dim = -1}) => _abstract_operator_method(2, other: other, number: number, dim: dim);
  /// Division
  Matrix divide({Matrix? other, double? number, int dim = -1}) => _abstract_operator_method(3, other: other, number: number, dim: dim);

  /// Concatenate two matrices.
  Matrix concat({required Matrix other, bool horizontal = true}){
    var [row, column] = shape;
    var [other_row, other_column] = other.shape;
    if (horizontal){
      assert (row == other_row);
      final data = List.generate(row, (r) => [...self[r], ...other.self[r]]);
      return Matrix.fromList(data, known_row: row, known_column: column + other_column);
    }else{
      assert (column == other_column);
      final data = List.generate(row + other_row, (r){
        return r < row ? [...self[r]] : [...other.self[r - row]];
      });
      return Matrix.fromList(data, known_row: row + other_row, known_column: column);
    }
  }

  /// Reshape the matrix, the size of the matrix must remain unchanged
  Matrix reshape({required int row, required int column}){
    assert (row > 0 && row * column == size);
    var origin_column = shape[1];
    int index = 0;
    final data = List.generate(row, (_) => List.generate(column, (_){
      var v = self[index ~/ origin_column][index % origin_column];
      index++;
      return v;
    }));
    return Matrix.fromList(data, known_row: row, known_column: column);
  }

  /// Reshape the matrix.
  /// If the size becomes smaller, ignore the remaining values.
  /// If it becomes larger, use the specified number instead.
  Matrix resize({required int row, required int column, double number = 0.0}){
    assert(row > 0 && column > 0);
    final new_size = row * column;
    var [origin_row, origin_column] = shape;
    int index = 0;
    late final List<List<double>> data;
    if (new_size <= size){
      data = List.generate(row, (_) => List.generate(column, (_){
        var v = self[index ~/ origin_column][index % origin_column];
        index++;
        return v;
      }));
    }else{
      data = List.generate(row, (_) => List.filled(column, number, growable: true));
      for (int r = 0;r < origin_row;r++){
        for (int c = 0;c < origin_column;c++){
          data[index ~/ column][index % column] = self[r][c];
          index++;
        }
      }
    }
    return Matrix.fromList(data, known_row: row, known_column: column);
  }

  /// Replace nan values and infinite values. If not set, do not replace.
  void setMask({double? nan_mask, double? inf_mask, double? nag_inf_mask}){
    nan_mask ??= double.nan;
    inf_mask ??= double.infinity;
    nag_inf_mask ??= double.negativeInfinity;
    var [row, column] = shape;
    for (int r = 0;r < row;r++){
      for (int c = 0;c < column;c++){
        double v = self[r][c];
        if (v.isNaN){
          self[r][c] = nan_mask;
        }else if (v == double.infinity){
          self[r][c] = inf_mask;
        }else if (v == double.negativeInfinity) {
          self[r][c] = nag_inf_mask;
        }
      }
    }
  }

  /// Flatten the matrix.
  Matrix flatten({bool horizontal = true}){
    if (horizontal){
      return Matrix.fromList([self.expand((e) => e).toList()], known_row: 1, known_column: size);
    }else {
      int row = shape[0];
      final data = [List.generate(size, (index) => self[index % row][index ~/ row])];
      return Matrix.fromList(data, known_row: 1, known_column: size);
    }
  }

  /// Gets a copy list for each row.
  List<double> row_(int index){
    int row = shape[0];
    assert(index >= 0 && index < row);
    return [...self[index]];
  }

  /// Gets a copy list for each column.
  List<double> column_(int index){
    var [row, column] = shape;
    assert(index >= 0 && index < column);
    return List.generate(row, (r) => self[r][index]);
  }

  /// Slice operation, get the part from start to end.
  /// If end is not set, the rest is intercepted from start.
  /// Allow start to be greater than end to perform reverse interception
  Matrix slice({required int start, int? end, bool horizontal = true}){
    var [row, column] = shape;
    if (horizontal){
      end ??= row - 1;
      assert (start >= 0 && start < row && end >= 0 && end < row);
      int step = start <= end ? 1 : -1;
      int new_row = (start - end).abs() + 1;
      final data = List.generate(new_row, (r){
        return [...self[start + step * r]];
      });
      return Matrix.fromList(data, known_column: column, known_row: new_row);
    }else{
      end ??= column - 1;
      assert (start >= 0 && end >= 0 && start < column && end < column);
      final data = (start <= end) ? List.generate(row, (r){
        return self[r].sublist(start, end! + 1);
      }) : List.generate(row, (r){
        return self[r].sublist(end!, start + 1).reversed.toList();
      });
      return Matrix.fromList(data, known_column: (start - end ).abs() + 1, known_row: row);
    }
  }

  /// Select specified rows or columns to form a new matrix.
  /// The selection can be in any order.
  /// Can be repeated.
  Matrix select({required List<int> target, bool horizontal = true}){
    var [row, column] = shape;
    var target_len = target.length;
    if (horizontal){
      assert (target.min >= 0 && target.max < row);
      return Matrix.fromList(
        List.generate(target_len, (r) => row_(target[r])),
        known_row: target_len,
        known_column: column
      );
    }else{
      assert (target.min >= 0 && target.max < column);
      return Matrix.fromList(
        List.generate(row, (r) => List<double>.generate(target_len, (c) => self[r][target[c]])),
        known_row: row,
        known_column: target_len
      );
    }
  }

  /// Get the matrix consisting of the remaining parts after removing some indices.
  /// The input is a [Set] of integers.
  Matrix drop({required Set<int> target, bool horizontal = true}){
    var [row, column] = shape;
    List<int> select_target = List.generate(horizontal ? row : column, (r) => r);
    for (var v in target){
      select_target.remove(v);
    }
    return select(target: select_target, horizontal: horizontal);
  }

  /// If having the point element
  bool contain(double element){
    for (List<double> list in self){
      if (list.contains(element)){
        return true;
      }
    }
    return false;
  }

  /// Compare the corresponding elements of the two matrices one by one.
  /// The which is 0 for greater than, 1 for less than, 2 for greater than or equal to,
  /// 3 for less than or equal to, 4 for not equal to, and other values for equal to.
  List<BoolList> compare({required Matrix other, int which = -1}){
    assert(hasSameShape(other));
    var [row, column] = shape;
    switch (which){
      case 0:
        return List.generate(row, (r) => BoolList.generate(column, (c) => self[r][c] > other[r][c]));
      case 1:
        return List.generate(row, (r) => BoolList.generate(column, (c) => self[r][c] < other[r][c]));
      case 2:
        return List.generate(row, (r) => BoolList.generate(column, (c) => self[r][c] >= other[r][c]));
      case 3:
        return List.generate(row, (r) => BoolList.generate(column, (c) => self[r][c] <= other[r][c]));
      case 4:
        return List.generate(row, (r) => BoolList.generate(column, (c) => self[r][c] != other[r][c]));
      default:
        return List.generate(row, (r) => BoolList.generate(column, (c) => self[r][c] == other[r][c]));
    }
  }

  /// Sorting matrix data.
  void sort({bool reverse = false, int dim = -1}){
    var [row, column] = shape;
    if (dim == 0){
     for (var list in self){
       reverse ? list.sort((a, b) => b.compareTo(a)) :
       list.sort((a, b) => a.compareTo(b));
     }
    }else if (dim == 1){
      final transposed = _transpose(mt_self: self, mt_shape: shape);
      for (int i = 0; i < column; i++) {
        reverse ? transposed[i].sort((a, b) => b.compareTo(a)) : transposed[i].sort((a, b) => a.compareTo(b));
      }
      for (int r = 0;r < row;r++){
        for (int c = 0;c < column;c++){
          self[r][c] = transposed[c][r];
        }
      }
    }else {
      final data = flattened;
      reverse ? data.sort((a, b) => b.compareTo(a)) : data.sort((a, b) => a.compareTo(b));
      for (int r = 0;r < row;r++){
        for (int c = 0;c < column;c++){
          self[r][c] = data[r * column + c];
        }
      }
    }
  }

  /// Copy data to a list.
  /// You need to pass in a [Typed] enumeration,
  /// where int, double and bool generate standard compatible types,
  /// and others generate high-performance but fixed-length lists, derived from the [dart:typed_data] library
  List<dynamic> toList(Typed T) {
    switch (T) {
      case Typed.int:
        return self.map((rowList) => rowList.map((e) => e.toInt()).toList()).toList();
      case Typed.double:
        return self.map((rowList) => rowList.toList()).toList();
      case Typed.bool:
        return self.map((rowList) => rowList.map((e) => e != 0).toList()).toList();
      case Typed.float32:
        return self.map((rowList) => Float32List.fromList(rowList)).toList();
      case Typed.float64:
        return self.map((rowList) => Float64List.fromList(rowList)).toList();
      case Typed.uint8:
        return self.map((rowList) => Uint8List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.uint16:
        return self.map((rowList) => Uint16List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.uint32:
        return self.map((rowList) => Uint32List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.uint64:
        return self.map((rowList) => Uint64List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.int8:
        return self.map((rowList) => Int8List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.int16:
        return self.map((rowList) => Int16List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.int32:
        return self.map((rowList) => Int32List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.int64:
        return self.map((rowList) => Int64List.fromList(rowList.map((e) => e.toInt()).toList())).toList();
      case Typed.complex:
        assert(shape[1] == 2);
        return self.map((rowList){
          var [r, i] = rowList;
          return Complex(real: r, imaginary: i);
        }).toList();
      }
  }

  /// Add a row/column of data at the end without length detection.
  void append(List<double> data, {bool horizontal = true}){
    if (horizontal){
      self.add([...data]);
      shape[0] += 1;
    }else{
      for (int r = 0;r < shape[0];r++){
        self[r].add(data[r]);
      }
      shape[1] += 1;
    }
  }
}