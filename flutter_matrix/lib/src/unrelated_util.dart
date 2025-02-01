import 'dart:math' as math;

import 'package:flutter_matrix/flutter_matrix.dart';

/// A package encapsulates unrelated utilities.

/// Calculation accuracy
const double EPSILON = 1.4901161193847656e-08;
const double euler = 0.57721566490153286060651209;
const double pi = math.pi;
const double e = math.e;
const double ln2 = math.ln2;
const double log2e = math.log2e;
const double log10e = math.log10e;
const double sqrt1_2 = math.sqrt1_2;
const double sqrt2 = math.sqrt2;

/// Hexadecimal to Ansi
String hexToAnsi(String hexColor) {
  hexColor = hexColor.trim().toUpperCase();
  if (!hexColor.startsWith('#')) {
    hexColor = '#$hexColor';
  }
  if (!RegExp(r'^#([A-F0-9]{6})$').hasMatch(hexColor)) {
    throw ArgumentError("Invalid HEX color format. Use #RRGGBB.");
  }
  final r = int.parse(hexColor.substring(1, 3), radix: 16);
  final g = int.parse(hexColor.substring(3, 5), radix: 16);
  final b = int.parse(hexColor.substring(5, 7), radix: 16);
  return '\x1B[38;2;${r};${g};${b}m';
}

/// Center difference.
/// Borrowed from the GSL2.8 module : https://www.gnu.org/software/gsl/
double diffCentral(double x, double Function(double) func) {
  num h = EPSILON;
  List<double> a = List<double>.filled(4, 0.0);
  List<double> d = List<double>.filled(4, 0.0);

  for (int i = 0; i < 4; i++) {
    a[i] = x + (i - 2.0) * h;
    d[i] = func(a[i]);
  }
  for (int k = 1; k < 5; k++) {
    for (int i = 0; i < 4 - k; i++) {
      d[i] = (d[i + 1] - d[i]) / (a[i + k] - a[i]);
    }
  }
  double a3 = (d[0] + d[1] + d[2] + d[3]).abs();
  if (a3 < 100.0 * EPSILON) {
    a3 = 100.0 * EPSILON;
  }
  h = math.pow(EPSILON / (2.0 * a3), 1.0 / 3.0);
  if (h > 100.0 * EPSILON) {
    h = 100.0 * EPSILON;
  }
  return (func(x + h) - func(x - h)) / (2.0 * h);
}

/// Basic mathematical functions not in [dart:math].
double sinh(double x) => (math.exp(x) - math.exp(-x)) / 2.0;
double cosh(double x) => (math.exp(x) + math.exp(-x)) / 2.0;
double tanh(double x) =>
    (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x));
double asinh(double x) => math.log(x + math.sqrt(x * x + 1));
double acosh(double x) => math.log(x + math.sqrt(x * x - 1));
double atanh(double x) => 0.5 * math.log((1 + x) / (1 - x));
double log10(double x) => math.log(x) * math.log10e;
double square(double x) => math.pow(x, 2.0) as double;
double cube(double x) => math.pow(x, 3.0) as double;
double abs(double x) => x.abs();
double ceil(double x) => x.ceilToDouble();
double floor(double x) => x.floorToDouble();
double round(double x) => x.roundToDouble();
double degree(double x) => x * (180.0 / math.pi);
double radian(double x) => x * (math.pi / 180.0);


/// Randomly select n data from a list of length m.
/// m can be passed in selectively.
/// [back] is true to indicate that it can be put back after each selection.
List<T> choose<T>(
    {required List<T> list,
    required int n,
    int? m,
    bool back = false,
    int? seed}) {
  assert(n > 0);
  assert(m == null || (m > 0 && m <= list.length));
  m ??= list.length;
  final random = math.Random(seed);
  final result = <T>[];
  if (back) {
    for (int i = 0; i < n; i++) {
      final index = random.nextInt(m);
      result.add(list[index]);
    }
  } else {
    assert(n <= m);
    final indices = List<int>.generate(m, (i) => i)..shuffle(random);
    result.addAll(indices.take(n).map((i) => list[i]));
  }
  return result;
}

/// A random generator class.
/// Note that this class does not perform a legal range check on its parameters.
@Alert('This class does not perform a legal range check on its parameters.')
final class RandomGenerator{
  RandomGenerator._internal();
  static final RandomGenerator instance = RandomGenerator._internal();

  /// Standard && normal distribution.
  double StandardNormal(math.Random rd) {
    double u1 = rd.nextDouble();
    double u2 = rd.nextDouble();
    return math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
  }

  double Normal(math.Random rd, double sigma, double mu) {
    double u1 = rd.nextDouble();
    double u2 = rd.nextDouble();
    double z = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
    return z * sigma + mu;
  }

  /// Binomial Distribution.
  int Binomial(math.Random rd, {required int n, required double p}){
    int successCount = 0;
    for (int i = 0; i < n; i++) {
      if (rd.nextDouble() < p) {
        successCount++;
      }
    }
    return successCount;
  }

  /// Chi-square distribution.
  double Chisquare(math.Random rd, {required int df}){
    double sum = 0.0;
    for (int i = 0; i < df; i++) {
      double z = StandardNormal(rd);
      sum += z * z;
    }
    return sum;
  }

  /// Exponential distribution.
  double Exponential(math.Random rd, {required double lambda}){
    double u = rd.nextDouble();
    return -math.log(u) / lambda;
  }

  /// F distribution.
  double F(math.Random rd, {required int d1, required int d2}){
    return (Chisquare(rd, df: d1) / d1) / (Chisquare(rd, df: d2) / d2);
  }

  /// Gamma distribution.
  double Gamma(math.Random rd, {required double k, required double theta}){
    if (k < 1) {
      double u = rd.nextDouble();
      double b = (math.e + k) / math.e;
      double p = b * u;
      return Gamma(rd, k: k, theta: theta) * (p - b);
    } else {
      double d = k - 1 / 3;
      double c = 1 / math.sqrt(9 * d);
      while (true) {
        double x = StandardNormal(rd) * c;
        double v = 1 + x * x / 3;
        if (v <= 0) continue;
        double u = rd.nextDouble();
        if (u < 1 - 0.0331 * math.pow(x, 4) || math.log(u) < 0.5 * x * x + d * (1 - v + math.log(v))) {
          return d * v;
        }
      }
    }
  }

  /// Beta distribution.
  double Beta(math.Random rd, {required double a, required double b}){
    double gamma1 = Gamma(rd, k: a, theta: 1.0);
    double gamma2 = Gamma(rd, k: b, theta: 1.0);
    return gamma1 / (gamma1 + gamma2);
  }

}