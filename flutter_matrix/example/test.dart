import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, 1.2]);
  Complex complex1 = Complex(real: 1.3, imaginary: -1.2);
  print(complex.conjugate == complex1);
}