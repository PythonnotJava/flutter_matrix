part of 'matrix_type.dart';

final RandomGenerator _randomGenerator = RandomGenerator.instance;

/// This module provides functions in probability theory and mathematical statistics.
mixin MatrixRandom<T extends MatrixBase<T>> on MatrixBase<T> {
  /// Get the mean.
  Object mean({int dim = -1}) => self.meanExtension(dim: dim);

  /// Get the median. If the target sequence is an even number, return the mean of the two middle values.
  Object median({int dim = -1}) => self.medianExtension(dim: dim);

  /// According to the rules, get the majority among n elements.
  /// When the number of elements is the same, return null.
  /// When there are t elements with the same number (t<n), take the first element.
  dynamic mode({int dim = -1}) => self.modeExtension(dim: dim);

  /// Randomly jitter the data, range (-bias, bias).
  void shakeTotal({double bias = 1.0, int? seed}) =>
      self.shakeTotal(bias: bias, seed: seed);

  /// Randomly jitter the specified proportion of data, range (-bias, bias).
  void shakePercent({double bias = 1.0, double percent = 0.5, int? seed}) =>
      self.shakePercent(bias: bias, percent: percent, seed: seed);

  /// For each data, add random jitter, range (-bias, bias).
  void shakeProbably({double bias = 1.0, double p = 0.5, int? seed}) =>
      self.shakeProbably(bias: bias, p: p, seed: seed);

  /// Shuffle the data.
  void shuffle({int? seed, int dim = -1}) =>
      self.shuffleExtension(seed: seed, dim: dim);

  /// Uniform distribution.The default is standard uniform distribution.
  static T uniform<T extends MatrixBase<T>>(
      {double lb = 0.0,
      double ub = 1.0,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.uniform(
            row: row, column: column, lb: lb, ub: ub, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Normal distribution, the default is standard normal distribution.
  static T normal<T extends MatrixBase<T>>(
      {double mu = 0.0,
      double sigma = 1.0,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.normal(
            row: row, column: column, mu: mu, seed: seed, sigma: sigma),
        known_row: row,
        known_column: column);
  }

  /// Binomial distribution.
  /// [n] is the number of trials, [p] is the probability of success.
  static T binomial<T extends MatrixBase<T>>(
      {required int n,
      required double p,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.binomial(
            n: n, p: p, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Chi-square distribution, where the positive integer [df] is the degrees of freedom.
  static T chisquare<T extends MatrixBase<T>>(
      {required int df, required int row, required int column, int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.chisquare(df: df, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Exponential distribution, positive real number [lambda] is the rate parameter.
  static T exponential<T extends MatrixBase<T>>(
      {required double lambda,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.exponential(
            lambda: lambda, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// F distribution.
  /// Where [d1] and [d2] are the degrees of freedom of two independent chi-square distributions.
  static T f<T extends MatrixBase<T>>(
      {required int d1,
      required int d2,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.f(d1: d1, d2: d2, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Gamma distribution.
  /// Where [k] is the shape parameter and [theta] is the scale parameter. Both are positive numbers.
  static T gamma<T extends MatrixBase<T>>(
      {required double k,
      required double theta,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.gamma(
            k: k, theta: theta, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Beta distribution, parameters [a] and [b] are the shape parameters of the numerator and denominator respectively.
  static T beta<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.beta(a: a, b: b, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Dirichlet distribution, [alpha] parameter is a floating point sequence of length column and not less than 2.
  /// Every number in alpha must be greater than 0.
  static T dirichlet<T extends MatrixBase<T>>(
      {required List<double> alpha, required int row, int? seed}) {
    int column = alpha.length;
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.dirichlet(alpha: alpha, row: row, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Geometric distribution, where [p] is the probability of success.
  static T geometric<T extends MatrixBase<T>>(
      {required double p, required int row, required int column, int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.geometric(p: p, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Gumbel distribution,
  /// where [loc] is the location of the mode of the distribution and
  /// [scale] is the scale parameter of the distribution and must be non-negative.
  static T gumbel<T extends MatrixBase<T>>(
      {required double loc,
      required double scale,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.gumbel(
            loc: loc, scale: scale, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Hypergeometric distribution, the parameters [N], [K], and [n] represent the total number of elements,
  /// the total number of target elements, and the number of samples drawn, respectively,
  /// and finally the number of target elements in the sample is obtained.
  static T hypergeometric<T extends MatrixBase<T>>(
      {required int N,
      required int K,
      required int n,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.hypergeometric(
            N: N, K: K, n: n, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Laplace distribution, also known as double exponential distribution,
  /// [mu] is the location parameter, and the non-negative [b] is the scale parameter.
  static T laplace<T extends MatrixBase<T>>(
      {required double mu,
      required double b,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.laplace(
            mu: mu, b: b, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Logistic distribution,
  /// where [mu] and [s] are the location and scale parameters respectively，and [s] is greater than 0.
  static T logistic<T extends MatrixBase<T>>(
      {required double mu,
      required double s,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.logistic(
            mu: mu, s: s, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Lognormal distribution,
  /// where [mu] and [sigma] are the location and scale parameters respectively, and [sigma] is greater than 0.
  static T lognormal<T extends MatrixBase<T>>(
      {required double mu,
      required double sigma,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.lognormal(
            mu: mu, sigma: sigma, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Multinomial distribution,
  /// where [n] is the number of trials and [p] is a list of probabilities that sum to 1.
  static T multinomial<T extends MatrixBase<T>>(
      {required int n, required List<double> p, required int row, int? seed}) {
    int column = p.length;
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.multinomial(n: n, p: p, row: row, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Poisson distribution, parameter [lambda] represents the mean.
  static T poisson<T extends MatrixBase<T>>(
      {required double lambda,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.poisson(
            lambda: lambda, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Cauchy distribution, parameter [x0] is the center location, positive [gamma] indicates the scale.
  static T cauchy<T extends MatrixBase<T>>(
      {required double x0,
      required double gamma,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.cauchy(
            x0: x0, gamma: gamma, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Pareto distribution, positive [xm] is the scale parameter, positive [alpha] is the shape parameter.
  static T pareto<T extends MatrixBase<T>>(
      {required double xm,
      required double alpha,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.pareto(
            xm: xm, alpha: alpha, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Rayleigh distribution, positive [sigma] is the scale parameter.
  static T rayleigh<T extends MatrixBase<T>>(
      {required double sigma,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.rayleigh(
            sigma: sigma, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Triangular distribution, with lower limit [a], upper limit [b], and mode [c].
  static T triangular<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required double c,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.triangular(
            a: a, b: b, c: c, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Inverse Gaussian distribution (also called Wald distribution),
  /// with positive mean [mu] and shape parameter [lambda].
  static T wald<T extends MatrixBase<T>>(
      {required double mu,
      required double lambda,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.wald(
            mu: mu, lambda: lambda, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Weibull distribution, scale parameter [lambda] and shape parameter [k] are both positive.
  static T weibull<T extends MatrixBase<T>>(
      {required double k,
      required double lambda,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.weibull(
            k: k, lambda: lambda, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Von Mises distribution,
  /// parameters [mu] and [k] represent location and concentration respectively, [k] > 0.
  static T vonmises<T extends MatrixBase<T>>(
      {required double k,
      required double mu,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.vonmises(
            k: k, mu: mu, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Student's t distribution,
  /// the positive integer [v] represents the degrees of freedom, and [mu] is the noncentrality parameter.
  static T t<T extends MatrixBase<T>>(
      {required int v,
      required double mu,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.t(v: v, mu: mu, row: row, column: column, seed: seed),
        known_row: row,
        known_column: column);
  }

  /// Fréchet distribution, also known as the inverse Weibull distribution,
  /// has a positive [alpha] as the shape parameter, a positive scale parameter [s], and a location parameter [m].
  static T frechet<T extends MatrixBase<T>>(
      {required double alpha,
      double s = 1.0,
      double m = 0.0,
      required int row,
      required int column,
      int? seed}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.frechet(
            alpha: alpha, row: row, column: column, m: m, seed: seed, s: s),
        known_row: row,
        known_column: column);
  }
}
