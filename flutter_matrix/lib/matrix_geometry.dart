part of 'matrix_type.dart';

const List<double> OriginVector = [0.0, 0.0];

/// Geometric simulation, each simulation provides two strategies: uniform simulation and random generation.
/// [vec] is the offset vector.
/// [bias] is the jitter of the data itself, and [vec] is used for translation transformation
extension MatrixGeometry on Matrix {
  /// Generate a curve data under the rectangular coordinate system
  static Matrix curve({
    required double Function(double) func,
    required double x1,
    required double x2,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }){
    assert (size >= 2 && vec.length == 2);
    final random = math.Random(seed);
    bias ??= 0.0;
    bias = bias.abs();
    var [offset_x, offset_y] = vec;
    if (uniform) {
      double delta = (x2 - x1) / (size - 1);
      return Matrix.fromList(
        List.generate(size, (r){
          double x = x1 + r * delta;
          double y = random.nextBool() ?
            func(x) + random.nextDouble() * bias!:
            func(x) - random.nextDouble() * bias!;
          return <double>[x + offset_x, y + offset_y];
        }),
        known_row: size,
        known_column: 2
      );
    } else {
      double gap = x2 - x1;
      return Matrix.fromList(
        List.generate(size, (r){
          double x = x1 + random.nextDouble() * gap;
          double y = random.nextBool() ?
            func(x) + random.nextDouble() * bias!:
            func(x) - random.nextDouble() * bias!;
          return <double>[x + offset_x, y + offset_y];
        }),
        known_row: size,
        known_column: 2
      );
    }
  }

  /// Construct curves based on parametric equations, with theta being their common parameter.
  static Matrix custom_curve({
    required double Function(double) xfunc,
    required double Function(double) yfunc,
    required double theta_from,
    required double theta_to,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }){
    assert (size >= 2);
    final random = math.Random(seed);
    bias ??= 0.0;
    bias = bias.abs();
    var [offset_x, offset_y] = vec;
    if (uniform){
      double delta = (theta_to - theta_from) / (size - 1);
      return Matrix.fromList(
        List.generate(size, (r) {
          double theta = theta_from + delta * r;
          double x = xfunc(theta);
          double y = random.nextBool() ?
            yfunc(theta) + random.nextDouble() * bias!:
            yfunc(theta) - random.nextDouble() * bias!;
          return <double>[x + offset_x, y + offset_y];
        }),
        known_column: 2,
        known_row: size
      );
    }else{
      double gap = theta_to - theta_from;
      return Matrix.fromList(
        List.generate(size, (r){
          double theta = theta_from + random.nextDouble() * gap;
          double x = xfunc(theta);
          double y = random.nextBool() ?
            yfunc(theta) + random.nextDouble() * bias!:
            yfunc(theta) - random.nextDouble() * bias!;
          return <double>[x + offset_x, y + offset_y];
        }),
        known_row: size,
        known_column: 2
      );
    }
  }

  /// Ellipse Contour Fitting.
  static Matrix ellipse_edge({
    required double a,
    required double b,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }){
    assert(a > 0 && b > 0);
    return MatrixGeometry.custom_curve(
      xfunc: (t) => a * math.cos(t).toDouble(),
      yfunc: (t) => b * math.cos(t).toDouble(),
      theta_from: 0.0,
      theta_to: 2.0 * math.pi,
      size: size,
      vec: vec
    );
  }

  /// Circle Contour Fitting.
  static Matrix circle_edge({
    required double r,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }) => MatrixGeometry.ellipse_edge(
      a: r,
      b: r,
      size: size,
      seed: seed,
      bias: bias,
      uniform: uniform,
      vec: vec
  );

  /// Ellipse Area Fitting.
  static Matrix ellipse_area({
    required double a,
    required double b,
    required int size,
    int? seed,
    bool uniform = true,
    List<double> vec = OriginVector
  }){
    assert(size >= 2 && vec.length == 2);
    final random = math.Random(seed);
    var [offset_x, offset_y] = vec;
    if (uniform) {
      return Matrix.fromList(
        List.generate(size, (i) {
          double theta = 2 * math.pi * i / size;
          double x = a * math.cos(theta) * random.nextDouble();
          double y = b * math.sin(theta) * random.nextDouble();
          return <double>[x + offset_x, y + offset_y];
        }),
        known_column: 2,
        known_row: size,
      );
    } else {
      return Matrix.fromList(
        List.generate(size, (_) {
          double theta = random.nextDouble() * 2 * math.pi;
          double x = a * math.cos(theta) * random.nextDouble();
          double y = b * math.sin(theta) * random.nextDouble();
          return <double>[x + offset_x, y + offset_y];
        }),
        known_column: 2,
        known_row: size,
      );
    }
  }

  /// Circle Area Fitting.
  static Matrix circle_area({
    required double r,
    required int size,
    int? seed,
    bool uniform = true,
    List<double> vec = OriginVector
  }) => MatrixGeometry.ellipse_area(
      a: r,
      b: r,
      size: size,
      seed: seed,
      uniform: uniform,
      vec: vec
  );
  
  /// Line Fitting.
  static Matrix line({
    required double k,
    required double b,
    required double x1,
    required double x2,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }) => MatrixGeometry.curve(
      func: (x) => k * x + b,
      x1: x1,
      x2: x2,
      size: size,
      seed: seed,
      uniform: uniform,
      vec: vec,
      bias: bias
  );

  /// Horizontal Line: y = a
  static Matrix xline({
    required double a,
    required double x1,
    required double x2,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }) => MatrixGeometry.curve(
      func: (_) => a,
      x1: x1,
      x2: x2,
      size: size,
      seed: seed,
      bias: bias,
      uniform: uniform,
      vec: vec
  );

  /// Vertical Line: x = a
  static Matrix yline({
    required double a,
    required double y1,
    required double y2,
    required int size,
    int? seed,
    double? bias,
    bool uniform = true,
    List<double> vec = OriginVector
  }) => MatrixGeometry.custom_curve(
      xfunc: (_) => a,
      yfunc: (theta) => theta,
      theta_from: y1,
      theta_to: y2,
      size: size,
      seed: seed,
      bias: bias,
      uniform: uniform,
      vec: vec
  );

}