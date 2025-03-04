# 线性代数
## transpose
> Matrix transpose()
> 
> 获取矩阵对应的转置矩阵
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1]
  ]);
  mt.transpose().visible();
}
```
### output
```text
[
 [  1   3   9]
 [  4  -2   0]
 [  5   1   1]
]
```
## trace
> double trace()
> 
> 获取矩阵最小维度下主对角线上数据的和，方阵中的迹
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  print(mt.trace());
}
```
### output
```text
0.0
```
## bool get isSquare
> 判断矩阵是不是方阵，即row == column
## coincidental
> Matrix coincidental({required int row, required int column})
> 
> 获取余子式，即去掉某行和某列而拼成的矩阵
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  mt.coincidental(row: 0, column: 1).visible();
}
```
### output
```text
[
 [  3   1]
 [  9   1]
 [  5   2]
]
```
## elementary_exchange
> void elementary_exchange({required int index1, required int index2, bool horizontal = true})
> 
> 初等变换——交换行或者列
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  mt
    ..elementary_exchange(index1: 3, index2: 2, horizontal: true)
    ..visible()
    ..elementary_exchange(index1: 0, index2: 1, horizontal: false)
    ..visible();
}
```
### output
```text
[
 [  1   4   5]
 [  3  -2   1]
 [  5   3   2]
 [  9   0   1]
]
[
 [  4   1   5]
 [ -2   3   1]
 [  3   5   2]
 [  0   9   1]
]
```
## elementary_multiply
> void elementary_multiply({required int index, required double number, bool horizontal = true})
> 
> 初等变换——倍乘行或者列
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  mt
    ..elementary_multiply(index: 1, number: 2.0, horizontal: false)..visible()
    ..elementary_multiply(index: 1, number: 0.5, horizontal: true)..visible();
}
```
### output
```text
[
 [ 1.00  8.00  5.00]
 [ 3.00 -4.00  1.00]
 [ 9.00  0.00  1.00]
 [ 5.00  6.00  2.00]
]
[
 [ 1.00  8.00  5.00]
 [ 1.50 -2.00  0.50]
 [ 9.00  0.00  1.00]
 [ 5.00  6.00  2.00]
]
```
## elementary_add
> void elementary_add({required int index1, required int index2, required double number, bool horizontal = true})
> 
> 初等变换——把某行或者列的倍乘加到另一行或者列
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  mt
    ..elementary_add(index1: 1, index2: 2, number: 1, horizontal: true)
    ..visible()
    ..elementary_add(index1: 2, index2: 1, number: 3, horizontal: false)
    ..visible();
}
```
### output
```text
[
 [ 1.00  4.00  5.00]
 [12.00 -2.00  2.00]
 [ 9.00  0.00  1.00]
 [ 5.00  3.00  2.00]
]
[
 [ 1.00  4.00 17.00]
 [12.00 -2.00 -4.00]
 [ 9.00  0.00  1.00]
 [ 5.00  3.00 11.00]
]
```
## dot
> Matrix dot({required Matrix other})
> 
> 左行右列做矩阵内积，必须满足$A_(m*n)$和$B_(n*k)$的形状
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  var mt1 = Matrix.fromList(
    [[1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],]
  );
  mt.dot(other: mt1).visible();
}
```
### output
```text
[
 [58.00 -4.00 14.00]
 [ 6.00 16.00 14.00]
 [18.00 36.00 46.00]
 [32.00 14.00 30.00]
]
```
## kronecker
> Matrix kronecker({required Matrix other})
> 
> 关于[克罗内克积](https://zh.wikipedia.org/wiki/%E5%85%8B%E7%BD%97%E5%86%85%E5%85%8B%E7%A7%AF)
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.2f";
  var mt = Matrix.fromList([
    [1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],
    [5, 3, 2]
  ]);
  var mt1 = Matrix.fromList(
    [[1, 4, 5],
    [3, -2, 1],
    [9, 0, 1],]
  );
  mt.kronecker(other: mt1).visible();
}
```
### output
```text
[
 [  1.00   4.00   5.00   4.00  16.00  20.00   5.00  20.00  25.00]
 [  3.00  -2.00   1.00  12.00  -8.00   4.00  15.00 -10.00   5.00]
 [  9.00   0.00   1.00  36.00   0.00   4.00  45.00   0.00   5.00]
 [  3.00  12.00  15.00  -2.00  -8.00 -10.00   1.00   4.00   5.00]
 [  9.00  -6.00   3.00  -6.00   4.00  -2.00   3.00  -2.00   1.00]
 [ 27.00   0.00   3.00 -18.00  -0.00  -2.00   9.00   0.00   1.00]
 [  9.00  36.00  45.00   0.00   0.00   0.00   1.00   4.00   5.00]
 [ 27.00 -18.00   9.00   0.00  -0.00   0.00   3.00  -2.00   1.00]
 [ 81.00   0.00   9.00   0.00   0.00   0.00   9.00   0.00   1.00]
 [  5.00  20.00  25.00   3.00  12.00  15.00   2.00   8.00  10.00]
 [ 15.00 -10.00   5.00   9.00  -6.00   3.00   6.00  -4.00   2.00]
 [ 45.00   0.00   5.00  27.00   0.00   3.00  18.00   0.00   2.00]
]
```
## double get det
> 求方阵的行列式值，基于[高斯消元法](https://oi-wiki.org/math/numerical/gauss/)
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.2f";
  var mt = Matrix.fromList([
    [1, 4, 5, 5],
    [3, -2, 1, 3],
    [9, 0, 1, 2],
    [5, 3, 2, -5]
  ]);
  print(mt.det);
}
```
### output
```text
-708.0
```
## Matrix get adjugate
> 获取方阵的[伴随矩阵](https://zh.wikipedia.org/zh-cn/%E4%BC%B4%E9%9A%8F%E7%9F%A9%E9%98%B5)
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%5.2f";
  var mt = Matrix.fromList([
    [1, 4, 5, 5],
    [3, -2, 1, 3],
    [9, 0, 1, 2],
    [5, 3, 2, -5]
  ]);
  print(mt.adjugate);
}
```
### output
```text
[
 [   15.00    21.00   -84.00    -6.00]
 [  -67.00   331.00  -144.00    74.00]
 [  -47.00  -349.00   216.00  -170.00]
 [  -44.00    80.00   -84.00   112.00]
]
```
## Matrix get inverse
> 获取非[奇异矩阵](https://baike.baidu.com/item/%E5%A5%87%E5%BC%82%E7%9F%A9%E9%98%B5/9658459)的[逆矩阵](https://zh.wikipedia.org/wiki/%E9%80%86%E7%9F%A9%E9%98%B5)
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%5.2f";
  var mt = Matrix.fromList([
    [1, 4, 5, 5],
    [3, -2, 1, 3],
    [9, 0, 1, 2],
    [5, 3, 2, -5]
  ]);
  print(mt.inverse);
}
```
### output
```text
[
 [   -0.02    -0.03     0.12     0.01]
 [    0.09    -0.47     0.20    -0.10]
 [    0.07     0.49    -0.31     0.24]
 [    0.06    -0.11     0.12    -0.16]
]
```
## Matrix get rref
> 获取矩阵对应的[行最简形矩阵](https://baike.baidu.com/item/%E8%A1%8C%E6%9C%80%E7%AE%80%E5%BD%A2%E7%9F%A9%E9%98%B5/4995763)
## int get rank
> 矩阵的[秩](https://zh.wikipedia.org/wiki/%E7%A7%A9_(%E7%BA%BF%E6%80%A7%E4%BB%A3%E6%95%B0))
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%5.2f";
  var mt = Matrix.fromList([
    [1, 4, 5, 5],
    [3, -2, 1, 3],
    [9, 0, 1, 2],
    [5, 3, 2, -5]
  ]);
  print(mt.rank);
  mt[3] = [1 - 9, 4 - 0, 5 - 1, 5 - 2]; // row_index0 - row_index2
  print(mt.det);
  print(mt.rank);
}
```
### output
```text
4
0.0
3
```

[下一篇：复数类](complex.md)