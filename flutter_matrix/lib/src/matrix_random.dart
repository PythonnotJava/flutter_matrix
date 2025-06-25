part of 'matrix_type.dart';

final RandomGenerator _randomGenerator = RandomGenerator.instance;

extension MatrixRandom on Matrix {
  /// Get the mean.
  Object mean({int dim = -1}) {
    var [row, column] = shape;
    if (dim == 0) {
      final list = sum(dim: 0) as List<double>;
      return List.generate(row, (r) => list[r] / column);
    } else if (dim == 1) {
      final list = sum(dim: 1) as List<double>;
      return List.generate(column, (c) => list[c] / row);
    } else {
      return (sum(dim: -1) as double) / size;
    }
  }

  /// Get the median.
  Object median({int dim = -1}) {
    var [row, column] = shape;
    if (dim == 0) {
      return List.generate(row, (r) {
        final list = [...self[r]]..sort();
        return list[column ~/ 2];
      });
    } else if (dim == 1) {
      return List.generate(column, (r) {
        final list = column_(r)
          ..sort();
        return list[row ~/ 2];
      });
    } else {
      return (List.generate(
          size, (index) => self[index ~/ column][index % column])
        ..sort())[size ~/ 2];
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
  void shuffle({int? seed, int dim = -1}) {
    var random = math.Random(seed);
    var [row, column] = shape;
    if (dim == 0) {
      self.forEach((row_list) {
        row_list.shuffle(random);
      });
    } else if (dim == 1) {
      final transposed = _transpose(mt_self: self, mt_shape: shape);
      transposed.forEach((list) {
        list.shuffle(random);
      });
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          self[r][c] = transposed[c][r];
        }
      }
    } else {
      final data = flattened..shuffle(random);
      for (int r = 0; r < row; r++) {
        for (int c = 0; c < column; c++) {
          self[r][c] = data[r * column + c];
        }
      }
    }
  }

  /// Uniform distribution.The default is standard uniform distribution.
  static Matrix uniform({double lb = 0.0,
    double ub = 1.0,
    required int row,
    required int column,
    int? seed}) {
    assert(lb < ub && row > 0 && column > 0);
    final random = math.Random(seed);
    double gap = ub - lb;
    return Matrix.fromList(
        List.generate(row, (_) =>
        List<double>.generate(column, (_) => lb + gap * random.nextDouble())),
        known_column: column,
        known_row: row);
  }

  /// Normal distribution, the default is standard normal distribution.
  static Matrix normal({double mu = 0.0,
    double sigma = 1.0,
    required int row,
    required int column,
    int? seed}) {
    assert(sigma >= 0 && row > 0 && column > 0 && row > 0 && column > 0);
    final random = math.Random(seed);
    return Matrix.fromList(
        List.generate(
            row,
                (_) =>
            List<double>.generate(
                column, (_) => _randomGenerator.Normal(random, sigma, mu))),
        known_column: column,
        known_row: row);
  }

  /// Offset the data, bias is the maximum offset radius.
  void shake_total({double bias = 1.0, int? seed}) {
    bias = bias.abs();
    if (bias != 0.0) {
      final random = math.Random(seed);
      self.forEach((list) {
        for (int c = 0; c < shape[1]; c++) {
          random.nextBool()
              ? list[c] += bias * random.nextDouble()
              : list[c] -= bias * random.nextDouble();
        }
      });
    }
  }

  /// Randomly offset some data, and [percent] is the percentage of the offset data in the total data.
  void shake_percent({double bias = 1.0, double percent = 0.5, int? seed}) {
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
            ? self[r][c] += bias * random.nextDouble()
            : self[r][c] -= bias * random.nextDouble();
      }
    }
  }

  /// Randomly offset some data, [p] is the probability of data offset.
  void shake_probably({double bias = 1.0, double p = 0.5, int? seed}) {
    assert(p > 0 && p <= 1);
    bias = bias.abs();
    if (bias != 0.0) {
      final random = math.Random(seed);
      int column = shape[1];
      for (var list in self) {
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

  /// Binomial distribution.
  /// [n] is the number of trials, [p] is the probability of success.
  static Matrix binomial({
    required int n,
    required double p,
    required int row,
    required int column,
    int? seed
  }) {
    assert(n > 0 && p >= 0 && p <= 1 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Binomial(random, n: n, p: p).toDouble())),
        known_row: row,
        known_column: column
    );
  }

  /// Chi-square distribution, where the positive integer [df] is the degrees of freedom.
  static Matrix chisquare({
    required int df,
    required int row,
    required int column,
    int? seed
  }) {
    assert (df > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(
                column, (_) => _randomGenerator.Chisquare(random, df: df))),
        known_row: row,
        known_column: column
    );
  }

  /// Exponential distribution, positive real number [lambda] is the rate parameter.
  static Matrix exponential({
    required double lambda,
    required int row,
    required int column,
    int? seed
  }) {
    assert(lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Exponential(random, lambda: lambda))),
        known_row: row,
        known_column: column
    );
  }

  /// F distribution.
  /// Where [d1] and [d2] are the degrees of freedom of two independent chi-square distributions.
  static Matrix f({
    required int d1,
    required int d2,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && d1 > 0 && d2 > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(
                column, (_) => _randomGenerator.F(random, d1: d1, d2: d2))),
        known_row: row,
        known_column: column
    );
  }

  /// Gamma distribution.
  /// Where [k] is the shape parameter and [theta] is the scale parameter.
  static Matrix gamma({
    required double k,
    required double theta,
    required int row,
    required int column,
    int? seed
  }) {
    assert(k > 0 && theta > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Gamma(random, k: k, theta: theta))),
        known_row: row,
        known_column: column
    );
  }

  /// Beta distribution, parameters [a] and [b] are the shape parameters of the numerator and denominator respectively.
  static Matrix beta({
    required double a,
    required double b,
    required int row,
    required int column,
    int? seed
  }) {
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
    return Matrix.fromList(
        List.generate(
            row, (_) => List.generate(column, (_) => _f(random, a0: a, b0: b))),
        known_row: row,
        known_column: column
    );
  }

  /// Dirichlet distribution, [alpha] parameter is a floating point sequence of length column and not less than 2.
  /// Every number in alpha must be greater than 0.
  static Matrix dirichlet({
    required List<double> alpha,
    required int row,
    int? seed
  }) {
    int column = alpha.length;
    assert(column > 1 && row > 0 && !alpha.contains(0.0));
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(
            row, (_) => _randomGenerator.Dirichlet(random, alpha: alpha)),
        known_column: column,
        known_row: row
    );
  }

  /// Geometric distribution, where [p] is the probability of success.
  static Matrix geometric({
    required double p,
    required int row,
    required int column,
    int? seed
  }) {
    assert(p > 0 && p <= 1 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Geometric(random, p: p).toDouble())),
        known_column: column,
        known_row: row
    );
  }

  /// Gumbel distribution,
  /// where [loc] is the location of the mode of the distribution and
  /// [scale] is the scale parameter of the distribution and must be non-negative.
  static Matrix gumbel({
    required double loc,
    required double scale,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && scale > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Gumbel(random, loc: loc, scale: scale))),
        known_column: column,
        known_row: row
    );
  }

  /// Hypergeometric distribution, the parameters [N], [K], and [n] represent the total number of elements,
  /// the total number of target elements, and the number of samples drawn, respectively,
  /// and finally the number of target elements in the sample is obtained.
  static Matrix hypergeometric({
    required int N,
    required int K,
    required int n,
    required int row,
    required int column,
    int? seed
  }) {
    assert (K >= 0 && K <= N && n >= 0 && n <= N && column > 0 && row > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator
                    .Hypergeometric(random, N: N, K: K, n: n)
                    .toDouble())),
        known_column: column,
        known_row: row
    );
  }

  /// Laplace distribution, also known as double exponential distribution,
  /// [mu] is the location parameter, and the non-negative [b] is the scale parameter.
  static Matrix laplace({
    required double mu,
    required double b,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && b > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(
                column, (_) => _randomGenerator.Laplace(random, mu: mu, b: b))),
        known_column: column,
        known_row: row
    );
  }

  /// Logistic distribution,
  /// where [mu] and [s] are the location and scale parameters respectively，and [s] is greater than 0
  static Matrix logistic({
    required double mu,
    required double s,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && s > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate((row), (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Logistic(random, mu: mu, s: s))),
        known_row: row,
        known_column: column
    );
  }

  /// Lognormal distribution,
  /// where [mu] and [sigma] are the location and scale parameters respectively, and [sigma] is greater than 0
  static Matrix lognormal({
    required double mu,
    required double sigma,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && sigma > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate((row), (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Lognormal(random, mu: mu, sigma: sigma))),
        known_row: row,
        known_column: column
    );
  }

  /// Multinomial distribution,
  /// where [n] is the number of trials and [p] is a list of probabilities that sum to 1.
  static Matrix multinomial({
    required int n,
    required List<double> p,
    required int row,
    int? seed
  }) {
    int len = p.length;
    assert(len >= 1 && p.sum == 1 && n > 0 && row > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate((row), (_) =>
            _randomGenerator.Multinomial(random, n: n, p: p).map((e) =>
                e.toDouble()).toList()),
        known_row: row,
        known_column: len
    );
  }

  /// Poisson distribution, parameter [lambda] represents the mean.
  static Matrix poisson({
    required double lambda,
    required int row,
    required int column,
    int? seed
  }) {
    assert(lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Poisson(random, lambda: lambda).toDouble())),
        known_row: row,
        known_column: column
    );
  }

  /// Cauchy distribution, parameter [x0] is the center location, positive [gamma] indicates the scale.
  static Matrix cauchy({
    required double x0,
    required double gamma,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && gamma > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Cauchy(random, x0: x0, gamma: gamma))),
        known_row: row,
        known_column: column
    );
  }

  /// Pareto distribution, positive [xm] is the scale parameter, positive [alpha] is the shape parameter.
  static Matrix pareto({
    required double xm,
    required double alpha,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && alpha > 0 && xm > 0);
    double ia = 1.0 / alpha;
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Pareto(random, xm: xm, ia: ia))),
        known_row: row,
        known_column: column
    );
  }

  /// Rayleigh distribution, positive sigma is the scale parameter.
  static Matrix rayleigh({
    required double sigma,
    required int row,
    required int column,
    int? seed
  }) {
    assert(row > 0 && column > 0 && sigma > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Rayleigh(random, sigma: sigma))),
        known_row: row,
        known_column: column
    );
  }

  /// Triangular distribution, with lower limit [a], upper limit [b], and mode [c].
  static Matrix triangular({
    required double a,
    required double b,
    required double c,
    required int row,
    required int column,
    int? seed
  }) {
    assert(a <= c && c <= b && a < b && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Triangular(random, a: a, b: b, c: c))),
        known_row: row,
        known_column: column
    );
  }

  /// Inverse Gaussian distribution (also called Wald distribution),
  /// with positive mean [mu] and shape parameter [lambda].
  static Matrix wald({
    required double mu,
    required double lambda,
    required int row,
    required int column,
    int? seed
  }){
    assert(mu > 0 && lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Wald(random, mu: mu, lambda: lambda))),
        known_row: row,
        known_column: column
    );
  }

  /// Weibull distribution, scale parameter [lambda] and shape parameter [k] are both positive.
  static Matrix weibull({
    required double k,
    required double lambda,
    required int row,
    required int column,
    int? seed
  }){
    assert(k > 0 && lambda > 0 && row > 0 && column > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Weibull(random, k: k, lambda: lambda))),
        known_row: row,
        known_column: column
    );
  }

  /// Von Mises distribution,
  /// parameters [mu] and [k] represent location and concentration respectively, [k] > 0.
  static Matrix vonmises({
    required double k,
    required double mu,
    required int row,
    required int column,
    int? seed
  }){
    assert(row > 0 && column > 0 && k > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Vonmises(random, k: k, mu: mu))),
        known_row: row,
        known_column: column
    );
  }

  /// Student's t distribution, 
  /// the positive integer [v] represents the degrees of freedom, and [mu] is the noncentrality parameter.
  static Matrix t({
    required int v,
    required double mu,
    required int row,
    required int column,
    int? seed
  }){
    assert(row > 0 && column > 0 && v > 0);
    var random = math.Random(seed);
    return Matrix.fromList(
        List.generate(row, (_) =>
            List.generate(column, (_) =>
                _randomGenerator.Student_t(random, v: v, mu: mu))),
        known_row: row,
        known_column: column
    );
  }

}
