import 'dart:math' as math;

/// Define basic operations on complex numbers.
/// For more information, please see https://oi-wiki.org/math/complex/.
class Complex extends Object{
  late final double real;
  late final double imaginary;
  /// By default, both the [real] and [imaginary] parts of an imaginary number are 0.0.
  Complex({double? real, double? imaginary}){
    this.real = real ?? 0.0;
    this.imaginary = imaginary ?? 0.0;
  }

  /// [which] indicates the display mode.
  String toString({int which = 0}){
    return switch(which){
      0 => "Complex($real, $imaginary)",
      1 => "$real + ${imaginary}j",
      2 => "($real, ${imaginary}j)",
      _ => "$real+${imaginary}j"
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
}

main(){
  var z = Complex(real: 1, imaginary: 2);
  var z1 = Complex(real: 3, imaginary: 4);
  print(z1.exp);
}