import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  var mt = Matrix.linspace(start: 0, end: 10, row: 10, column: 10, keep: true);
  mt.visible();
}