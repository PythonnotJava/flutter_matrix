import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.0f";
  var mt1 = Matrix.fromList([
    [1, 4, 6]
  ]);
  var mt2 = Matrix.fromList([
    [9],
    [8]
  ]);
  var mt3 = Matrix.fromList([
    [7],
    [5]
  ]);
  var [mt4, mt5, mt6] = MatrixBase.broadcast([mt1, mt2, mt3]);
  mt4.visible();
  mt5.visible();
  mt6.visible();
}
