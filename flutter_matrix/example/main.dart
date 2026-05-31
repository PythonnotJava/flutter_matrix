import 'package:flutter_matrix/flutter_matrix.dart';

main(){
  data_format = "%2.0f";
  var t = MatrixBase.linspace<Matrix>(
      row: 10,
      column: 10,
      start: 1,
      end: 100,
      keep: true
  );
  t.visible();
}