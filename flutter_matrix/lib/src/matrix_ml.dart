part of 'matrix_type.dart';

/// Simple implementation of some tools for machine learning.
extension MatrixML on Matrix {
  /// Softmax function.
  Matrix Softmax({int dim = -1}){
    var [row, column] = shape;
    late List<List<double>> ls;
    if (dim == 0){
      ls = [];
      self.forEach((list){
        List<double> inner = [];
        double sums = 0;
        list.forEach((x){
          double v = math.exp(x);
          inner.add(v);
          sums += v;
        });
        ls.add(inner.map((e) => e / sums).toList());
      });
    }else if (dim == 1){
      ls = List.generate(row, (_) => List.filled(column, 0.0, growable: true));
      for (int c = 0; c < column; c++) {
        double sums = 0;
        List<double> inner = [];
        for (int r = 0; r < row; r++) {
          double v = math.exp(self[r][c]);
          inner.add(v);
          sums += v;
        }
        for (int r = 0; r < row; r++) {
          ls[r][c] = inner[r] / sums;
        }
      }
    }else{
      ls = [];
      double sums = 0, v;
      self.forEach((list){
        List<double> inner = [];
        list.forEach((x){
          v = math.exp(x);
          inner.add(v);
          sums += v;
        });
        ls.add(inner);
      });
      for (int r = 0;r < row;r++){
        for (int c = 0;c < column;c++){
          ls[r][c] /= sums;
        }
      }
    }
    return Matrix.fromList(ls, known_row: row, known_column: column);
  }

  /// LeakyReLU function.
  Matrix LeakyReLU({double alpha = 0.01}){
    var [row, column] = shape;
    return Matrix.fromList(
      List.generate(row, (r) => List.generate(column, (c){
        double v = self[r][c];
        return v > 0 ? v : alpha * v;
      })),
      known_row: row,
      known_column: column
    );
  }

  /// ReLU function.
  Matrix ReLU() => LeakyReLU(alpha: 0.0);
  
  /// Sigmoid function.
  Matrix Sigmoid(){
    var [row, column] = shape;
    return Matrix.fromList(
      List.generate(row, (r) => List.generate(column, (c) => 1.0 / (1.0 + math.exp(-self[r][c])))),
      known_row: row,
      known_column: column
    );
  }

  /// ELU function.
  Matrix ELU({required double alpha}){
    var [row, column] = shape;
    return Matrix.fromList(
      List.generate(row, (r) => List.generate(column, (c){
        double v = self[r][c];
        return v > 0 ? v : alpha * (math.exp(v) - 1);
      })),
      known_row: row,
      known_column: column
    );
  }

  /// Swish function.
  Matrix Swish(){
    var [row, column] = shape;
    return Matrix.fromList(
      List.generate(row, (r) => List.generate(column, (c){
        double v = self[r][c];
        return v / (1.0 + math.exp(-v));
      })),
      known_row: row,
      known_column: column
    );
  }

  /// Softsign function.
  Matrix Softsign(){
    var [row, column] = shape;
    return Matrix.fromList(
      List.generate(row, (r) => List.generate(column, (c){
        double v = self[r][c];
        return v / (1.0 + v.abs());
      })),
      known_row: row,
      known_column: column
    );
  }
  
  /// Softplus function.
  Matrix Softplus(){
    var [row, column] = shape;
    return Matrix.fromList(
      List.generate(row, (r) => List.generate(column, (c){
        return math.log(1 + math.exp(self[r][c]));
      })),
      known_row: row,
      known_column: column
    );
  }

  /// Mean absolute error, MAE, is also known as L1 Loss.
  /// It always acts as a real value matrix, the same below.
  Object MAE({required Matrix other, int dim = -1}){
    assert(hasSameShape(other));
    var [row, column] = shape;
    if (dim == 0){
      return List.generate(row, (r) {
        double sum = 0;
        for (int c = 0; c < column; c++) {
          sum += (self[r][c] - other[r][c]).abs();
        }
        return sum / column;
      });
    }else if (dim == 1){
      return List.generate(column, (c) {
        double sum = 0;
        for (int r = 0; r < row; r++) {
          sum += (self[r][c] - other[r][c]).abs();
        }
        return sum / row;
      });
    }else{
      double sums = 0;
      for (int c = 0;c < column;c++){
        for (int r = 0;r < row;r++){
          sums += (self[r][c] - other[r][c]).abs();
        }
      }
      return sums / (row * column);
    }
  }

  /// Mean Squared Error Loss, MSE.
  Object MSE({required Matrix other, int dim = -1}){
    assert(hasSameShape(other));
    var [row, column] = shape;
    double v;
    if (dim == 0){
      return List.generate(row, (r) {
        double sum = 0;
        for (int c = 0; c < column; c++) {
          v = self[r][c] - other[r][c];
          sum += v * v;
        }
        return sum / column;
      });
    }else if (dim == 1){
      return List.generate(column, (c) {
        double sum = 0;
        for (int r = 0; r < row; r++) {
          v = self[r][c] - other[r][c];
          sum += v * v;
        }
        return sum / row;
      });
    }else{
      double sums = 0;
      for (int c = 0;c < column;c++){
        for (int r = 0;r < row;r++){
          v = self[r][c] - other[r][c];
          sums += v * v;
        }
      }
      return sums / (row * column);
    }
  }
}