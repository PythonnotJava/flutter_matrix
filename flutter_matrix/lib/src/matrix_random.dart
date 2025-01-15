part of 'matrix_type.dart';

extension MatrixRandom on Matrix {
  /// Get the mean.
  Object mean({int dim = -1}){
    var [row, column] = shape;
    if (dim == 0){
      final list = sum(dim: 0) as List<double>;
      return List.generate(row, (r) => list[r] / column);
    } else if (dim == 1){
      final list = sum(dim: 1) as List<double>;
      return List.generate(column, (c) => list[c] / column);
    } else {
      return (sum(dim: -1) as double) / size;
    }
  }

  /// Get the median.
  Object median({int dim = -1}){
    var [row, column] = shape;
    if (dim == 0){
      return List.generate(row, (r){
        final list = [...self[r]]..sort();
        return list[column ~/ 2];
      });
    } else if (dim == 1){
      return List.generate(column, (r) {
        final list = column_(r)..sort();
        return list[row ~/ 2];
      });
    } else {
      return (List.generate(size, (index) => self[index ~/ column][index % column])..sort())[size ~/ 2];
    }
  }

  /// Get the mode.
  Object mode({int dim = -1}) {
    var [row, column] = shape;
    late Map<Object, int> dict;
    if (dim == 0) {
      List<Object> result = [];
      for (var list in self) {
        dict = {};
        for (var e in list) {
          dict[e] = (dict[e] ?? 0) + 1;
        }
        var maxCount = dict.values.reduce((a, b) => a > b ? a : b);
        result.add(dict.keys.firstWhere((key) => dict[key] == maxCount));
      }
      return result;
    } else if (dim == 1) {
      List<Object> result = [];
      for (int col = 0; col < column; col++) {
        dict = {};
        for (int rowIndex = 0; rowIndex < row; rowIndex++) {
          var element = this[rowIndex][col];
          dict[element] = (dict[element] ?? 0) + 1;
        }
        var maxCount = dict.values.reduce((a, b) => a > b ? a : b);
        result.add(dict.keys.firstWhere((key) => dict[key] == maxCount));
      }
      return result;
    } else {
      dict = {};
      for (var list in self) {
        for (var e in list) {
          dict[e] = (dict[e] ?? 0) + 1;
        }
      }
      var maxCount = dict.values.reduce((a, b) => a > b ? a : b);
      return dict.keys.firstWhere((key) => dict[key] == maxCount);
    }
  }

  /// Random Shuffle.
  void shuffle({int? seed, int dim = -1}){
    var random = math.Random(seed);
    var [row, column] = shape;
    if (dim == 0){
      self.forEach((row_list){
        row_list.shuffle(random);
      });
    }else if (dim == 1){
      final transposed = _transpose(mt_self: self, mt_shape: shape);
      transposed.forEach((list){
        list.shuffle(random);
      });
      for (int r = 0;r < row;r++){
        for (int c = 0;c < column;c++){
          self[r][c] = transposed[c][r];
        }
      }
    } else{
      final data = flattened..shuffle(random);
      for (int r = 0;r < row;r++){
        for (int c = 0;c < column;c++){
          self[r][c] = data[r * column + c];
        }
      }
    }
  }

  /// Uniform distribution.The default is standard uniform distribution.
  static Matrix uniform({double lb = 0.0, double ub = 1.0, required int row, required int column, int? seed}){
    assert(lb < ub && row > 0 && column > 0);
    final random = math.Random(seed);
    double gap = ub - lb;
    return Matrix.fromList(
      List.generate(row, (_) => List<double>.generate(column, (_) => lb + gap * random.nextDouble())),
      known_column: column,
      known_row: row
    );
  }

  /// Normal distribution, the default is standard normal distribution.
  static Matrix normal({double mu = 0.0, double sigma = 1.0, required int row, required int column, int? seed}) {
    assert(sigma >= 0 && row > 0 && column > 0 && row > 0 && column > 0);
    final random = math.Random(seed);
    return Matrix.fromList(
      List.generate(row, (_) => List<double>.generate(column, (_) => Normal(random, sigma, mu))),
      known_column: column,
      known_row: row
    );
  }

  /// Offset the data, bias is the maximum offset radius.
  void shake_total({double bias = 1.0, int? seed}){
    bias = bias.abs();
    if (bias != 0.0){
      final random = math.Random(seed);
      self.forEach((list){
        for (int c = 0;c < shape[1];c++){
          random.nextBool() ?
            list[c] += bias * random.nextDouble() :
            list[c] -= bias * random.nextDouble();
        }
      });
    }
  }

  /// Randomly offset some data, and [percent] is the percentage of the offset data in the total data.
  void shake_percent({double bias = 1.0, double percent = 0.5, int? seed}){
    assert(percent > 0 && percent <= 1);
    bias = bias.abs();
    if (bias != 0.0){
      final random = math.Random(seed);
      final indices = choose(
        list: List.generate(size, (r) => r),
        n: (size * percent).round(),
        m: size,
        back: false,
        seed: seed
      );
      int column = shape[1];
      for (var index in indices) {
        final r = index ~/ column;
        final c = index % column;
        random.nextBool() ?
          self[r][c] += bias * random.nextDouble() :
          self[r][c] -= bias * random.nextDouble();
      }
    }
  }

  /// Randomly offset some data, [p] is the probability of data offset.
  void shake_probably({double bias = 1.0, double p = 0.5, int? seed}){
    assert(p > 0 && p <= 1);
    bias = bias.abs();
    if (bias != 0.0){
      final random = math.Random(seed);
      int column = shape[1];
      for (var list in self){
        for (int c = 0;c < column;c++){
          if (random.nextDouble() <= p){
            random.nextBool() ?
              list[c] += bias * random.nextDouble() :
              list[c] -= bias * random.nextDouble();
          }
        }
      }
    }
  }

}