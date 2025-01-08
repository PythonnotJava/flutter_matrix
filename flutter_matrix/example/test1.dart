import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
    [1, 2, 3, 8],
  ];
  var mt1 = Matrix.fromList(data);
  var mt2 = Matrix.E(n: 4);
  (mt1 + mt2).visible();
  (mt1 - mt2).visible();
  (mt1 * mt2).visible();
  (mt1 / mt2).visible(format: "%8.1f");
  (mt1 + 1).visible();
  (mt1 - 2).visible();
  (mt1 * 3).visible();
  (mt1 / 4).visible(format: "%2.1f");
}