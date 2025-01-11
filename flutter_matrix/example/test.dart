import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%5.2f";
  var mt = Matrix.fromList([
    [1, 4, 5, 5],
    [3, -2, 1, 3],
    [9, 0, 1, 2],
    [5, 3, 2, -5]
  ]);
  print(mt.rank);
  mt[3] = [1 - 9, 4 - 0, 5 - 1, 5 - 2]; // row_index0 - row_index2
  print(mt.det);
  print(mt.rank);
}