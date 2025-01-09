import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%5.0f";
  List<List<double>> data = [
    [455, 1, 0, -9324],
    [120, 3, -21, 2329],
    [-545, 656, 3223, 332]
  ];
  var mt = Matrix.fromList(data);
  mt
    ..append([1, 2, 3, 4], horizontal: true)
    ..visible()
    ..append([4, 5, 65, 232], horizontal: false)
    ..visible();
}