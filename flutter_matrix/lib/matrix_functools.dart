part of 'matrix_type.dart';

extension MatrixFunctools on Matrix {
    /// Determine whether there are elements that meet the conditions.
    Object any(bool Function(double) condition, {int dim = -1}){
      if (dim == 0){
        return List.generate(shape[0], (r) => self[r].any(condition));
      }else if (dim == 1){
        return List.generate(shape[1], (c) => column_(c).any(condition));
      } else {
        return List.generate(shape[0], (r) => self[r].any(condition)).contains(true);
      }
    }

    /// Determine whether all elements meet the conditions.
    Object all(bool Function(double) conditon, {int dim = -1}){
      if (dim == 0){
        return List.generate(shape[0], (r) => self[r].every(conditon));
      }else if (dim == 1){
        return List.generate(shape[1], (c) => column_(c).every(conditon));
      }else {
        return List.generate(shape[0], (r) => self[r].every(conditon)).every((e) => e);
      }
    }

    /// Perform cumulative operations on the matrix, element is used to initialize and record the accumulated value if set.
    Object reduce(double Function(double, double) condition, {double? element, int dim = -1}){
      var [row, column] = shape;
      if (dim == 0){
        return List.generate(row, (r){
          final list = element == null ? self[r] : [element, ...self[r]];
          return list.reduce(condition);
        });
      }else if (dim == 1){
        return List.generate(column, (c) {
          final list = element == null ? column_(c) : [element, ...column_(c)];
          return list.reduce(condition);
        });
      }else {
        if (element == null){
          return List.generate(row, (r) => self[r].reduce(condition)).reduce(condition);
        }
        var v = self[0][0];
        self[0][0] = condition(element, v);
        final result = List.generate(row, (r) => self[r].reduce(condition)).reduce(condition);
        self[0][0] = v;
        return result;
      }
    }

    /// Custom operations to map matrices.
    Matrix customize(double Function(double) condition){
      var [row, column] = shape;
      return Matrix.fromList(
        self.map((row_list) => row_list.map((e) => condition(e)).toList()).toList(),
        known_column: column,
        known_row: row
      );
    }

    /// Conditional mapping of data at the same position in two matrices.
    Matrix confront(double Function(double, double) condition, {required Matrix other}){
      assert (hasSameShape(other));
      var [row, column] = shape;
      return Matrix.fromList(
        List.generate(row, (r) => List<double>.generate(column, (c) => condition(self[r][c], other.self[r][c]))),
        known_row: row,
        known_column: column
      );
    }

    /// Replace the values that meet the conditions.
    /// The replacement values are determined according to the given conditions.
    void replace(bool Function(double) condition, {required double Function(double) cope}){
      for (var list in self){
        for (int c = 0;c < shape[1];c++){
          var v = list[c];
          if (condition(v)){
            list[c] = cope(v);
          }
        }
      }
    }

    /// Clip data, lb represents the lower limit, ub represents the upper limit.
    /// If reverse is true, keep the data on both sides.
    /// Otherwise, keep the data in the range. Perform conditional mapping for those that do not meet the [condition].
    Matrix clip(double Function(double) condition, {required double lb, required double ub, bool reverse = false}){
      assert (lb <= ub);
      var [row, column] = shape;
      final data = !reverse ? List.generate(row, (r) => List.generate(column, (c) {
        double v = self[r][c];
        if (v < lb || v > ub){
          v = condition(v);
        }
        return v;
      })) : List.generate(row, (r) => List.generate(column, (c) {
        double v = self[r][c];
        if (lb < v && v < ub){
          v = condition(v);
        }
        return v;
      }));
      return Matrix.fromList(data, known_column: column, known_row: row);
    }
}