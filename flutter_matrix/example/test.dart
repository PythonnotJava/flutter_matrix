import '../lib/flutter_matrix.dart';

main(){
  var mt = Matrix.fromList([
    [1.2, 1.3, 4.2, 2.2, 1.4],
    [0, 0.3, 2.3, 1.3, 1.7],
    [1.9, 1.83, 1.2, 2, 2.1]
  ]);
  print(mt.MSE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 0));
  print(mt.MSE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 1));
  print(mt.MSE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 2));
}
