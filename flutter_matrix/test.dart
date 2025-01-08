import 'flutter_matrix.dart';

main() {
  var mt = Matrix.arrange(row: 4, column: 4);
  var mt1 = Matrix([
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
  ]);
  print(mt1.dft());
}