# 函数工具

## any
- 是否存在满足条件的数据
```text
Object any(bool Function(double) condition, {int dim = -1})
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var t1 = Matrix.fromList([
    [3, double.nan, 2, 1],
    [0, 2, 13, 3],
    [9, double.negativeInfinity, 8, 8]
  ]);
  print(t1.any((x) => x < 0, dim: 0));
  print(t1.any((x) => x < 0, dim: 1));
  print(t1.any((x) => x < 0, dim: 2));
  print(t1.any((x) => x.isNaN,dim: 2));
}
```
### output
```text
[false, false, true]
[false, true, false, false]
true
true
```

## all
- 判断所有元素是否满足条件
```text
Object all(bool Function(double) conditon, {int dim = -1})
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var t1 = Matrix.fromList([
    [3, double.nan, 2, 1],
    [0, 2, 13, 3],
    [9, double.negativeInfinity, 8, 8]
  ]);
  print(t1.all((x) => x >= 0, dim: 0));
  print(t1.all((x) => x >= 0, dim: 1));
  print(t1.all((x) => x >= 0, dim: 2));
  print(t1.all((x) => !x.isNaN,dim: 2));
}
```
### output
```text
[false, true, false]
[true, false, true, true]
false
false
```
## reduce
- 对矩阵进行累积运算，元素用于初始化并记录累积值（如果设置）
```text
Object reduce(
    double Function(double, double) condition, {
    double? element, int dim = -1
})
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var t1 = Matrix.fromList([
    [3, -2, 2, 1],
    [0, 2, 13, 3],
    [9, double.negativeInfinity, 8, 8]
  ]);
  print(t1.reduce((x, y) => x + y, dim: 0));
  print(t1.reduce((x, y) => x * y, element: 1, dim: 1));
  print(t1.reduce((x, y) => x + y, dim: 2));
  t1..setMask(nag_inf_mask: 0)..visible()..reduce((x, y) => x + y, dim: 2);
}
```
### output
```text
[4.0, 18.0, -Infinity]
[0.0, Infinity, 208.0, 24.0]
-Infinity
[
 [  3  -2   2   1]
 [  0   2  13   3]
 [  9   0   8   8]
]
```
## replace
- 替换满足条件的值。cope为替换方式
```text
void replace(bool Function(double) condition,
          {required double Function(double) cope})
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var t1 = Matrix.fromList([
    [3, -2, double.infinity, 1],
    [0, 2, -1, 3],
    [9, double.negativeInfinity, 8, 8]
  ]);
  t1..replace((x) => x.isInfinite, cope: (x) => 3)..visible();
  t1..replace((x) => x < 0, cope: (x) => x * x)..visible();
}
```
### output
```text
[
 [  3  -2   3   1]
 [  0   2  -1   3]
 [  9   3   8   8]
]
[
 [  3   4   3   1]
 [  0   2   1   3]
 [  9   3   8   8]
]
```
## count
- 对满足条件的值计数
```text
Object count(bool Function(double) condition, {int dim = -1})
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var t1 = Matrix.fromList([
    [3, -2, double.infinity, 1],
    [0, 2, -1, 3],
    [9, double.negativeInfinity, 8, 8]
  ]);
  print(t1.count((x) => x < 0, dim: 0));
  print(t1.count((x) => x < 0, dim: 1));
  print(t1.count((x) => x < 0, dim: 2));
}
```
### output
```text
[1, 1, 1]
[0, 2, 1, 0]
3
```
## 对数据自定义映射
- customize
```text
T customize(double Function(double) condition)
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%8.0f";
  var t1 = Matrix.fromList([
    [3, -2, double.infinity, 1],
    [0, 2, -1, 3],
    [9, double.negativeInfinity, 8, 8]
  ]);
  t1.customize((x) => x >= 0 ? x : x.isInfinite ? 2 : x * x).visible();
}
```
### output
```text
[
 [        3         4  Infinity         1]
 [        0         2         1         3]
 [        9         2         8         8]
]
```
## confront
- 两个矩阵中同一位置的数据的条件映射。
```text
T confront(double Function(double, double) condition, {required T other})
```

### test
```dart
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var t1 = Matrix.fromList([
    [3, -2, double.infinity, 1],
    [0, 2, -1, 3],
    [9, -4, 8, 8]
  ]);
  var other = MatrixBase.fill<Matrix>(number: 2, row: 3, column: 4);
  t1.confront((x, y) => min(x, y), other: other).visible();
}
```
### output
```text
[
 [  2  -2   2   1]
 [  0   2  -1   2]
 [  2  -4   2   2]
]
```
## clip
- 裁剪数据，lb 表示下限，ub 表示上限。如果 reverse 为真，则保留两边的数据，否则，保留范围内的数据
- 对不符合条件的，进行条件映射
```text
T clip(double Function(double) condition,
          {required double lb, required double ub, bool reverse = false})
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%7.0f";
  var t1 = Matrix.fromList([
    [3, -2, double.infinity, 1],
    [0, 2, -1, 3],
    [9, -4, 8, 8]
  ]);
  t1.clip((_) => 7, lb: 2, ub: 9, reverse: false).visible();
  t1.clip((_) => 7, lb: 2, ub: 9, reverse: true).visible();
}
```
### output
```text
[
 [       3        7        7        7]
 [       7        2        7        3]
 [       9        7        8        8]
]
[
 [       7       -2 Infinity        1]
 [       0        2       -1        7]
 [       9       -4        7        7]
]
```

[下一篇：集合模拟](geometry.md)