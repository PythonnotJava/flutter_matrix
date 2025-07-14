# 线性代数
## trace
- 矩阵的迹，如果不是方阵，则以行和列中最小值取方阵的迹
```text
double trace()
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = MatrixBase.E<Matrix>(n: 4);
  print(mt.trace());
  var mt1 = MatrixBase.ELike<Matrix>(row: 3, column: 6);
  print(mt1.trace());
}
```
### output
```text
4.0
3.0
```
## elementaryExchange
- 矩阵的初等行变换——交换
```text
void elementaryExchange({
    required int index1, required int index2, bool horizontal = true
  })
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var mt = MatrixBase.arrange<Matrix>(row: 4, column: 6);
  mt.visible();
  mt
    ..elementaryExchange(index1: 0, index2: 3, horizontal: true)
    ..visible()
    ..elementaryExchange(index1: 3, index2: 1, horizontal: false)
    ..visible();
}
```
### output
```text
[
 [  0   1   2   3   4   5]
 [  6   7   8   9  10  11]
 [ 12  13  14  15  16  17]
 [ 18  19  20  21  22  23]
]
[
 [ 18  19  20  21  22  23]
 [  6   7   8   9  10  11]
 [ 12  13  14  15  16  17]
 [  0   1   2   3   4   5]
]
[
 [ 18  21  20  19  22  23]
 [  6   9   8   7  10  11]
 [ 12  15  14  13  16  17]
 [  0   3   2   1   4   5]
]
```
## elementaryMultiply
- 矩阵的初等行变换——倍乘某行，这里允许为0
```text
void elementaryMultiply({
    required int index, required double number, bool horizontal = true
  })
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.1f";
  var mt = MatrixBase.arrange<Matrix>(row: 4, column: 6);
  mt.visible();
  mt
    ..elementaryMultiply(index: 1, number: 3.5, horizontal: true)
    ..visible()
    ..elementaryMultiply(index: 5, number: 3, horizontal: false)
    ..visible();
}
```
### output
```text
[
 [  0.0   1.0   2.0   3.0   4.0   5.0]
 [  6.0   7.0   8.0   9.0  10.0  11.0]
 [ 12.0  13.0  14.0  15.0  16.0  17.0]
 [ 18.0  19.0  20.0  21.0  22.0  23.0]
]
[
 [  0.0   1.0   2.0   3.0   4.0   5.0]
 [ 21.0  24.5  28.0  31.5  35.0  38.5]
 [ 12.0  13.0  14.0  15.0  16.0  17.0]
 [ 18.0  19.0  20.0  21.0  22.0  23.0]
]
[
 [  0.0   1.0   2.0   3.0   4.0  15.0]
 [ 21.0  24.5  28.0  31.5  35.0 115.5]
 [ 12.0  13.0  14.0  15.0  16.0  51.0]
 [ 18.0  19.0  20.0  21.0  22.0  69.0]
]
```
## elementaryAdd
- 矩阵的初等变换——倍乘某行（列）index2并且加到另一行（列）index1
```text
void elementaryAdd({
   required int index1,
   required int index2,
   required double number,
   bool horizontal = true
})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.1f";
  var mt = MatrixBase.arrange<Matrix>(row: 4, column: 6);
  mt
    ..visible()
    ..elementaryAdd(index1: 1, index2: 2, number: 1, horizontal: true)
    ..visible()
    ..elementaryAdd(index1: 1, index2: 5, number: 2, horizontal: false)
    ..visible();
}
```
### output
```text
[
 [  0.0   1.0   2.0   3.0   4.0   5.0]
 [  6.0   7.0   8.0   9.0  10.0  11.0]
 [ 12.0  13.0  14.0  15.0  16.0  17.0]
 [ 18.0  19.0  20.0  21.0  22.0  23.0]
]
[
 [  0.0   1.0   2.0   3.0   4.0   5.0]
 [ 18.0  20.0  22.0  24.0  26.0  28.0]
 [ 12.0  13.0  14.0  15.0  16.0  17.0]
 [ 18.0  19.0  20.0  21.0  22.0  23.0]
]
[
 [  0.0  11.0   2.0   3.0   4.0   5.0]
 [ 18.0  76.0  22.0  24.0  26.0  28.0]
 [ 12.0  47.0  14.0  15.0  16.0  17.0]
 [ 18.0  65.0  20.0  21.0  22.0  23.0]
]
```
## transpose、T_
- 转置矩阵
```text
T transpose() 
T get T_
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.0f";
  var mt = MatrixBase.arrange<Matrix>(row: 2, column: 3)..visible();
  mt.T_.visible();
  mt.transpose().visible();
}
```
### output
```text
[
 [   0    1    2]
 [   3    4    5]
]
[
 [   0    3]
 [   1    4]
 [   2    5]
]
[
 [   0    3]
 [   1    4]
 [   2    5]
]
```
## det
- 方阵的行列式值
```text
double get det
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = Matrix.fromList([
    [3, 2, 6],
    [0, 8, 12],
    [1, 4, 2]
  ]);
  print(mt.det);
}
```
### output
```text
-120.0
```
## adjugate
- 获取方阵的伴随矩阵
```text
T get adjugate
```

### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.0f";
  var mt = Matrix.fromList([
    [3, 2, 6],
    [0, 8, 12],
    [1, 4, 2]
  ]);
  var mt1 = mt.adjugate;
  print(mt1);
  // A product Aadj = Adet * E;
  print(mt.product(other: mt1));
}
```
### output
```text
[
 [ -32   20  -24]
 [  12    0  -36]
 [  -8  -10   24]
]
[
 [-120    0    0]
 [   0 -120    0]
 [   0    0 -120]
]
```
## inverse
- Get the inverse of a nonsingular square matrix
```text
T get inverse
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([
    [3, 2, 6],
    [0, 8, 12],
    [1, 4, 2]
  ]);
  var mt1 = mt.inverse;
  print(mt1);
  print(mt.product(other: mt1));
}
```
### output
```text
[
 [  0.26667  -0.16667   0.20000]
 [ -0.10000  -0.00000   0.30000]
 [  0.06667   0.08333  -0.20000]
]
[
 [  1.00000   0.00000   0.00000]
 [  0.00000   1.00000  -0.00000]
 [ -0.00000   0.00000   1.00000]
]
```
## rank
- 矩阵的秩
```text
int get rank
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList(List.generate(3, (r) => List.generate(3, (c) => r * 3 + c + 1)))
    ..visible();
  print(mt.rank);
}
```
### output
```text
[
 [  1.00000   2.00000   3.00000]
 [  4.00000   5.00000   6.00000]
 [  7.00000   8.00000   9.00000]
]
2
```
## rref
- 通过高斯消元法化最简行阶梯型
- rank、rref、判断奇异矩阵都是通过tolerance_round容忍值控制的
```text
T get rref
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList(List.generate(3, (r) => List.generate(3, (c) => r * 3 + c + 1)))
    ..visible();
  print(mt.rref);
  print(mt.rank);
}
```
### output
```text
[
 [  1.00000   2.00000   3.00000]
 [  4.00000   5.00000   6.00000]
 [  7.00000   8.00000   9.00000]
]
[
 [  1.00000   0.00000  -1.00000]
 [ -0.00000   1.00000   2.00000]
 [  0.00000   0.00000   0.00000]
]
2
```
## coincidental
- 获取矩阵的去掉row和column的余子式
```text
T coincidental({required int row, required int column})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var mt = Matrix.fromList(List.generate(5, (r) => List.generate(6, (c) => r * 3 + c + 1)))
    ..visible();
  mt.coincidental(row: 2, column: 4).visible();
}
```
### output
```text
[
 [  1   2   3   4   5   6]
 [  4   5   6   7   8   9]
 [  7   8   9  10  11  12]
 [ 10  11  12  13  14  15]
 [ 13  14  15  16  17  18]
]
[
 [  1   2   3   4   6]
 [  4   5   6   7   9]
 [ 10  11  12  13  15]
 [ 13  14  15  16  18]
]
```
## product
- 矩阵的标准乘法
```text
T product({required T other})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var mt = Matrix.fromList(List.generate(3, (r) => List.generate(3, (c) => r * 3 + c + 1)))
    ..visible();
  var mt1 = Matrix.fromList([
    [2, 2, 1],
    [0, 9, 2],
    [2, 4, 6]
  ]);
  print(mt.product(other: mt1));
}
```
### output
```text
[
 [  1   2   3]
 [  4   5   6]
 [  7   8   9]
]
[
 [  8  32  23]
 [ 20  77  50]
 [ 32 122  77]
]
```
## kronecker
- 克罗内克积
```text
T kronecker({required T other})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var mt = Matrix.fromList(List.generate(3, (r) => List.generate(3, (c) => r * 3 + c + 1)))
    ..visible();
  var mt1 = Matrix.fromList([
    [2, 2, 1],
    [0, 9, 2],
    [2, 4, 6]
  ]);
  print(mt.kronecker(other: mt1));
}
```
### output
```text
[
 [  1   2   3]
 [  4   5   6]
 [  7   8   9]
]
[
 [  2   2   1   4   4   2   6   6   3]
 [  0   9   2   0  18   4   0  27   6]
 [  2   4   6   4   8  12   6  12  18]
 [  8   8   4  10  10   5  12  12   6]
 [  0  36   8   0  45  10   0  54  12]
 [  8  16  24  10  20  30  12  24  36]
 [ 14  14   7  16  16   8  18  18   9]
 [  0  63  14   0  72  16   0  81  18]
 [ 14  28  42  16  32  48  18  36  54]
]
```


[下一篇：纯数学工具](math.md)