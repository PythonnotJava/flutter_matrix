# 纯数学工具

## min
- 获取矩阵的最小值
```text
Object min({int dim = -1})
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = Matrix.fromList([
    [double.nan, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt.min(dim: 0));
  print(mt.min(dim: 1));
  print(mt.min(dim: 2));
  print(min(double.nan, double.negativeInfinity));
}
```
### output
```text
[NaN, -Infinity, -5.0]
[NaN, 3.0, -5.0, -Infinity]
NaN
NaN
```
## max
- 获取矩阵的最大值
```text
Object max({int dim = -1})
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = Matrix.fromList([
    [double.nan, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt.max(dim: 0));
  print(mt.max(dim: 1));
  print(mt.max(dim: 2));
  print(max(double.nan, double.infinity));
}
```
### output
```text
[NaN, 10.0, Infinity]
[NaN, 9.0, 10.0, Infinity]
NaN
NaN
```
## argmin
- 获取矩阵的最小值的索引
```text
Object argmin({int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = Matrix.fromList([
    [double.nan, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt.argmin(dim: 0));
  print(mt.argmin(dim: 1));
  print(mt.argmin(dim: 2));
  print(double.nan == double.nan);  // always false

  var mt2 = Matrix.fromList([
    [4.3, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt2.argmin(dim: 0));
  print(mt2.argmin(dim: 1));
  print(mt2.argmin(dim: 2));
}
```
### output
```text
[-1, 3, 0]
[-1, 0, 0, 1]
-1
false
[2, 3, 0]
[2, 0, 0, 1]
7
```
## argmax
- 获取矩阵的最大值的索引
```text
Object argmax({int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = Matrix.fromList([
    [double.nan, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt.argmax(dim: 0));
  print(mt.argmax(dim: 1));
  print(mt.argmax(dim: 2));
  print(double.nan == double.nan);  // always false

  var mt2 = Matrix.fromList([
    [4.3, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt2.argmax(dim: 0));
  print(mt2.argmax(dim: 1));
  print(mt2.argmax(dim: 2));
}
```
### output
```text
[-1, 2, 3]
[-1, 1, 1, 2]
-1
false
[0, 2, 3]
[1, 1, 1, 2]
11
```
## getRange
- 获取矩阵的值域，返回值为与Range相关的类型
```text
Object getRange({int dim = -1}) 
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt2 = Matrix.fromList([
    [4.3, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt2.getRange(dim: 0));
  print(mt2.getRange(dim: 1));
  print(mt2.getRange(dim: 2));
}
```
### output
```text
[Range: [-5.0, 4.3], count: 0, Range: (-Infinity, 10.0], count: 0, Range: [-5.0, Infinity), count: 0]
[Range: [-5.0, 5.0], count: 0, Range: [3.0, 9.0], count: 0, Range: [-5.0, 10.0], count: 0, Range: (-Infinity, Infinity), count: 0]
Range: (-Infinity, Infinity), count: 0
```
## sum
- 求和
```text
Object sum({int dim = -1}) 
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  var mt = Matrix.fromList([
    [4.3, 3, -5, 0.5],
    [5, 9, 10, 6],
    [-5, 3, 0, double.infinity],
  ]);
  print(mt.sum(dim: 0));
  print(mt.sum(dim: 1));
  print(mt.sum(dim: 2));
}
```
### output
```text
[2.8, 30.0, Infinity]
[4.300000000000001, 15.0, 5.0, Infinity]
Infinity
```
## power
- 矩阵的数据的number幂次方，reverse为true则表示矩阵数据为幂
```text
T power({required double number, bool reverse = false})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([
    [4.3, 3, -5, 0.5],
    [5, 9, 10, double.negativeInfinity],
    [-5, 3, 0, double.infinity],
  ]);
  mt.power(number: 2, reverse: true).visible();
  mt.power(number: 2, reverse: false).visible();
  (mt ^ 2).visible();
}
```
### output
```text
[
 [ 19.69831   8.00000   0.03125   1.41421]
 [ 32.00000 512.00000 1024.00000   0.00000]
 [  0.03125   8.00000   1.00000  Infinity]
]
[
 [ 18.49000   9.00000  25.00000   0.25000]
 [ 25.00000  81.00000 100.00000  Infinity]
 [ 25.00000   9.00000   0.00000  Infinity]
]
[
 [ 18.49000   9.00000  25.00000   0.25000]
 [ 25.00000  81.00000 100.00000  Infinity]
 [ 25.00000   9.00000   0.00000  Infinity]
]
```
## atan2
- 方位角公式，reverse为true表示number为分母，反之为分子
```text
T atan2({required double number, bool reverse = false})
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([
    [1, sqrt(3), sqrt(3) / 3]
  ]);
  mt.atan2(number: 1, reverse: true).visible();
  mt.atan2(number: 1, reverse: false).visible();
}
```
### output
```text
[
 [  0.78540   0.52360   1.04720]
]
[
 [  0.78540   1.04720   0.52360]
]
```
## 一些单变量通用数学方法
```text
T get sin => _fromList(self.sinExtension);
T get cos => _fromList(self.cosExtension);
T get tan => _fromList(self.tanExtension);
T get asin => _fromList(self.asinExtension);
T get acos => _fromList(self.acosExtension);
T get atan => _fromList(self.atanExtension);
T get sinh => _fromList(self.sinhExtension);
T get cosh => _fromList(self.coshExtension);
T get tanh => _fromList(self.tanhExtension);
T get asinh => _fromList(self.asinhExtension);
T get acosh => _fromList(self.acoshExtension);
T get atanh => _fromList(self.atanhExtension);
T get exp => _fromList(self.expExtension);
T get log => _fromList(self.logExtension);
T get sqrt => _fromList(self.sqrtExtension);
T get log10 => _fromList(self.log10Extension);
T get square => _fromList(self.squareExtension);
T get cube => _fromList(self.cubeExtension);
T get abs => _fromList(self.absExtension);
T get ceil => _fromList(self.ceilExtension);
T get floor => _fromList(self.floorExtension);
T get round => _fromList(self.roundExtension);
T get degree => _fromList(self.degreeExtension);
T get radian => _fromList(self.radianExtension);
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([List.generate(9, (_) => _ + 0.0)].reshape(row: 3, column: 3));
  mt.visible();
  mt.sin.visible(start_point: '-----sin-----');
  mt.cos.visible(start_point: '-----cos-----');
  mt.tan.visible(start_point: '-----tan-----');
  mt.asin.visible(start_point: '-----asin-----');
  mt.acos.visible(start_point: '-----acos-----');
  mt.atan.visible(start_point: '-----atan-----');
  mt.sinh.visible(start_point: '-----sinh-----');
  mt.cosh.visible(start_point: '-----cosh-----');
  mt.tanh.visible(start_point: '-----tanh-----');
  mt.asinh.visible(start_point: '-----asinh-----');
  mt.acosh.visible(start_point: '-----acosh-----');
  mt.atanh.visible(start_point: '-----atanh-----');
  mt.exp.visible(start_point: '-----exp-----');
  mt.log.visible(start_point: '-----log-----');
  mt.sqrt.visible(start_point: '-----sqrt-----');
  mt.log10.visible(start_point: '-----log10-----');
  mt.square.visible(start_point: '-----square-----');
  mt.cube.visible(start_point: '-----cube-----');
  mt.abs.visible(start_point: '-----abs-----');
  mt.ceil.visible(start_point: '-----ceil-----');
  mt.floor.visible(start_point: '-----floor-----');
  mt.round.visible(start_point: '-----round-----');
  mt.degree.visible(start_point: '-----degree-----');
  mt.radian.visible(start_point: '-----radian-----');
}
```
### output
```text
[
 [  0.00000   1.00000   2.00000]
 [  3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000]
]
-----sin-----
[
 [  0.00000   0.84147   0.90930]
 [  0.14112  -0.75680  -0.95892]
 [ -0.27942   0.65699   0.98936]
]
-----cos-----
[
 [  1.00000   0.54030  -0.41615]
 [ -0.98999  -0.65364   0.28366]
 [  0.96017   0.75390  -0.14550]
]
-----tan-----
[
 [  0.00000   1.55741  -2.18504]
 [ -0.14255   1.15782  -3.38052]
 [ -0.29101   0.87145  -6.79971]
]
-----asin-----
[
 [  0.00000   1.57080       NaN]
 [      NaN       NaN       NaN]
 [      NaN       NaN       NaN]
]
-----acos-----
[
 [  1.57080   0.00000       NaN]
 [      NaN       NaN       NaN]
 [      NaN       NaN       NaN]
]
-----atan-----
[
 [  0.00000   0.78540   1.10715]
 [  1.24905   1.32582   1.37340]
 [  1.40565   1.42890   1.44644]
]
-----sinh-----
[
 [  0.00000   1.17520   3.62686]
 [ 10.01787  27.28992  74.20321]
 [201.71316 548.31612 1490.47883]
]
-----cosh-----
[
 [  1.00000   1.54308   3.76220]
 [ 10.06766  27.30823  74.20995]
 [201.71564 548.31704 1490.47916]
]
-----tanh-----
[
 [  0.00000   0.76159   0.96403]
 [  0.99505   0.99933   0.99991]
 [  0.99999   1.00000   1.00000]
]
-----asinh-----
[
 [  0.00000   0.88137   1.44364]
 [  1.81845   2.09471   2.31244]
 [  2.49178   2.64412   2.77647]
]
-----acosh-----
[
 [      NaN   0.00000   1.31696]
 [  1.76275   2.06344   2.29243]
 [  2.47789   2.63392   2.76866]
]
-----atanh-----
[
 [  0.00000  Infinity       NaN]
 [      NaN       NaN       NaN]
 [      NaN       NaN       NaN]
]
-----exp-----
[
 [  1.00000   2.71828   7.38906]
 [ 20.08554  54.59815 148.41316]
 [403.42879 1096.63316 2980.95799]
]
-----log-----
[
 [-Infinity   0.00000   0.69315]
 [  1.09861   1.38629   1.60944]
 [  1.79176   1.94591   2.07944]
]
-----sqrt-----
[
 [  0.00000   1.00000   1.41421]
 [  1.73205   2.00000   2.23607]
 [  2.44949   2.64575   2.82843]
]
-----log10-----
[
 [-Infinity   0.00000   0.30103]
 [  0.47712   0.60206   0.69897]
 [  0.77815   0.84510   0.90309]
]
-----square-----
[
 [  0.00000   1.00000   4.00000]
 [  9.00000  16.00000  25.00000]
 [ 36.00000  49.00000  64.00000]
]
-----cube-----
[
 [  0.00000   1.00000   8.00000]
 [ 27.00000  64.00000 125.00000]
 [216.00000 343.00000 512.00000]
]
-----abs-----
[
 [  0.00000   1.00000   2.00000]
 [  3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000]
]
-----ceil-----
[
 [  0.00000   1.00000   2.00000]
 [  3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000]
]
-----floor-----
[
 [  0.00000   1.00000   2.00000]
 [  3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000]
]
-----round-----
[
 [  0.00000   1.00000   2.00000]
 [  3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000]
]
-----degree-----
[
 [  0.00000  57.29578 114.59156]
 [171.88734 229.18312 286.47890]
 [343.77468 401.07046 458.36624]
]
-----radian-----
[
 [  0.00000   0.01745   0.03491]
 [  0.05236   0.06981   0.08727]
 [  0.10472   0.12217   0.13963]
]
```
## add
- 两个矩阵同位置数据或者矩阵与数的加法
- 该方法支持广播，dim为0则按照行方向，dim为1则按照列方向，其他则和两个同形状矩阵加法一样的效果
```text
T add({required Object other, int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([List.generate(12, (_) => _ + 0.0)].reshape(row: 3, column: 4));
  mt.visible();
  mt.add(other: mt).visible();
  mt.add(other: 2).visible();
  mt.add(other: Matrix([[4, 2, 1, 3]]), dim: 0).visible();
  mt.add(other: Matrix([[4, 2, 1]]).T_, dim: 1).visible();
}
```
### output
```text
[
 [  0.00000   1.00000   2.00000   3.00000]
 [  4.00000   5.00000   6.00000   7.00000]
 [  8.00000   9.00000  10.00000  11.00000]
]
[
 [  0.00000   2.00000   4.00000   6.00000]
 [  8.00000  10.00000  12.00000  14.00000]
 [ 16.00000  18.00000  20.00000  22.00000]
]
[
 [  2.00000   3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000   9.00000]
 [ 10.00000  11.00000  12.00000  13.00000]
]
[
 [  4.00000   3.00000   3.00000   6.00000]
 [  8.00000   7.00000   7.00000  10.00000]
 [ 12.00000  11.00000  11.00000  14.00000]
]
[
 [  4.00000   5.00000   6.00000   7.00000]
 [  6.00000   7.00000   8.00000   9.00000]
 [  9.00000  10.00000  11.00000  12.00000]
]
```
##
- 两个矩阵同位置数据或者矩阵与数的减法
- 该方法支持广播，dim为0则按照行方向，dim为1则按照列方向，其他则和两个同形状矩阵减法一样的效果
```text
T minus({required Object other, int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([List.generate(12, (_) => _ + 0.0)].reshape(row: 3, column: 4));
  mt.visible();
  mt.minus(other: mt).visible();
  mt.minus(other: 2).visible();
  mt.minus(other: Matrix([[4, 2, 1, 3]]), dim: 0).visible();
  mt.minus(other: Matrix([[4, 2, 1]]).T_, dim: 1).visible();
}
```
### output
```text
[
 [  0.00000   1.00000   2.00000   3.00000]
 [  4.00000   5.00000   6.00000   7.00000]
 [  8.00000   9.00000  10.00000  11.00000]
]
[
 [  0.00000   0.00000   0.00000   0.00000]
 [  0.00000   0.00000   0.00000   0.00000]
 [  0.00000   0.00000   0.00000   0.00000]
]
[
 [ -2.00000  -1.00000   0.00000   1.00000]
 [  2.00000   3.00000   4.00000   5.00000]
 [  6.00000   7.00000   8.00000   9.00000]
]
[
 [ -4.00000  -1.00000   1.00000   0.00000]
 [  0.00000   3.00000   5.00000   4.00000]
 [  4.00000   7.00000   9.00000   8.00000]
]
[
 [ -4.00000  -3.00000  -2.00000  -1.00000]
 [  2.00000   3.00000   4.00000   5.00000]
 [  7.00000   8.00000   9.00000  10.00000]
]
```
## multiply
- 两个矩阵同位置数据或者矩阵与数的乘法
- 该方法支持广播，dim为0则按照行方向，dim为1则按照列方向，其他则和两个同形状矩阵乘法一样的效果
```text
T multiply({required Object other, int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([List.generate(12, (_) => _ + 0.0)].reshape(row: 3, column: 4));
  mt.visible();
  mt.multiply(other: mt).visible();
  mt.multiply(other: 2).visible();
  mt.multiply(other: Matrix([[4, 2, 1, 3]]), dim: 0).visible();
  mt.multiply(other: Matrix([[4, 2, 1]]).T_, dim: 1).visible();
}
```
### output
```text
[
 [  0.00000   1.00000   2.00000   3.00000]
 [  4.00000   5.00000   6.00000   7.00000]
 [  8.00000   9.00000  10.00000  11.00000]
]
[
 [  0.00000   1.00000   4.00000   9.00000]
 [ 16.00000  25.00000  36.00000  49.00000]
 [ 64.00000  81.00000 100.00000 121.00000]
]
[
 [  0.00000   2.00000   4.00000   6.00000]
 [  8.00000  10.00000  12.00000  14.00000]
 [ 16.00000  18.00000  20.00000  22.00000]
]
[
 [  0.00000   2.00000   2.00000   9.00000]
 [ 16.00000  10.00000   6.00000  21.00000]
 [ 32.00000  18.00000  10.00000  33.00000]
]
[
 [  0.00000   4.00000   8.00000  12.00000]
 [  8.00000  10.00000  12.00000  14.00000]
 [  8.00000   9.00000  10.00000  11.00000]
]
```
## T divide({required Object other, int dim = -1})
- 两个矩阵同位置数据或者矩阵与数的除法
- 该方法支持广播，dim为0则按照行方向，dim为1则按照列方向，其他则和两个同形状矩阵除法一样的效果
```text

```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  var mt = Matrix.fromList([List.generate(12, (_) => _ + 0.0)].reshape(row: 3, column: 4));
  mt.visible();
  mt.divide(other: mt).visible();
  mt.divide(other: 2).visible();
  mt.divide(other: Matrix([[4, 2, 1, 3]]), dim: 0).visible();
  mt.divide(other: Matrix([[4, 2, 1]]).T_, dim: 1).visible();
}
```
### output
```text
[
 [  0.00000   1.00000   2.00000   3.00000]
 [  4.00000   5.00000   6.00000   7.00000]
 [  8.00000   9.00000  10.00000  11.00000]
]
[
 [      NaN   1.00000   1.00000   1.00000]
 [  1.00000   1.00000   1.00000   1.00000]
 [  1.00000   1.00000   1.00000   1.00000]
]
[
 [  0.00000   0.50000   1.00000   1.50000]
 [  2.00000   2.50000   3.00000   3.50000]
 [  4.00000   4.50000   5.00000   5.50000]
]
[
 [  0.00000   0.50000   2.00000   1.00000]
 [  1.00000   2.50000   6.00000   2.33333]
 [  2.00000   4.50000  10.00000   3.66667]
]
[
 [  0.00000   0.25000   0.50000   0.75000]
 [  2.00000   2.50000   3.00000   3.50000]
 [  8.00000   9.00000  10.00000  11.00000]
]
```
## fftComplex
- 快速傅里叶变换，基于Cooley–Tukey FFT algorithm
- 默认每行都是复数的实部和虚部，复数个数必须是2的幂
```text
T fftComplex() 
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%8.5f";
  var t1 = Matrix.fromList([
    [3, 6],
    [0, 2],
    [9, -0.2],
    [5, 2]
  ]);
  print(t1.fftComplex());
}
```
### output
```text
[
 [      17.00000        9.80000]
 [      -6.00000       11.20000]
 [       7.00000        1.80000]
 [      -6.00000        1.20000]
]
```
## toComplexLike
- 把一个row * column的矩阵转换为size个复数模样的矩阵，isReal为true表示矩阵的元素作为复数实部，反之为虚部
```text
##T toComplexLike({bool isReal = true})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.2f";
  var t1 = Matrix.fromList([
    [3, 6],
    [0, 2],
    [9, -0.2],
    [5, 2]
  ]);
  print(t1.toComplexLike(isReal: true));
  print(t1.toComplexLike(isReal: false));
}
```
### output
```text
[
 [ 3.00  0.00]
 [ 6.00  0.00]
 [ 0.00  0.00]
 [ 2.00  0.00]
 [ 9.00  0.00]
 [-0.20  0.00]
 [ 5.00  0.00]
 [ 2.00  0.00]
]
[
 [ 0.00  3.00]
 [ 0.00  6.00]
 [ 0.00  0.00]
 [ 0.00  2.00]
 [ 0.00  9.00]
 [ 0.00 -0.20]
 [ 0.00  5.00]
 [ 0.00  2.00]
]
```
## dftComplex
- 对一个复数矩阵进行傅里叶变换
```text
T dftComplex()
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.4f";
  var t1 = Matrix.fromList([
    [3, 6],
    [0, 2],
    [9, -0.2],
    [5, 2],
    [4, 7]
  ]);
  print(t1.dftComplex());
}
```
### output
```text
[
 [21.0000 16.8000]
 [-13.1386  8.7780]
 [ 3.2436  5.4304]
 [ 4.9368 -6.8803]
 [-1.0418  5.8718]
]
```
## dft
- 傅里叶变换
```text
List<List<Complex>> dft()
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.4f";
  var t1 = Matrix.fromList(List.generate(3, (r) => List.generate(4, (c) => r * 3.0 + c)))..visible();
  t1.dft().forEach((list) => list.forEach((c) => print(c)));
}
```
### output
```text
[
 [ 0.0000  1.0000  2.0000  3.0000]
 [ 3.0000  4.0000  5.0000  6.0000]
 [ 6.0000  7.0000  8.0000  9.0000]
]
Complex(54.0, 0.0)
Complex(-6.000000000000002, 5.999999999999998)
Complex(-6.0, -4.408728476930472e-15)
Complex(-5.999999999999992, -6.000000000000005)
Complex(-18.000000000000007, 10.39230484541326)
Complex(8.881784197001252e-15, 0.0)
Complex(6.217248937900877e-15, 6.217248937900877e-15)
Complex(8.881784197001252e-15, -4.440892098500626e-15)
Complex(-17.999999999999986, -10.392304845413282)
Complex(1.4210854715202004e-14, 1.509903313490213e-14)
Complex(0.0, 5.329070518200751e-15)
Complex(-3.552713678800501e-15, 1.3322676295501878e-14)
```
## diff
- 基于中心差分进行函数求导
```text
T diff(double Function(double) func)
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%10.5f";
  var t1 = Matrix.fromList(List.generate(3, (r) => List.generate(4, (c) => r * 3.0 + c)))..visible();
  f(double x) => x * 2 + 5 * sin(x) - exp(x * 2) + pow(5, 1 / (x + 1));
  f1(double x) => 2 + 5 * cos(x) - exp(x * 2) * 2 + pow(5, 1 / (x + 1)) * log(5) * (-1 / pow(x + 1, 2));
  var get1 = t1.diff(f)..visible();
  var get2 = t1.customize(f1)..visible();
  (get1 - get2).visible(format: "%3.8f");
}
```
### output
```text

[
 [         0.00000          1.00000          2.00000          3.00000]
 [         3.00000          4.00000          5.00000          6.00000]
 [         6.00000          7.00000          8.00000          9.00000]
]
[
 [        -3.04719        -10.97630       -109.58282       -809.95797]
 [      -809.95797      -5963.27302     -44049.57174    -325502.82332]
 [   -325502.82332   -2405202.82653  -17772219.69551 -131319936.34594]
]
[
 [        -3.04719        -10.97630       -109.58282       -809.95797]
 [      -809.95797      -5963.27302     -44049.57174    -325502.82332]
 [   -325502.82332   -2405202.82957  -17772219.79228 -131319940.84922]
]
[
 [ -0.00000000  -0.00000000   0.00000000   0.00000000]
 [  0.00000000  -0.00000036   0.00000059   0.00000185]
 [  0.00000185   0.00304389   0.09676288   4.50327742]
]
```
## sgn
- 映射为符号矩阵
```text
T get sgn
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var t1 = Matrix.fromList(
      List.generate(3, (r) => List.generate(4, (c) => r * 3.0 + c))
  )..[0][2] = -5
  ..[1][1] = double.nan
    ..visible();
  t1.sgn.visible();
}
```
### output
```text
[
 [  0   1  -5   3]
 [  3 NaN   5   6]
 [  6   7   8   9]
]
[
 [  0   1  -1   1]
 [  1 NaN   1   1]
 [  1   1   1   1]
]
```

[下一篇：一些机器学习工具的简单实现](ml.md)