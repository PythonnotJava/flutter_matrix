part of 'matrix_type.dart';

/// The returned matrix data in this module is of shape size * 2, representing size points.
mixin MatrixGeometry<T extends MatrixBase<T>> on MatrixBase<T> {
  /// Rotation Transformation.[radian] is true to indicate radians.
  T rotateTransform({required double theta, bool radian = true}) =>
      _fromList(self.rotateTransform(theta: theta, radian: radian));

  /// Projection Transformation.
  /// [ux] and [uy] are the projection components on the x-axis and y-axis respectively.
  T projectionTransform({required double ux, required double uy}) =>
      _fromList(self.projectTransform(ux: ux, uy: uy));

  /// Shear transformation, [alongX] is true along the x-axis, otherwise along the y-axis.
  /// [k] is the shear coefficient.
  T shearTransform({required double k, bool alongX = true}) =>
      _fromList(self.shearTransform(k: k, alongX: alongX));

  /// Scaling transformation, [sx] and [sy] are the scaling factors of the x-axis and y-axis coordinates respectively.
  T scaleTransform({required double sx, required double sy}) =>
      _fromList(self.scaleTransform(sx: sx, sy: sy));

  /// Generate data from [x1] to [x2] (x1 is allowed to be not less than x2).
  /// [bias] is the random offset of the data. If it is not passed, there is no offset.
  /// The bias range is (-bias, bias). [uniform] indicates whether the generated data is uniform or random within a certain interval.
  /// [vec] is the relative coordinate.
  static T curve<T extends MatrixBase<T>>(
      {required double Function(double) func,
      required double x1,
      required double x2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.curve(
            func: func,
            x1: x1,
            x2: x2,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Defines an arbitrary curve based on a parametric equation.
  /// [theta_from] and [theta_to] represent the range of the parameters.
  static T custom_curve<T extends MatrixBase<T>>(
      {required double Function(double) xfunc,
      required double Function(double) yfunc,
      required double theta_from,
      required double theta_to,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.custom_curve(
            xfunc: xfunc,
            yfunc: yfunc,
            theta_from: theta_from,
            theta_to: theta_to,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Ellipse edge data simulation, [a] is the major axis radius, [b] is the minor axis radius.
  /// When the two are the same, it is a circular edge
  static T ellipse_edge<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.ellipse_edge(
            a: a,
            b: b,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// By ellipse_edge.
  static T circle_edge<T extends MatrixBase<T>>(
      {required double r,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.circle_edge(
            r: r,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Simulation of the internal data of an ellipse.
  static T ellipse_area<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required int size,
      int? seed,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.ellipse_area(
            a: a, b: b, size: size, seed: seed, uniform: uniform, vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// By ellipse_area.
  static T circle_area<T extends MatrixBase<T>>(
      {required double r,
      required int size,
      int? seed,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.circle_area(
            r: r, size: size, seed: seed, uniform: uniform, vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Simulate a straight line based on slope and offset.
  static T line<T extends MatrixBase<T>>(
      {required double k,
      required double b,
      required double x1,
      required double x2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.line(
            k: k,
            b: b,
            x1: x1,
            x2: x2,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Horizontal Line: y = a
  static T xline<T extends MatrixBase<T>>(
      {required double a,
      required double x1,
      required double x2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.xline(
            a: a,
            x1: x1,
            x2: x2,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Vertical Line: x = a
  static T yline<T extends MatrixBase<T>>(
      {required double a,
      required double y1,
      required double y2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.yline(
            a: a,
            y1: y1,
            y2: y2,
            size: size,
            seed: seed,
            bias: bias,
            uniform: uniform,
            vec: vec),
        known_row: size,
        known_column: 2);
  }

  /// Photography simulation, [eye] is the visual point, [a], [b], [c], [d] represent the plane ax + by + cz + d = 0,
  /// [target] is the point set representing the target.
  static T camera<T extends MatrixBase<T>>({
    required List<double> eye,
    required List<List<double>> target,
    required double a,
    required double b,
    required double c,
    required double d,
  }) {
    final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
    return fromList(
        MatrixExtension.camera(
            eye: eye, target: target, a: a, b: b, c: c, d: d),
        known_row: target.length,
        known_column: 3);
  }

  /// Rotate 3-D points (size×3) around X, Y, Z axes.
  /// [rx], [ry], [rz] are rotation angles; [radian]=false means degrees.
  /// Rotation order: intrinsic ZYX (equivalent to extrinsic XYZ).
  T rotateTransform3d({
    double rx = 0.0,
    double ry = 0.0,
    double rz = 0.0,
    bool radian = true,
  }) =>
      _fromList(self.rotateTransform3d(rx: rx, ry: ry, rz: rz, radian: radian));

  /// Scale 3-D points (size×3) independently along each axis.
  T scaleTransform3d({
    required double sx,
    required double sy,
    required double sz,
  }) =>
      _fromList(self.scaleTransform3d(sx: sx, sy: sy, sz: sz));

  /// Translate 3-D points (size×3) by (tx, ty, tz).
  T translateTransform3d({
    required double tx,
    required double ty,
    required double tz,
  }) =>
      _fromList(self.translateTransform3d(tx: tx, ty: ty, tz: tz));

  /// Perspective projection of 3-D points (size×3) onto the near plane.
  /// Returns size×3 NDC coordinates in [-1,1]³.
  /// [fov] is the vertical field of view; [radian]=false means degrees.
  T perspectiveProject({
    required double fov,
    required double near,
    required double far,
    double aspect = 1.0,
    bool radian = true,
  }) =>
      _fromList(self.perspectiveProject(
          fov: fov, near: near, far: far, aspect: aspect, radian: radian));
}
