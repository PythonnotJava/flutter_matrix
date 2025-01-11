import 'package:collection/collection.dart';
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  var m = MatrixRandom.uniform(row: 5, column: 5, lb: 0, ub: 1, seed: 42)..visible();
  print(m.count((x) => x < 0.5, dim: 0));
  print((m.count((x) => x < 0.5, dim: 0) as List<int>).sum);
  print(m.count((x) => x < 0.5, dim: 1));
  print((m.count((x) => x < 0.5, dim: 1) as List<int>).sum);
  print(m.count((x) => x < 0.5, dim: 2));
}