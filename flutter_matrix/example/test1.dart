import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.0f";
  List<List<double>> data = [
    [4, double.nan, 0, 9],
    [0, 3, 1, double.infinity],
    [5, 6, 3, -double.infinity],
  ];
  var mt1 = Matrix(data);
  mt1
    ..setMask(nan_mask: 100, inf_mask: 999, nag_inf_mask: -999)
    ..visible();
}