import 'dart:math' as math;
/// A package encapsulates unrelated utilities.

/// Calculation accuracy
const double EPSILON = 1.4901161193847656e-08;
const double euler = 0.57721566490153286060651209;

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

/// Center difference
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
double tanh(double x) => (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x));
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

/// Standard && normal distribution.
double StandardNormal(math.Random rd){
  double u1 = rd.nextDouble();
  double u2 = rd.nextDouble();
  return math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
}

double Normal(math.Random rd, double sigma, double mu){
  double u1 = rd.nextDouble();
  double u2 = rd.nextDouble();
  double z = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
  return z * sigma + mu;
}

/// Randomly select n data from a list of length m.
/// m can be passed in selectively.
/// [back] is true to indicate that it can be put back after each selection.
List<T> choose<T>({
  required List<T> list,
  required int n,
  int? m,
  bool back = false,
  int? seed
}) {
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