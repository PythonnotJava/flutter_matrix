# 复数类

> 关于复数：https://oi-wiki.org/math/complex/

## 构造函数
> const Complex({this.real = 0.0, this.imaginary = 0.0})
> 
> 传入复数的实部和虚部，不传默认为0.0，虚数一旦创建就不可以修改。

## test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex(real: 1.5, imaginary: 2.1);
  print(complex);
}
```
### output
```text
Complex(1.5, 2.1)
```
## Complex.fromPolar
> factory Complex.fromPolar({required double r, required double theta})
> 
> 根据模和辐角来创建复数
### test
```text
import 'dart:math';

import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromPolar(r: 2, theta: pi / 4);
  print(complex);
}
```
### output
```text
Complex(1.4142135623730951, 1.4142135623730951)
```
## Complex.fromList
> factory Complex.fromList(List<double> data)
> 
> 传入一个包含两个浮点数的列表来生成复数
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, 1.2]);
  print(complex);
}
```
### output
```text
Complex(1.3, 1.2)
```
## toString
> String toString({int which = 0})
> 
> 转toString，which函数提供了不同的复数展示格式
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, 1.2]);
  print(complex.toString(which: 0));
  print(complex.toString(which: 1));
  print(complex.toString(which: 2));
  print(complex.toString(which: 3));
  print(complex.toString(which: 4));
  complex = Complex.fromList([-1.3, -1.2]);
  print(complex.toString(which: 0));
  print(complex.toString(which: 1));
  print(complex.toString(which: 2));
  print(complex.toString(which: 3));
  print(complex.toString(which: 4));
}
```
### output
```text
Complex(1.3, 1.2)
Complex(1.3, 1.2j)
1.3 + 1.2j
(1.3, 1.2j)
1.3+1.2j
Complex(-1.3, -1.2)
Complex(-1.3, -1.2j)
-1.3 - 1.2j
(-1.3, -1.2j)
-1.3-1.2j
```
## bool operator == (Object other)
> 判断两个复数实部和虚部是不是各相同
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, 1.2]);
  Complex complex1 = Complex(real: 1.3, imaginary: 1.2);
  print(complex1 == complex);
}
```
### output
```text
true
```
## +、-、*、/
> 复数的运算
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, 1.2]);
  Complex complex1 = Complex(real: 1.3, imaginary: -1.2);
  print(complex + complex1);
  print(complex - complex1);
  print(complex * complex1);
  print(complex / complex1);
}
```
### output
```text
Complex(2.6, 0.0)
Complex(0.0, 2.4)
Complex(3.13, 0.0)
Complex(0.07987220447284353, 0.9968051118210863)
```
## Complex get conjugate
> 获取对应的共轭复数
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, 1.2]);
  Complex complex1 = Complex(real: 1.3, imaginary: -1.2);
  print(complex.conjugate == complex1);
}
```
### output
```text
true
```
## bool get isNan
> 判断实部或者虚部含有NaN
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.3, double.nan]);
  print(complex.isNan);
}
```
### output
```text
true
```
## double get mod
> 复数的模
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.6]);
  print(complex.mod);
}
```
### output
```text
2.0
```
## double get arg
> 复数的辐角
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.2]);
  print(complex.arg);
}
```
### output
```text
0.7853981633974483
```
## Complex get exp
> 欧拉公式
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.2]);
  print(complex.exp);
}
```
### output
```text
Complex(1.203070112722819, 3.0944787419716917)
```
## Complex get sqrt
> 平方根
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.2]);
  print(complex.sqrt);
}
```
### output
```text
Complex(1.20354814503777, 0.4985259646436252)
```
## 一些三角函数运算
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.2]);
  print(complex.sin);
  print(complex.cos);
  print(complex.tan);
}
```
### output
```text
Complex(1.6876017599704798, 0.546965027216471)
Complex(0.6561050855063479, -1.4068769820012117)
Complex(0.14015057356642455, 1.134177526770811)
```
## deepcopy
> 复制一个复数
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.2]);
  print(complex.deepcopy == complex);
  print(identical(complex.deepcopy, complex));
}
```
### output
```text
true
false
```
## 一些转换方法
### test
```text
import 'package:flutter_matrix/complex.dart';

main() {
  Complex complex = Complex.fromList([1.2, 1.2]);
  print(complex.toList);
  print(complex.toFloat64x2);
  print(complex.toPoint);
}
```
### output
```text
[1.2, 1.2]
[1.200000, 1.200000]
Point(1.2, 1.2)
```
[下一篇：可视化处理](visualization.md)