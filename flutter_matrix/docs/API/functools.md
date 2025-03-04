# 函数工具

## any
> Object any(bool Function(double) condition, {int dim = -1})
> 
> 判断矩阵中是否存在满足条件的值（存在性问题）
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  List<List<double>> data = [
    [4, double.nan, 0, 9],
    [0, 3, 1, double.infinity],
    [5, 6, 3, -double.infinity],
  ];
  var mt1 = Matrix(data);
  print(mt1.any((x) => x == double.negativeInfinity, dim: 0));
  print(mt1.any((x) => x == double.negativeInfinity, dim: 1));
  print(mt1.any((x) => x == double.negativeInfinity, dim: 2));
}
```
### output
```text
[false, false, true]
[false, false, false, true]
true
```
## all
> Object all(bool Function(double) condition, {int dim = -1})
>
> 判断矩阵中数据是否全部满足条件（整体满足问题）
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  List<List<double>> data = [
    [4, -3, 0, 9],
    [0, 3, 1, 7],
    [2, 6, 82, 8],
  ];
  var mt1 = Matrix(data);
  print(mt1.any((x) => x ~/ 2 == 0, dim: 0));
  print(mt1.any((x) => x ~/ 2 == 0, dim: 1));
  print(mt1.any((x) => x ~/ 2 == 0, dim: 2));
}
```
### output
```text
[true, true, false]
[true, false, true, false]
true
```
## reduce
> Object reduce(double Function(double, double) condition, {double? element, int dim = -1})
> 
> 定义归约操作，element是选择性传入的初始归约值
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.range(row: 4, column: 3, start: 1, step: 2);
  mt.visible();
  print(mt.reduce((x, y) => x + y, element: 10.0, dim: 0));
  print(mt.reduce((x, y) => x / y, element: 1.0, dim: 1));
  print(mt.reduce((x, y) => x * y, element: null, dim: 2));
}
```
### output
```text
[
 [  1   3   5]
 [  7   9  11]
 [ 13  15  17]
 [ 19  21  23]
]
[19.0, 37.0, 55.0, 73.0]
[0.000578368999421631, 0.00011757789535567314, 0.00004650081376424089]
316234143225.0
```
## customize
> Matrix customize(double Function(double) condition)
> 
> 自定义映射，如有要对一个矩阵实现对数据的多次运算且需要避免多次创建，customize是一个不错的选择
### test
```text
import 'dart:math' as math;
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  List<List<double>> data = [
    [1, -3, 1, 9],
    [1, 3, 1, 7],
    [2, 6, -5, 8],
  ];
  final f = (x) => math.exp(x) + math.cos(x) + x * x;
  var mt1 = Matrix(data);
  var y = mt1.customize(f);
  var y_derivative = mt1.customize((x) => math.exp(x) - math.sin(x) + 2 * x);
  y.visible();
  y_derivative.visible();
  mt1.diff(f).visible();
}
```
### output
```text
[
 [  4   8   4 8183]
 [  4  28   4 1146]
 [ 11 440  25 3045]
]
[
 [  4  -6   4 8121]
 [  4  26   4 1110]
 [ 10 416 -11 2996]
]
[
 [  4  -6   4 8121]
 [  4  26   4 1110]
 [ 10 416 -11 2996]
]
```
## confront
> Matrix confront(double Function(double, double) condition, {required Matrix other})
> 
> 实现两个矩阵对应位置上的数据之间的操作映射
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
    [1, 2, 3, 8],
  ];
  var mt = Matrix.fromList(data);
  var mt1 = Matrix.fromList([
    [4, -1, 0, 9],
    [0, -3, 1, 9],
    [5, 6, -3, 2],
    [1, 2, -3, 8],
  ]);
  final a = mt.confront((x, y) => x + y, other: mt1)
    ..visible(); // Simulate addition
  final b = (mt1 + mt)..visible();
  print(a == b);
}
```
### output
```text
[
 [ 8.0  0.0  0.0 18.0]
 [ 0.0  0.0  2.0 18.0]
 [10.0 12.0  0.0  4.0]
 [ 2.0  4.0  0.0 16.0]
]
[
 [ 8.0  0.0  0.0 18.0]
 [ 0.0  0.0  2.0 18.0]
 [10.0 12.0  0.0  4.0]
 [ 2.0  4.0  0.0 16.0]
]
true
```
## replace
> void replace(bool Function(double) condition, {required double Function(double) cope})
> 
> 对满足条件的值进行映射到cope函数值
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
    [1, 2, 3, 8],
  ];
  var mt = Matrix.fromList(data)..replace((x) => x == 9 || x == 0, cope: (_) => 7);
  mt.visible();
}
```
### output
```text
[
 [ 4.0  1.0  7.0  7.0]
 [ 7.0  3.0  1.0  7.0]
 [ 5.0  6.0  3.0  2.0]
 [ 1.0  2.0  3.0  8.0]
]
```
## clip
> Matrix clip(double Function(double) condition, {required double lb, required double ub, bool reverse = false})
> 根据上下限限制的数据进行条件替换，reverse为true表示范围两侧保留，其余替换，反之范围内保留，两侧替换
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.range(row: 4, column: 6, start: 1, step: 2);
  mt.visible();
  mt.clip((x) => x < 3 ? 3 : x > 8 ? 8 : x, lb: 3, ub: 8, reverse: false).visible();
  mt.clip((x) => 3 < x && x < 8 ? 0 : x, lb: 3, ub: 8, reverse: true).visible();
}
```
### output
```text
[
 [  1   3   5   7   9  11]
 [ 13  15  17  19  21  23]
 [ 25  27  29  31  33  35]
 [ 37  39  41  43  45  47]
]
[
 [  3   3   5   7   8   8]
 [  8   8   8   8   8   8]
 [  8   8   8   8   8   8]
 [  8   8   8   8   8   8]
]
[
 [  1   3   0   0   9  11]
 [ 13  15  17  19  21  23]
 [ 25  27  29  31  33  35]
 [ 37  39  41  43  45  47]
]
```

## count
> Object count(bool Function(double) condition, {int dim = -1})
> 
> 统计满足统计值的个数
### test
```text
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
```
### output
```text
[
 [ 0.15  0.60  0.66  0.22  0.79]
 [ 0.16  0.41  0.17  0.21  0.57]
 [ 0.83  0.35  0.89  0.12  0.55]
 [ 0.89  0.56  0.43  0.68  0.78]
 [ 0.78  0.20  0.70  0.36  0.48]
]
[2, 4, 2, 1, 3]
12
[2, 3, 2, 4, 1]
12
12
```
[下一篇：纯数学工具](math.md)