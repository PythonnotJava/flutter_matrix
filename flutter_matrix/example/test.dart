import 'package:flutter_matrix/complex.dart';

import '../flutter_matrix.dart';

main() {
  var mt = Matrix.fromList([
    [1, 2, 3, 4, 2, 1],
    [3, 4, 6, 0, 0, 3],
    [1, 5, 8, 4, 2, 3],
    [3, 4, 8, 9, 9, 5],
  ]);
  print(mt.toBar());
}