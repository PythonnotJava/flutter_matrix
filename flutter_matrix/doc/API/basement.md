# 基础操作

## visible
> void visible({String? format, String color = '#ffd700', String? start_point, String? end_point})
> 
> 快速可视化矩阵，在[toString](define.md#string-tostring)函数的无返回版本基础上，添加了输出前和输出后的额外信息

### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var m = Matrix.E(n: 4);
  m.visible(start_point: "Create an identity matrix.", end_point: "It's Ok!");
}
```
### output
```text
Create an identity matrix.
[
 [1.00000 0.00000 0.00000 0.00000]
 [0.00000 1.00000 0.00000 0.00000]
 [0.00000 0.00000 1.00000 0.00000]
 [0.00000 0.00000 0.00000 1.00000]
]
It's Ok!
```
## hasSameShape
> bool hasSameShape(Matrix other)
> 
> 判断两个矩阵形状一样吗
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
    [1, 2, 3, 8],
  ];
  var mt1 = Matrix.fromList(data);
  var mt2 = Matrix.E(n: 4);
  print(mt1.hasSameShape(mt2));
}
```
### output
```text
true
```
## isSameObj
> bool isSameObj(Matrix other)
> 
> 判断两个据说是不是完全是一个对象，判断二维列表和矩阵实例
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
    [1, 2, 3, 8],
  ];
  var mt1 = Matrix.fromList(data);
  var mt2 = Matrix.fromList(data);
  print(mt1.isSameObj(mt2));
}
```
### output
```text
false
```
## add/minus/multiply/divide
> Matrix add({Matrix? other, double? number, int dim = -1})
> 
> 加减乘除运算，与重载`+`/`-`/`*`/`/`同种效果，且都支持简单的[广播](https://numpy.org/doc/stable/user/basics.broadcasting.html)
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
  var mt1 = Matrix.fromList(data);
  var mt2 = Matrix.fromList(data);
  print(mt1.add(other: mt2));
  print(mt2.add(number: 10.0));
  print(mt2.multiply(other: mt2));
  print(mt1 / double.nan);
  Matrix.E_like(row: 3, column: 4).minus(number: 1.0).visible();
  mt1.divide(other: Matrix.fromList([[-1, 1, 2, 3]]), dim: 0).visible();
  mt1.divide(other: Matrix.fromList([[-1], [1], [2], [3]]), dim: 1).visible();
}
```
### output
```text
[
 [ 8.0  2.0  0.0 18.0]
 [ 0.0  6.0  2.0 18.0]
 [10.0 12.0  6.0  4.0]
 [ 2.0  4.0  6.0 16.0]
]
[
 [14.0 11.0 10.0 19.0]
 [10.0 13.0 11.0 19.0]
 [15.0 16.0 13.0 12.0]
 [11.0 12.0 13.0 18.0]
]
[
 [16.0  1.0  0.0 81.0]
 [ 0.0  9.0  1.0 81.0]
 [25.0 36.0  9.0  4.0]
 [ 1.0  4.0  9.0 64.0]
]
[
 [ NaN  NaN  NaN  NaN]
 [ NaN  NaN  NaN  NaN]
 [ NaN  NaN  NaN  NaN]
 [ NaN  NaN  NaN  NaN]
]
[
 [ 0.0 -1.0 -1.0 -1.0]
 [-1.0  0.0 -1.0 -1.0]
 [-1.0 -1.0  0.0 -1.0]
]
[
 [-4.0  1.0  0.0  3.0]
 [-0.0  3.0  0.5  3.0]
 [-5.0  6.0  1.5  0.7]
 [-1.0  2.0  1.5  2.7]
]
[
 [-4.0 -1.0 -0.0 -9.0]
 [ 0.0  3.0  1.0  9.0]
 [ 2.5  3.0  1.5  1.0]
 [ 0.3  0.7  1.0  2.7]
]
```
## concat
> Matrix concat({required Matrix other, bool horizontal = true})
> 
> 拼接两个矩阵，可以从横向，也可以从纵向
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%1.0f";
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
    [1, 2, 3, 8],
  ];
  var mt1 = Matrix.fromList(data);
  var mt2 = Matrix.E(n: 4);
  mt2.concat(other: mt1, horizontal: false).visible();
  mt2.concat(other: mt1, horizontal: true).visible();
}
```
### output
```text
[
 [ 1  0  0  0]
 [ 0  1  0  0]
 [ 0  0  1  0]
 [ 0  0  0  1]
 [ 4  1  0  9]
 [ 0  3  1  9]
 [ 5  6  3  2]
 [ 1  2  3  8]
]
[
 [ 1  0  0  0  4  1  0  9]
 [ 0  1  0  0  0  3  1  9]
 [ 0  0  1  0  5  6  3  2]
 [ 0  0  0  1  1  2  3  8]
]
```
## reshape
> Matrix reshape({required int row, required int column})
> 
> 重塑矩阵形状，必须保证两次形状对应的尺寸不变
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.arrange(row: 2, column: 5, start: 10);
  var flatten = mt.reshape(row: 1, column: 10);
  mt.visible();
  flatten.visible();
}
```
### output
```text
[
 [ 10  11  12  13  14]
 [ 15  16  17  18  19]
]
[
 [ 10  11  12  13  14  15  16  17  18  19]
]
```
## resize
> Matrix resize({required int row, required int column, double number = 0.0})
> 
> 重塑矩阵尺寸，若尺寸变大，则使用number补全，否则从横向开始逐渐保留到
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  var mt = Matrix.arrange(row: 2, column: 5, start: 10);
  mt.resize(row: 2, column: 3).visible();
  mt.resize(row: 3, column: 4, number: double.nan).visible();
}
```
### output
```text
[
 [ 10  11  12]
 [ 13  14  15]
]
[
 [ 10  11  12  13]
 [ 14  15  16  17]
 [ 18  19 NaN NaN]
]
```
## setMask
> void setMask({double? nan_mask, double? inf_mask, double? nag_inf_mask})
> 
> 替换矩阵中的Nan、正负无穷大值
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%3.0f";
  List<List<double>> data = [
    [4, double.nan, 0, 9],
    [0, 3, 1, double.infinity],
    [5, 6, 3, -double.infinity],
  ];
  var mt1 = Matrix(data);
  mt1
    ..setMask(nan_mask: 100, inf_mask: 999, nag_inf_mask: -999)
    ..visible();
}
```
### output
```text
[
 [   4  100    0    9]
 [   0    3    1  999]
 [   5    6    3 -999]
]
```
## flatten
> Matrix flatten({bool horizontal = true})
> 
> 矩阵扁平化，两种方式均为从左到右、从上到下
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
  ];
  var mt1 = Matrix(data);
  mt1.flatten(horizontal: true).visible();
  mt1.flatten(horizontal: false).visible();
}
```
### output
```text
[
 [4.00000 1.00000 0.00000 9.00000 0.00000 3.00000 1.00000 9.00000 5.00000 6.00000 3.00000 2.00000]
]
[
 [4.00000 0.00000 5.00000 1.00000 3.00000 6.00000 0.00000 1.00000 3.00000 9.00000 9.00000 2.00000]
]
```
## row_
> List<double> row_(int index)
> 
> 获取矩阵的某行拷贝
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
  ];
  var mt1 = Matrix(data);
  var l1 = mt1.row_(0);
  mt1[0][0] = 100;
  print(l1);
}
```
### output
```text
[4.0, 1.0, 0.0, 9.0]
```
## column_
> List<double> column_(int index)
> 
> 获取矩阵的某列拷贝
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  List<List<double>> data = [
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
  ];
  var mt1 = Matrix(data);
  var l1 = mt1.column_(0);
  mt1[0][0] = 100;
  print(l1);
}
```
### output
```text
[4.0, 0.0, 5.0]
```
## slice
> Matrix slice({required int start, int? end, bool horizontal = true})
> 
> 矩阵的切片，从start索引开始切，到end索引结束（包含end索引），若不传入end值，则从start切到结束。切片行为会拷贝数据。
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%1.0f";
  List<List<double>> data = [
    [4, 1, 0, 9, 9, 2, 2],
    [0, 3, 1, 9, 1, 0, 9],
    [5, 6, 3, 2, 9, 9, 2]
  ];
  var mt1 = Matrix(data);
  mt1.slice(start: 1, end: 2, horizontal: true).visible();
  mt1.slice(start: 1, horizontal: false).visible();
}
```
### output
```text
[
 [ 0  3  1  9  1  0  9]
 [ 5  6  3  2  9  9  2]
]
[
 [ 1  0  9  9  2  2]
 [ 3  1  9  1  0  9]
 [ 6  3  2  9  9  2]
]
```
## select
> Matrix select({required List<int> target, bool horizontal = true})
> 
> 从矩阵中挑选某些行或者列（可以重复、可以不考虑顺序）的数据复制到新矩阵。
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%1.0f";
  List<List<double>> data = [
    [4, 1, 0, 9, 9, 2, 2],
    [0, 3, 1, 9, 1, 0, 9],
    [5, 6, 3, 2, 9, 9, 2]
  ];
  var mt1 = Matrix(data);
  mt1.select(target: [1, 1, 2, 3, 6, 5], horizontal: false).visible();
  mt1.select(target: [1, 1, 2, 3, 3], horizontal: true).visible();
}
```
### output
```text
[
 [ 1  1  0  9  2  2]
 [ 3  3  1  9  9  0]
 [ 6  6  3  2  2  9]
 [ 6  6  0  0  2  9]
]
[
 [ 0  3  1  9  1  0  9]
 [ 0  3  1  9  1  0  9]
 [ 5  6  3  2  9  9  2]
 [ 5  6  0  0  0  9  2]
 [ 5  6  0  0  0  9  2]
]
```
## drop
> Matrix drop({required Set<int> target, bool horizontal = true})
> 
> 传入一个索引集合，筛除不在集合内的行/列数据，并把剩下的拷贝到新矩阵。
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%1.0f";
  List<List<double>> data = [
    [4, 1, 0, 9, 9, 2, 2],
    [0, 3, 1, 9, 1, 0, 9],
    [5, 6, 3, 2, 9, 9, 2],
    [5, 6, 0, 0, 0, 9, 2],
  ];
  var mt1 = Matrix(data);
  mt1.drop(target: {1, 2, 3}, horizontal: false).visible();
  mt1.drop(target: {1, 2, 3}, horizontal: true).visible();
}
```
### output
```text
[
 [ 4  9  2  2]
 [ 0  1  0  9]
 [ 5  9  9  2]
 [ 5  0  9  2]
]
[
 [ 4  1  0  9  9  2  2]
]
```
## contain
> bool contain(double element)
> 
> 查看矩阵是否含有某数据
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%1.0f";
  List<List<double>> data = [
    [4, 1, 0, 9, 9, 2, 2],
    [0, 3, 1, 9, 1, 0, 9],
    [5, 6, 3, 2, 9, 9, 2],
    [5, 6, 0, 0, 0, 9, 2],
  ];
  var mt1 = Matrix(data);
  print(mt1.contain(8));
}
```
### output
```text
false
```
## compare
>  List<BoolList> compare({required Matrix other, int which = -1})
> 
> 对每个位置的数据进行大小比较，which参数为0时大于模式、1是小于模式、2是不小于模式、3是不大于模式、4是不等于模式、其他整数表示等于模式
### test
```text
import 'dart:math';
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%1.0f";
  List<List<double>> data = [
    [4, 1, 0, 9, 9, 2, 2],
    [0, 3, 1, 9, 1, 0, 9],
    [5, 6, 3, 2, 9, 9, 2],
    [5, 6, 0, 0, 0, 9, 2],
  ];
  Random rd = Random(42);
  var mt1 = Matrix(data);
  var mt2 = mt1.customize((x) => rd.nextBool() ? x - 0.5 : x + 0.5)
    ..visible();
  for (int i = 0;i <= 5;i++){
    print(mt1.compare(other: mt2, which: i));
  }
}
```
### output
```text
[
 [ 4.5  0.5 -0.5  9.5  9.5  1.5  2.5]
 [ 0.5  2.5  0.5  9.5  0.5  0.5  9.5]
 [ 5.5  5.5  3.5  2.5  9.5  8.5  1.5]
 [ 4.5  6.5 -0.5 -0.5 -0.5  8.5  1.5]
]
[[false, true, true, false, false, true, false], [false, true, true, false, true, false, false], [false, true, false, false, false, true, true], [true, false, true, true, true, true, true]]
[[true, false, false, true, true, false, true], [true, false, false, true, false, true, true], [true, false, true, true, true, false, false], [false, true, false, false, false, false, false]]
[[false, true, true, false, false, true, false], [false, true, true, false, true, false, false], [false, true, false, false, false, true, true], [true, false, true, true, true, true, true]]
[[true, false, false, true, true, false, true], [true, false, false, true, false, true, true], [true, false, true, true, true, false, false], [false, true, false, false, false, false, false]]
[[true, true, true, true, true, true, true], [true, true, true, true, true, true, true], [true, true, true, true, true, true, true], [true, true, true, true, true, true, true]]
[[false, false, false, false, false, false, false], [false, false, false, false, false, false, false], [false, false, false, false, false, false, false], [false, false, false, false, false, false, false]]
```
## sort
> void sort({bool reverse = false, int dim = -1})
> 
> 矩阵排序，dim表示排序的方式是每行、每列还是整体（后面亦如此），reverse表示正反方向
### test
```text
import 'dart:math';
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  List<List<double>> data = [
    [4, 1, 0, 9, 9, 2, 2],
    [0, 3, 1, 9, 1, 0, 9],
    [5, 6, 3, 2, 9, 9, 2],
    [5, 6, 0, 0, 0, 9, 2],
  ];
  var mt1 = Matrix(data);
  mt1..sort(reverse: true, dim: 0)..visible();
  mt1..sort(reverse: false, dim: 0)..visible();
  mt1..sort(reverse: false, dim: 1)..visible();
  mt1..sort(reverse: false, dim: 2)..visible();
}
```
### output
```text
[
 [  9   9   4   2   2   1   0]
 [  9   9   3   1   1   0   0]
 [  9   9   6   5   3   2   2]
 [  9   6   5   2   0   0   0]
]
[
 [  0   1   2   2   4   9   9]
 [  0   0   1   1   3   9   9]
 [  2   2   3   5   6   9   9]
 [  0   0   0   2   5   6   9]
]
[
 [  0   0   0   1   3   6   9]
 [  0   0   1   2   4   9   9]
 [  0   1   2   2   5   9   9]
 [  2   2   3   5   6   9   9]
]
[
 [  0   0   0   0   0   0   1]
 [  1   1   2   2   2   2   2]
 [  3   3   4   5   5   6   6]
 [  9   9   9   9   9   9   9]
]
```
## toList
> List<dynamic> toList(Typed T)
> 
> 将矩阵的数据映射到指定类型，通过传入枚举值T即可，int、double、bool生成标准且可变长的数组，complex生成复数列表，其余均生成高性能但不可变成的列表。  
> Typed.int表示标准int
> Typed.double表示标准double
> Typed.bool表示标准bool，数据不为0表示false，其余全是true
> Typed.complex表示拓展的Complex复数类
> 剩下全是源于typed_data标准库的高性能数据结构
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  List<List<double>> data = [
    [455, 1, 0, -9324],
    [120, 3, -21, 2329],
    [-545, 656, 3223, 332]
  ];
  var mt = Matrix.fromList(data);
  print(mt.toList(Typed.int));
  print(mt.toList(Typed.int8));
  print(mt.toList(Typed.int16));
  print(mt.toList(Typed.int32));
  print(mt.toList(Typed.int64));
  print(mt.toList(Typed.uint8));
  print(mt.toList(Typed.uint16));
  print(mt.toList(Typed.uint32));
  print(mt.toList(Typed.uint64));
  print(mt.toList(Typed.double));
  print(mt.toList(Typed.float32));
  print(mt.toList(Typed.float64));
  print(mt.toList(Typed.bool));
  print(Matrix.fromList([[1.0, 2.0], [0.0, 3.0], [4.0, 0.0]]).toList(Typed.complex));
}
```
### output
```text
[[455, 1, 0, -9324], [120, 3, -21, 2329], [-545, 656, 3223, 332]]
[[-57, 1, 0, -108], [120, 3, -21, 25], [-33, -112, -105, 76]]
[[455, 1, 0, -9324], [120, 3, -21, 2329], [-545, 656, 3223, 332]]
[[455, 1, 0, -9324], [120, 3, -21, 2329], [-545, 656, 3223, 332]]
[[455, 1, 0, -9324], [120, 3, -21, 2329], [-545, 656, 3223, 332]]
[[199, 1, 0, 148], [120, 3, 235, 25], [223, 144, 151, 76]]
[[455, 1, 0, 56212], [120, 3, 65515, 2329], [64991, 656, 3223, 332]]
[[455, 1, 0, 4294957972], [120, 3, 4294967275, 2329], [4294966751, 656, 3223, 332]]
[[455, 1, 0, -9324], [120, 3, -21, 2329], [-545, 656, 3223, 332]]
[[455.0, 1.0, 0.0, -9324.0], [120.0, 3.0, -21.0, 2329.0], [-545.0, 656.0, 3223.0, 332.0]]
[[455.0, 1.0, 0.0, -9324.0], [120.0, 3.0, -21.0, 2329.0], [-545.0, 656.0, 3223.0, 332.0]]
[[455.0, 1.0, 0.0, -9324.0], [120.0, 3.0, -21.0, 2329.0], [-545.0, 656.0, 3223.0, 332.0]]
[[true, true, false, true], [true, true, true, true], [true, true, true, true]]
[Complex(1.0, 2.0), Complex(0.0, 3.0), Complex(4.0, 0.0)]
```
## append
> void append(List<double> data, {bool horizontal = true})
> 
> Matrix定义之初就设定是可变的，append用于添加某行或者某列到尾部

### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%5.0f";
  List<List<double>> data = [
    [455, 1, 0, -9324],
    [120, 3, -21, 2329],
    [-545, 656, 3223, 332]
  ];
  var mt = Matrix.fromList(data);
  mt
    ..append([1, 2, 3, 4], horizontal: true)
    ..visible()
    ..append([4, 5, 65, 232], horizontal: false)
    ..visible();
}
```
### output
```text
[
 [   455      1      0  -9324]
 [   120      3    -21   2329]
 [  -545    656   3223    332]
 [     1      2      3      4]
]
[
 [   455      1      0  -9324      4]
 [   120      3    -21   2329      5]
 [  -545    656   3223    332     65]
 [     1      2      3      4    232]
]
```

[下一篇：辅助](auxiliary.md)