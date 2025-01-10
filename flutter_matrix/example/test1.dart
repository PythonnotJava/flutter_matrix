import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  Matrix matrix = Matrix.linspace(start: 0, end: 1, row: 1, column: 20)..visible();
  Matrix cos_ = matrix.cos..visible();
  print(cos_.dft());
}