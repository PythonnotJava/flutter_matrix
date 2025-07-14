# 几何模拟

> 该模块中返回的都是size * 2的形状的矩阵数据来表示size个点

## rotateTransform
- 点阵的旋转变换
- radian为true表示弧度制，否则角度制
```text
T rotateTransform({required double theta, bool radian = true})
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.2f";
  var t = Matrix.fromList(
    List.generate((10), (x) => [x.toDouble(), x * 2])
  )..visible();
  final a = t.rotateTransform(theta: 90, radian: false)..visible();
  final b = t.rotateTransform(theta: pi / 2, radian: true)..visible();
  print(a == b);
}
```
### output
```text
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
[
 [ 0.00  0.00]
 [-2.00  1.00]
 [-4.00  2.00]
 [-6.00  3.00]
 [-8.00  4.00]
 [-10.00  5.00]
 [-12.00  6.00]
 [-14.00  7.00]
 [-16.00  8.00]
 [-18.00  9.00]
]
[
 [ 0.00  0.00]
 [-2.00  1.00]
 [-4.00  2.00]
 [-6.00  3.00]
 [-8.00  4.00]
 [-10.00  5.00]
 [-12.00  6.00]
 [-14.00  7.00]
 [-16.00  8.00]
 [-18.00  9.00]
]
true
```

## projectionTransform
- 投影变换, ux和uy分别是x轴和y轴上的投影分量
```text
T projectionTransform({required double ux, required double uy})
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.2f";
  var t = Matrix.fromList(
      List.generate((10), (x) => [x.toDouble(), x * 2])
  )..visible();
  // 投到y轴上
  t.projectionTransform(ux: 0, uy: 1).visible();
  // 投到x轴上
  t.projectionTransform(ux: 1, uy: 0).visible();
  // 投到y = x上
  t.projectionTransform(ux: 1 / sqrt2, uy: 1 / sqrt2).visible();
}
```
### output
```text
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
[
 [ 0.00  0.00]
 [ 0.00  2.00]
 [ 0.00  4.00]
 [ 0.00  6.00]
 [ 0.00  8.00]
 [ 0.00 10.00]
 [ 0.00 12.00]
 [ 0.00 14.00]
 [ 0.00 16.00]
 [ 0.00 18.00]
]
[
 [ 0.00  0.00]
 [ 1.00  0.00]
 [ 2.00  0.00]
 [ 3.00  0.00]
 [ 4.00  0.00]
 [ 5.00  0.00]
 [ 6.00  0.00]
 [ 7.00  0.00]
 [ 8.00  0.00]
 [ 9.00  0.00]
]
[
 [ 0.00  0.00]
 [ 1.50  1.50]
 [ 3.00  3.00]
 [ 4.50  4.50]
 [ 6.00  6.00]
 [ 7.50  7.50]
 [ 9.00  9.00]
 [10.50 10.50]
 [12.00 12.00]
 [13.50 13.50]
]
```

## shearTransform
- 剪切变换，alongX为true表示沿着x轴，否则沿着y轴
```text
T shearTransform({required double k, bool alongX = true})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.2f";
  var t = Matrix.fromList(
      List.generate((10), (x) => [x.toDouble(), x * 2])
  )..visible();
  t.shearTransform(k: 2, alongX: true).visible();
  t.shearTransform(k: 2, alongX: false).visible();
}
```
### output
```text
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
[
 [ 0.00  0.00]
 [ 5.00  2.00]
 [10.00  4.00]
 [15.00  6.00]
 [20.00  8.00]
 [25.00 10.00]
 [30.00 12.00]
 [35.00 14.00]
 [40.00 16.00]
 [45.00 18.00]
]
[
 [ 0.00  0.00]
 [ 1.00  4.00]
 [ 2.00  8.00]
 [ 3.00 12.00]
 [ 4.00 16.00]
 [ 5.00 20.00]
 [ 6.00 24.00]
 [ 7.00 28.00]
 [ 8.00 32.00]
 [ 9.00 36.00]
]
```

## scaleTransform
- 缩放变换，sx和sy分别是x轴和y轴坐标的缩放倍数
```text
T scaleTransform({required double sx, required double sy})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.2f";
  var t = Matrix.fromList(
      List.generate((10), (x) => [x.toDouble(), x * 2])
  )..visible();
  t
    ..scaleTransform(sx: 2, sy: 1)
    ..visible()
    ..scaleTransform(sx: 1, sy: 2)
    ..visible()
    ..scaleTransform(sx: 0.5, sy: 0.5)
    ..visible();
}
```
### output
```text
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
[
 [ 0.00  0.00]
 [ 1.00  2.00]
 [ 2.00  4.00]
 [ 3.00  6.00]
 [ 4.00  8.00]
 [ 5.00 10.00]
 [ 6.00 12.00]
 [ 7.00 14.00]
 [ 8.00 16.00]
 [ 9.00 18.00]
]
```

## curve
- 生成从x1到x2的数据（允许x1不小于x2）
- bias是数据的随机偏移，不传入则不偏移，便宜范围是(-bias,bias)
- uniform表示生成的数据是否均匀还是区间内随机性的
- vec是相对坐标
```text
static T curve<T extends MatrixBase<T>>(
      {required double Function(double) func,
      required double x1,
      required double x2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.2f";
  MatrixGeometry.curve<Matrix>(func: (x) => x * 2, x1: 0, x2: 5, size: 10, uniform: true).visible();
  MatrixGeometry.curve<Matrix>(func: (x) => x * 2, x1: 5, x2: 0, size: 10, uniform: true).visible();
  // y = 2 * x + 1
  MatrixGeometry.curve<Matrix>(func: (x) => x * 2, x1: 0, x2: 5, size: 10, vec: [0, 1], uniform: true).visible(format: "%2.5f");
  MatrixGeometry.curve<Matrix>(func: (x) => x * 2, x1: 5, x2: 9, size: 10, bias: 1, uniform: false).visible();
}
```
### output
```text
[
 [ 0.00  0.00]
 [ 0.56  1.11]
 [ 1.11  2.22]
 [ 1.67  3.33]
 [ 2.22  4.44]
 [ 2.78  5.56]
 [ 3.33  6.67]
 [ 3.89  7.78]
 [ 4.44  8.89]
 [ 5.00 10.00]
]
[
 [ 5.00 10.00]
 [ 4.44  8.89]
 [ 3.89  7.78]
 [ 3.33  6.67]
 [ 2.78  5.56]
 [ 2.22  4.44]
 [ 1.67  3.33]
 [ 1.11  2.22]
 [ 0.56  1.11]
 [ 0.00  0.00]
]
[
 [ 0.00000  1.00000]
 [ 0.55556  2.11111]
 [ 1.11111  3.22222]
 [ 1.66667  4.33333]
 [ 2.22222  5.44444]
 [ 2.77778  6.55556]
 [ 3.33333  7.66667]
 [ 3.88889  8.77778]
 [ 4.44444  9.88889]
 [ 5.00000 11.00000]
]
[
 [ 5.95 11.71]
 [ 7.45 14.43]
 [ 8.09 15.70]
 [ 5.48 10.99]
 [ 8.78 17.94]
 [ 7.56 15.24]
 [ 7.20 15.13]
 [ 6.81 14.29]
 [ 5.18 10.51]
 [ 8.43 16.87]
]
```

## custom_curve
- 根据参数方程定义任意曲线。theta_from和theta_to表示参数的范围
```text
static T custom_curve<T extends MatrixBase<T>>(
      {required double Function(double) xfunc,
      required double Function(double) yfunc,
      required double theta_from,
      required double theta_to,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector})
```
### test
```text
import 'dart:math';

import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  // ⚪: x^ 2 + y^2 = 4 
  MatrixGeometry.custom_curve<Matrix>(
      xfunc: (x) => 2.0 * cos(x),
      yfunc: (y) => 2.0 * sin(y),
      theta_from: 0,
      theta_to: 2 * pi,
      size: 10,
      uniform: true
  ).visible();
}
```
### output
```text
[
 [ 2.00000  0.00000]
 [ 1.53209  1.28558]
 [ 0.34730  1.96962]
 [-1.00000  1.73205]
 [-1.87939  0.68404]
 [-1.87939 -0.68404]
 [-1.00000 -1.73205]
 [ 0.34730 -1.96962]
 [ 1.53209 -1.28558]
 [ 2.00000 -0.00000]
]
```

## ellipse_edge
- 椭圆边缘数据模拟，a是长轴半径，b是短轴半径
- circle_edge类似使用方法
```text
static T ellipse_edge<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  // (x - 2) ^ 2 / 16 + (y - 2) ^ 2 / 9 = 1的椭圆
  MatrixGeometry.ellipse_edge<Matrix>(a: 4, b: 3, size: 20, uniform: true, vec: [2, 1])
    ..visible();
}
```
### output
```text
[
 [ 6.00000  1.00000]
 [ 5.78327  1.97410]
 [ 5.15656  2.84264]
 [ 4.18779  3.51150]
 [ 2.98194  3.90820]
 [ 1.66968  3.98975]
 [ 0.39322  3.74732]
 [-0.70913  3.20717]
 [-1.51790  2.42784]
 [-1.94545  1.49378]
 [-1.94545  0.50622]
 [-1.51790 -0.42784]
 [-0.70913 -1.20717]
 [ 0.39322 -1.74732]
 [ 1.66968 -1.98975]
 [ 2.98194 -1.90820]
 [ 4.18779 -1.51150]
 [ 5.15656 -0.84264]
 [ 5.78327  0.02590]
 [ 6.00000  1.00000]
]
```

## ellipse_area
- 椭圆内部数据的模拟
- circle_area类似使用方法
```text
static T ellipse_area<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required int size,
      int? seed,
      bool uniform = true,
      List<double> vec = OriginVector})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  // x ^ 2 / 16 + y ^ 2 / 9 = 1的椭圆
  MatrixGeometry.ellipse_area<Matrix>(a: 4, b: 3, size: 20, uniform: true).visible();
}
```
### output
```text
[
 [ 3.22287  0.00000]
 [ 0.46328  0.02573]
 [ 2.98519  1.13001]
 [ 2.26187  1.06242]
 [ 0.38793  1.27462]
 [ 0.00000  0.81251]
 [-0.25467  0.20340]
 [-1.32227  1.69598]
 [-3.05319  0.79245]
 [-2.60754  0.67613]
 [-0.37296  0.00000]
 [-1.64220 -0.87490]
 [-0.01710 -0.56296]
 [-1.99511 -0.21927]
 [-0.70147 -1.56219]
 [-0.00000 -1.86214]
 [ 0.08222 -2.06282]
 [ 0.20992 -1.01844]
 [ 1.71985 -0.14007]
 [ 1.54497 -0.59273]
]
```

## line
- 根据斜率和偏移模拟直线
```text
static T line<T extends MatrixBase<T>>(
      {required double k,
      required double b,
      required double x1,
      required double x2,
      required int size,
      int? seed,
      double? bias,
      bool uniform = true,
      List<double> vec = OriginVector}) 
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  // y = 2 * x - 1
  MatrixGeometry.line<Matrix>(k: 2, b: -1, x1: -1, x2: 1, size: 10, uniform: false).visible();
  MatrixGeometry.line<Matrix>(k: 2, b: -1, x1: -1, x2: 1, size: 10, uniform: true).visible();
}
```
### output
```text
[
 [-0.54631 -2.09261]
 [ 0.95080  0.90159]
 [ 0.03006 -0.93987]
 [ 0.54977  0.09954]
 [-0.80347 -2.60695]
 [ 0.86927  0.73855]
 [ 0.81680  0.63361]
 [-0.79911 -2.59822]
 [-0.31727 -1.63453]
 [ 0.11127 -0.77746]
]
[
 [-1.00000 -3.00000]
 [-0.77778 -2.55556]
 [-0.55556 -2.11111]
 [-0.33333 -1.66667]
 [-0.11111 -1.22222]
 [ 0.11111 -0.77778]
 [ 0.33333 -0.33333]
 [ 0.55556  0.11111]
 [ 0.77778  0.55556]
 [ 1.00000  1.00000]
]
```

## xline
- 与x轴平行的线：y = a
```text
static List<List<double>> xline(
          {required double a,
          required double x1,
          required double x2,
          required int size,
          int? seed,
          double? bias,
          bool uniform = true,
          List<double> vec = OriginVector})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  // y = 3
  MatrixGeometry.xline<Matrix>(a: 3, x1: 5, x2: 10, size: 10, uniform: true).visible();
}
```
### output
```text
[
 [ 5.00000  3.00000]
 [ 5.55556  3.00000]
 [ 6.11111  3.00000]
 [ 6.66667  3.00000]
 [ 7.22222  3.00000]
 [ 7.77778  3.00000]
 [ 8.33333  3.00000]
 [ 8.88889  3.00000]
 [ 9.44444  3.00000]
 [10.00000  3.00000]
]
```

## yline
- 与y轴平行的直线：x = a
```text
static List<List<double>> yline(
          {required double a,
          required double y1,
          required double y2,
          required int size,
          int? seed,
          double? bias,
          bool uniform = true,
          List<double> vec = OriginVector})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  // x = 3
  MatrixGeometry.yline<Matrix>(a: 3, y1: 1, y2: 19, size: 10).visible();
}
```
### output
```text
[
 [ 3.00000  1.00000]
 [ 3.00000  3.00000]
 [ 3.00000  5.00000]
 [ 3.00000  7.00000]
 [ 3.00000  9.00000]
 [ 3.00000 11.00000]
 [ 3.00000 13.00000]
 [ 3.00000 15.00000]
 [ 3.00000 17.00000]
 [ 3.00000 19.00000]
]
```

## camera
- eye是视觉点，a、b、c、d表示ax + by + cz + d = 0这个平面，target是表示目标的点集
```text
static T camera<T extends MatrixBase<T>>({
    required List<double> eye,
    required List<List<double>> target,
    required double a,
    required double b,
    required double c,
    required double d,
  }) 
```

### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.10f";
  List<List<double>> vertices = [
    [0, 0, 1],
    [-1, -1, 0],
    [1, -1, 0],
    [1, 1, 0],
    [-1, 1, 0]
  ];
  var mt = MatrixGeometry.camera<Matrix>(eye: <double>[2, 6, 9], target: vertices, a: 1, b: 1, c: 2, d: 1);
  mt.visible();
}
```

### output
```text
[
 [-0.2500000000 -0.7500000000  0.0000000000]
 [-0.8928571429 -0.7500000000  0.3214285714]
 [ 0.9615384615 -1.2692307692 -0.3461538462]
 [ 0.8750000000  0.3750000000 -1.1250000000]
 [-1.1153846154  0.8076923077 -0.3461538462]
]
```

[下一篇：线性代数](linalg.md)


