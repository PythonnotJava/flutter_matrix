# 纯数学工具

## min
> Object min({int dim = -1})
> 
> 获取最小值  
> 注意：double.nan也会参与到比较中，因此要提前处理，很多操作都需注意
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, -double.infinity, 9],
    [5, 6, 3, double.nan],
    [1, 2, 3, double.infinity],
  ];
  var mt = Matrix.fromList(data);
  print(mt.min(dim: 0));
  print(mt.min(dim: 1));
  print(mt.min(dim: 11));
}
```
### output
```text
[0.0, -Infinity, NaN, 1.0]
[0.0, 1.0, -Infinity, NaN]
NaN
```
## max
> Object max({int dim = -1})
> 
> 获取最小值
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, double.infinity, 9],
    [5, 6, 3, double.nan],
    [1, 2, 3, -double.infinity],
  ];
  var mt = Matrix.fromList(data);
  print(mt.max(dim: 0));
  print(mt.max(dim: 1));
  print(mt.max(dim: 11));
}
```
### output
```text
[9.0, Infinity, NaN, 3.0]
[5.0, 6.0, Infinity, NaN]
NaN
```
## argmin
> Object argmin({int dim = -1})
> 
> 获取最小值索引，如果多个相同，只返回第一个
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, -double.infinity, 9],
    [5, 6, 3, -32],
    [1, 2, 3, -double.infinity],
  ];
  var mt = Matrix.fromList(data);
  print(mt.argmin(dim: 0));
  print(mt.argmin(dim: 1));
  print(mt.argmin(dim: 11));
}
```
### output
```text
[2, 2, 3, 3]
[1, 0, 1, 3]
6
```
## argmin
> Object argmin({int dim = -1})
>
> 获取最大值索引，如果多个相同，只返回第一个
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, -double.infinity, 9],
    [5, 6, 3, -32],
    [1, 2, 3, -double.infinity],
  ];
  var mt = Matrix.fromList(data);
  print(mt.argmax(dim: 0));
  print(mt.argmax(dim: 1));
  print(mt.argmax(dim: 11));
}
```
### output
```text
[3, 3, 1, 2]
[2, 2, 2, 0]
3
```
## get_range
> Object get_range({int dim = -1})
> 
> 获取数据范围
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, -double.infinity, 9],
    [5, 6, 3, -32],
    [1, 2, 3, -double.infinity],
  ];
  var mt = Matrix.fromList(data);
  print(mt.get_range(dim: 0));
  print(mt.get_range(dim: 1));
  print(mt.get_range(dim: 11));
}
```
### output
```text
[[0.0, 9.0], [-Infinity, 9.0], [-32.0, 6.0], [-Infinity, 3.0]]
[[0.0, 5.0], [1.0, 6.0], [-Infinity, 3.0], [-Infinity, 9.0]]
[-Infinity, 9.0]
```
## sum
> Object sum({int dim = -1})
> 
> 数据求和
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, -double.infinity, 9],
    [5, 6, 3, -32],
    [1, 2, 3, -double.infinity],
  ];
  var mt = Matrix.fromList(data);
  print(mt.sum(dim: 0));
  print(mt.sum(dim: 1));
  mt.setMask(nag_inf_mask: 0);
  print(mt.sum(dim: 11));
}
```
### output
```text
[14.0, -Infinity, -18.0, -Infinity]
[10.0, 12.0, -Infinity, -Infinity]
14.0
```
## 基础数学函数集合
```text
Matrix get sin => _math_basement_single_realize(0);  // 正弦函数
Matrix get cos => _math_basement_single_realize(1);  // 余弦函数
Matrix get tan => _math_basement_single_realize(2);  // 正切函数
Matrix get asin => _math_basement_single_realize(3);  // 反正弦函数
Matrix get acos => _math_basement_single_realize(4);  // 反余弦函数
Matrix get atan => _math_basement_single_realize(5);  // 反正切函数
Matrix get sinh => _math_basement_single_realize(6);  // 双曲正弦函数
Matrix get cosh => _math_basement_single_realize(7);  // 双曲余弦函数
Matrix get tanh => _math_basement_single_realize(8);  // 双曲正切函数
Matrix get asinh => _math_basement_single_realize(9);  // 反双曲正弦函数
Matrix get acosh => _math_basement_single_realize(10);  // 反双曲余弦函数
Matrix get atanh => _math_basement_single_realize(11);  // 反双曲正切函数
Matrix get exp => _math_basement_single_realize(12);  // e^(x)
Matrix get log => _math_basement_single_realize(13);  // ln(x)
Matrix get sqrt => _math_basement_single_realize(14);  // 二次开根
Matrix get log10 => _math_basement_single_realize(15);  // 以10为底数的对数函数
Matrix get square => _math_basement_single_realize(16);  // 平方
Matrix get cube => _math_basement_single_realize(17);  // 三次方
Matrix get abs => _math_basement_single_realize(18);  // 绝对值
Matrix get ceil => _math_basement_single_realize(19);  // 向上取整
Matrix get floor => _math_basement_single_realize(20);  // 向下取整
Matrix get round => _math_basement_single_realize(21);  // 四舍五入函数
Matrix get degree => _math_basement_single_realize(22);  // 弧度转角度
Matrix get radian => _math_basement_single_realize(23);  // 角度转弧度
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.5f";
  Matrix matrix = Matrix([
    [0.0, pi / 2, pi],
    [-pi / 4, -1.0, 1.0],
    [2.0, -2.0, 0.5]
  ]);
  print('----------------------------------------');
  matrix.visible(start_point: 'Original Matrix', end_point: '----------------------------------------');
  matrix.sin.visible(start_point: 'func "sin"', end_point: '----------------------------------------');
  matrix.cos.visible(start_point: 'func "cos"', end_point: '----------------------------------------');
  // 注意，这里有一个计算精度不足引起的意外值，tan(pi / 2)
  matrix.tan.visible(start_point: 'func "tan"', end_point: '----------------------------------------');
  matrix.asin.visible(start_point: 'func "asin"', end_point: '----------------------------------------');
  matrix.acos.visible(start_point: 'func "acos"', end_point: '----------------------------------------');
  matrix.atan.visible(start_point: 'func "atan"', end_point: '----------------------------------------');
  matrix.sinh.visible(start_point: 'func "sinh"', end_point: '----------------------------------------');
  matrix.cosh.visible(start_point: 'func "cosh"', end_point: '----------------------------------------');
  matrix.tanh.visible(start_point: 'func "tanh"', end_point: '----------------------------------------');
  matrix.asinh.visible(start_point: 'func "asinh"', end_point: '----------------------------------------');
  matrix.acosh.visible(start_point: 'func "acosh"', end_point: '----------------------------------------');
  matrix.atanh.visible(start_point: 'func "atanh"', end_point: '----------------------------------------');
  matrix.exp.visible(start_point: 'func "exp"', end_point: '----------------------------------------');
  matrix.log.visible(start_point: 'func "log (ln)"', end_point: '----------------------------------------');
  matrix.sqrt.visible(start_point: 'func "sqrt"', end_point: '----------------------------------------');
  matrix.log10.visible(start_point: 'func "log10"', end_point: '----------------------------------------');
  matrix.square.visible(start_point: 'func "square"', end_point: '----------------------------------------');
  matrix.cube.visible(start_point: 'func "cube"', end_point: '----------------------------------------');
  matrix.abs.visible(start_point: 'func "abs"', end_point: '----------------------------------------');
  matrix.ceil.visible(start_point: 'func "ceil"', end_point: '----------------------------------------');
  matrix.floor.visible(start_point: 'func "floor"', end_point: '----------------------------------------');
  matrix.round.visible(start_point: 'func "round"', end_point: '----------------------------------------');
  matrix.degree.visible(start_point: 'func "degree"', end_point: '----------------------------------------');
  matrix.radian.visible(start_point: 'func "radian"', end_point: '----------------------------------------');
}
```
### output
```text
----------------------------------------
Original Matrix
[
 [  0.00000   1.57080   3.14159]
 [ -0.78540  -1.00000   1.00000]
 [  2.00000  -2.00000   0.50000]
]
----------------------------------------
func "sin"
[
 [  0.00000   1.00000   0.00000]
 [ -0.70711  -0.84147   0.84147]
 [  0.90930  -0.90930   0.47943]
]
----------------------------------------
func "cos"
[
 [  1.00000   0.00000  -1.00000]
 [  0.70711   0.54030   0.54030]
 [ -0.41615  -0.41615   0.87758]
]
----------------------------------------
func "tan"
[
 [  0.00000 16331239353195370.00000  -0.00000]
 [ -1.00000  -1.55741   1.55741]
 [ -2.18504   2.18504   0.54630]
]
----------------------------------------
func "asin"
[
 [  0.00000       NaN       NaN]
 [ -0.90334  -1.57080   1.57080]
 [      NaN       NaN   0.52360]
]
----------------------------------------
func "acos"
[
 [  1.57080       NaN       NaN]
 [  2.47414   3.14159   0.00000]
 [      NaN       NaN   1.04720]
]
----------------------------------------
func "atan"
[
 [  0.00000   1.00388   1.26263]
 [ -0.66577  -0.78540   0.78540]
 [  1.10715  -1.10715   0.46365]
]
----------------------------------------
func "sinh"
[
 [  0.00000   2.30130  11.54874]
 [ -0.86867  -1.17520   1.17520]
 [  3.62686  -3.62686   0.52110]
]
----------------------------------------
func "cosh"
[
 [  1.00000   2.50918  11.59195]
 [  1.32461   1.54308   1.54308]
 [  3.76220   3.76220   1.12763]
]
----------------------------------------
func "tanh"
[
 [  0.00000   0.91715   0.99627]
 [ -0.65579  -0.76159   0.76159]
 [  0.96403  -0.96403   0.46212]
]
----------------------------------------
func "asinh"
[
 [  0.00000   1.23340   1.86230]
 [ -0.72123  -0.88137   0.88137]
 [  1.44364  -1.44364   0.48121]
]
----------------------------------------
func "acosh"
[
 [      NaN   1.02323   1.81153]
 [      NaN       NaN   0.00000]
 [  1.31696       NaN       NaN]
]
----------------------------------------
func "atanh"
[
 [  0.00000       NaN       NaN]
 [ -1.05931 -Infinity  Infinity]
 [      NaN       NaN   0.54931]
]
----------------------------------------
func "exp"
[
 [  1.00000   4.81048  23.14069]
 [  0.45594   0.36788   2.71828]
 [  7.38906   0.13534   1.64872]
]
----------------------------------------
func "log (ln)"
[
 [-Infinity   0.45158   1.14473]
 [      NaN       NaN   0.00000]
 [  0.69315       NaN  -0.69315]
]
----------------------------------------
func "sqrt"
[
 [  0.00000   1.25331   1.77245]
 [      NaN       NaN   1.00000]
 [  1.41421       NaN   0.70711]
]
----------------------------------------
func "log10"
[
 [-Infinity   0.19612   0.49715]
 [      NaN       NaN   0.00000]
 [  0.30103       NaN  -0.30103]
]
----------------------------------------
func "square"
[
 [  0.00000   2.46740   9.86960]
 [  0.61685   1.00000   1.00000]
 [  4.00000   4.00000   0.25000]
]
----------------------------------------
func "cube"
[
 [  0.00000   3.87578  31.00628]
 [ -0.48447  -1.00000   1.00000]
 [  8.00000  -8.00000   0.12500]
]
----------------------------------------
func "abs"
[
 [  0.00000   1.57080   3.14159]
 [  0.78540   1.00000   1.00000]
 [  2.00000   2.00000   0.50000]
]
----------------------------------------
func "ceil"
[
 [  0.00000   2.00000   4.00000]
 [ -0.00000  -1.00000   1.00000]
 [  2.00000  -2.00000   1.00000]
]
----------------------------------------
func "floor"
[
 [  0.00000   1.00000   3.00000]
 [ -1.00000  -1.00000   1.00000]
 [  2.00000  -2.00000   0.00000]
]
----------------------------------------
func "round"
[
 [  0.00000   2.00000   3.00000]
 [ -1.00000  -1.00000   1.00000]
 [  2.00000  -2.00000   1.00000]
]
----------------------------------------
func "degree"
[
 [  0.00000  90.00000 180.00000]
 [-45.00000 -57.29578  57.29578]
 [114.59156 -114.59156  28.64789]
]
----------------------------------------
func "radian"
[
 [  0.00000   0.02742   0.05483]
 [ -0.01371  -0.01745   0.01745]
 [  0.03491  -0.03491   0.00873]
]
----------------------------------------
```
## power
> Matrix power({required double number, bool reverse = false})
> 
> 矩阵数据的幂次方，如果反转则表示数据的矩阵数据次方
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.5f";
  Matrix matrix = Matrix.fromList([
    [1, 2, 3],
    [3, 7, 9]
  ]);
  matrix.power(number: 0.5, reverse: false).visible();
  matrix.power(number: 0.5, reverse: true).visible();
}
```
### output
```text
[
 [  1.00000   1.41421   1.73205]
 [  1.73205   2.64575   3.00000]
]
[
 [  0.50000   0.25000   0.12500]
 [  0.12500   0.00781   0.00195]
]
```
## atan2
> Matrix atan2({required double number, bool reverse = false})
> 
> 四象限的反正切函数
### test
```text
import 'dart:math';
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.5f";
  Matrix matrix = Matrix.fromList([
    [1, -1, 0],
  ]);
  matrix.atan2(number: -1, reverse: false).visible();
  matrix.atan2(number: -1, reverse: true).visible();
  matrix.atan2(number: -1, reverse: false).degree.visible();
  matrix.atan2(number: -1, reverse: true).degree.visible();
}
```
### output
```text
[
 [  2.35619  -2.35619   3.14159]
]
[
 [ -0.78540  -2.35619  -1.57080]
]
[
 [135.00000 -135.00000 180.00000]
]
[
 [-45.00000 -135.00000 -90.00000]
]
```
## diff
> Matrix diff(double Function(double) func)
> 
> 中心差分函数，借鉴于[GSL2.8](https://www.gnu.org/software/gsl/)  
> 案例请查看：[customize](functools.md#customize)
## dft_complex
> Matrix dft_complex()
> 
> 操作矩阵必须是`row*2`形状，将矩阵每行视为复数的实部和虚部并进行离散傅里叶变换
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  Matrix matrix = MatrixGeometry.curve(func: (x) => cos(x), x1: 0, x2: 1, size: 20)..visible();
  matrix.dft_complex().visible();
}
```
### output
```text
[
 [ 0.00  1.00]
 [ 0.05  1.00]
 [ 0.11  0.99]
 [ 0.16  0.99]
 [ 0.21  0.98]
 [ 0.26  0.97]
 [ 0.32  0.95]
 [ 0.37  0.93]
 [ 0.42  0.91]
 [ 0.47  0.89]
 [ 0.53  0.86]
 [ 0.58  0.84]
 [ 0.63  0.81]
 [ 0.68  0.77]
 [ 0.74  0.74]
 [ 0.79  0.70]
 [ 0.84  0.67]
 [ 0.89  0.63]
 [ 0.95  0.58]
 [ 1.00  0.54]
]
[
 [10.00 16.75]
 [ 1.11  3.09]
 [ 0.26  1.75]
 [-0.03  1.23]
 [-0.18  0.94]
 [-0.27  0.76]
 [-0.34  0.62]
 [-0.40  0.51]
 [-0.44  0.41]
 [-0.49  0.32]
 [-0.53  0.24]
 [-0.57  0.16]
 [-0.61  0.07]
 [-0.66 -0.03]
 [-0.71 -0.15]
 [-0.78 -0.30]
 [-0.87 -0.51]
 [-1.02 -0.84]
 [-1.31 -1.49]
 [-2.17 -3.55]
]
```
## fft_complex
> Matrix fft_complex()
> 
> 快速傅里叶变换版本，必须保证row大小是不小于2且是2的幂次方
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  Matrix matrix = MatrixGeometry.curve(func: (x) => cos(x), x1: 0, x2: 1, size: 16)..visible();
  matrix.fft_complex().visible();
}
```
### output
```text
[
 [ 0.00  1.00]
 [ 0.07  1.00]
 [ 0.13  0.99]
 [ 0.20  0.98]
 [ 0.27  0.96]
 [ 0.33  0.94]
 [ 0.40  0.92]
 [ 0.47  0.89]
 [ 0.53  0.86]
 [ 0.60  0.83]
 [ 0.67  0.79]
 [ 0.73  0.74]
 [ 0.80  0.70]
 [ 0.87  0.65]
 [ 0.93  0.60]
 [ 1.00  0.54]
]
[
 [ 8.00 13.39]
 [ 0.81  2.55]
 [ 0.10  1.45]
 [-0.15  1.01]
 [-0.27  0.76]
 [-0.36  0.59]
 [-0.43  0.46]
 [-0.48  0.35]
 [-0.53  0.24]
 [-0.58  0.14]
 [-0.64  0.02]
 [-0.71 -0.12]
 [-0.79 -0.30]
 [-0.92 -0.59]
 [-1.16 -1.13]
 [-1.87 -2.82]
]
```

## dft
> List<List<Complex>> dft()
> 
> dft是二维矩阵的离散傅里叶变换，操作对象是每个实数数据点，生成的是处理好的复数二维列表
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  Matrix matrix = Matrix.linspace(start: 0, end: 1, row: 1, column: 20)..visible();
  Matrix cos_ = matrix.cos..visible();
  print(cos_.dft());
}
```
### output
```text
[
 [ 0.00  0.05  0.11  0.16  0.21  0.26  0.32  0.37  0.42  0.47  0.53  0.58  0.63  0.68  0.74  0.79  0.84  0.89  0.95  1.00]
]
[
 [ 1.00  1.00  0.99  0.99  0.98  0.97  0.95  0.93  0.91  0.89  0.86  0.84  0.81  0.77  0.74  0.70  0.67  0.63  0.58  0.54]
]
[[Complex(16.75440903166811, 0.0), Complex(-0.22811740242052814, -1.6397084473410628), Complex(0.13183474464253353, -0.7823464082156386), Complex(0.1967357416501282, -0.496947233565983), Complex(0.21922035792340794, -0.3480366366936396), Complex(0.2294742441387881, -0.2527066108991086), Complex(0.23488177535739072, -0.1835420189577598), Complex(0.23795253166182712, -0.12869438763744284), Complex(0.2397154208503811, -0.08205846872985462), Complex(0.24063637522371917, -0.039997759504330294), Complex(0.2409233902765915, -3.069124650216493e-15), Complex(0.2406363752237164, 0.03999775950432752), Complex(0.23971542085038544, 0.08205846872986033), Complex(0.23795253166180874, 0.1286943876374329), Complex(0.2348817753573971, 0.18354201895776023), Complex(0.22947424413878847, 0.25270661089910473), Complex(0.21922035792341624, 0.34803663669363605), Complex(0.196735741650134, 0.4969472335659874), Complex(0.1318347446425323, 0.782346408215624), Complex(-0.22811740242051415, 1.6397084473410648)]]
```

[下一篇：概率论与数理统计](random.md)