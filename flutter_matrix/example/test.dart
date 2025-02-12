import '../lib/flutter_matrix.dart';

main(){
  var mt = MatrixRandom.dirichlet(alpha: [1, 2, 3, 4], row: 3);
  mt.visible();
  print(mt.sum(dim: 0));
  print(mt.sum(dim: 1));
  print(mt.sum(dim: 2));
}