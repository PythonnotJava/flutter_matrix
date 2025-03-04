import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.laplace(mu: 1, b: 2, row: 2, column: 8);
  mt.visible();
}