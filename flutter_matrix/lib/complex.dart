import 'dart:math' as math show cos, sin, sqrt, atan2, exp, Point;
import 'dart:typed_data' show Float64x2;

import 'unrelated_util.dart' show cosh, sinh;

/// Define basic operations on complex numbers.
/// For more information, please see https://oi-wiki.org/math/complex/.
class Complex extends Object{
  double real = 0.0;
  double imaginary = 0.0;

  /// By default, both the [real] and [imaginary] parts of an imaginary number are 0.0.
  Complex({this.real = 0.0, this.imaginary = 0.0});

  /// Build by polar.
  factory Complex.fromPolar({required double r, required double theta}) {
    return Complex(
      real : r * math.cos(theta),
      imaginary :r * math.sin(theta),
    );
  }

  /// Build by list
  factory Complex.fromList(List<double> data){
    assert (data.length == 2);
    return Complex(real: data[0], imaginary: data[1]);
  }

  /// [which] indicates the display mode.
  String toString({int which = 0}){
    return switch(which){
      0 => "Complex($real, $imaginary)",
      1 => imaginary >= 0 ? "$real + ${imaginary}j" : "$real - ${imaginary.abs()}j",
      2 => "($real, ${imaginary}j)",
      _ => imaginary >= 0 ? "$real+${imaginary}j" : "$real-${imaginary.abs()}j"
    };
  }

  @override
  bool operator == (Object other){
    if (other is Complex){
      return other.imaginary == imaginary && real == other.real;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(real, imaginary);

  Complex _abstract_operator(bool add_mode, Object other){
    final double Function(double, double) func = add_mode ? (x, y) => x + y : (x, y) => x - y;
    if (other is num){
      return Complex(real: func(real, other.toDouble()), imaginary: func(imaginary, other.toDouble()));
    } else if (other is Complex){
      return Complex(real: func(real, other.real), imaginary: func(imaginary, other.imaginary));
    } else {
      throw UnsupportedError("Unsupported Type : ${other.runtimeType}");
    }
  }

  Complex operator + (Object other) => _abstract_operator(true, other);
  Complex operator - (Object other) => _abstract_operator(false, other);

  Complex operator / (Object other){
    if (other is num){
      return Complex(real: real * other, imaginary: imaginary * other);
    } else if (other is Complex){
      double com = other.imaginary * other.imaginary + other.real * other.real;
      return Complex(
        real: (real * other.real + imaginary * other.imaginary) / com,
        imaginary: (imaginary * other.real - real * other.imaginary) / com
      );
    } else {
      throw UnsupportedError("Unsupported Type : ${other.runtimeType}");
    }
  }

  Complex operator * (Object other){
    if (other is num){
      return Complex(real: real * other, imaginary: imaginary * other);
    } else if (other is Complex){
      return Complex(
        real: real * other.real - imaginary * other.imaginary,
        imaginary: imaginary * other.real + real * other.imaginary
      );
    } else {
      throw UnsupportedError("Unsupported Type : ${other.runtimeType}");
    }
  }

  /// Get the complex conjugate.
  Complex get conjugate => Complex(real: real, imaginary: -imaginary);

  /// If contains NaN.
  bool get isNan => real.isNaN || imaginary.isNaN;

  /// Module of complex numbers.
  double get mod => math.sqrt(real * real + imaginary * imaginary);

  /// Argument.
  double get arg => math.atan2(imaginary, real);

  /// Euler's formula.
  /// e ^ z = e ^ (x + y_i) = e ^ x * ((cos(y) + isin(y)).
  Complex get exp => Complex(real: math.cos(imaginary) * math.exp(real), imaginary: math.sin(imaginary) * math.exp(real));

  /// Sqrt.
  Complex get sqrt => Complex(
    real: math.sqrt((mod + real) / 2),
    imaginary: (imaginary >= 0 ? 1 : -1) * math.sqrt((mod - real) / 2),
  );

  /// Sin.
  Complex get sin => Complex(
    real: math.sin(real) * cosh(imaginary),
    imaginary: math.cos(real) * sinh(imaginary),
  );

  /// Cos.
  Complex get cos => Complex(
    real: math.cos(real) * cosh(imaginary),
    imaginary: -math.sin(real) * sinh(imaginary),
  );

  /// Tan.
  Complex get tan => sin / cos;

  Complex get deepcopy => Complex(real: real, imaginary: imaginary);

  /// Convert on demand.
  List<double> get toList => [real, imaginary];
  math.Point<double> get toPoint => math.Point(real, imaginary);
  Float64x2 get toFloat64x2 => Float64x2(real, imaginary);
}
