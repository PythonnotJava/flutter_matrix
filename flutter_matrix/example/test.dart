import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
  ];
  var mt1 = Matrix(data);
  print(mt1.flattened);;
}