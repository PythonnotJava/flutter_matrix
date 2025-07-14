# 概率论与数理统计

## mean
- 获取均值
```text
Object mean({int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, double.infinity],
    [0, 5, 7, -6]
  ]);
  print(mt.mean(dim: 0));
  print(mt.mean(dim: 1));
  print(mt.mean(dim: 2));
}
```
### output
```text
[1.75, Infinity, 1.5]
[1.0, 2.3333333333333335, 2.0, Infinity]
Infinity
```
## median
- 获取中位数
```text
Object median({int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, double.infinity],
    [0, 5, 7, -6]
  ]);
  print(mt.median(dim: 0));
  print(mt.median(dim: 1));
  print(mt.median(dim: 2));
}
```
### output
```text
[1.5, 1.0, 2.5]
[1.0, 2.0, 3.0, 1.0]
1.5
```
## mode
- 根据规则，在n种元素中获取众数
- 当元素个数都一样的时候返回null
- 当有t种元素个数相同的时候（t<n），取第一种元素
```text
dynamic mode({int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, double.infinity],
    [0, 5, 7, -6],
    [1, 2, 7, -6],
    [1, 1, 2, 2]
  ]);
  print(mt.mode(dim: 0));
  print(mt.mode(dim: 1));
  print(mt.mode(dim: 2));
}
```
### output
```text
[1.0, null, null, null, null]
[1.0, 2.0, 7.0, -6.0]
1.0
```
## shakeTotal
- 对数据进行随机抖动，范围(-bias,bias)
```text
void shakeTotal({double bias = 1.0, int? seed}) 
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, double.infinity],
    [0, 5, 7, -6],
    [1, 2, 7, -6],
    [1, 1, 2, 2]
  ]);
  mt..shakeTotal(bias: 1)..visible();
}
```
### output
```text
[
 [ 1.12163  1.92272  3.81764  0.58426]
 [ 1.56001  0.71463 -3.86042 Infinity]
 [ 0.74075  4.35658  6.08286 -5.54264]
 [ 1.96749  1.04282  7.97017 -6.52791]
 [ 0.38011  1.53244  1.20357  2.65322]
]
```
## shakePercent
- 对指定比例的数据进行随机抖动，范围(-bias,bias)
```text
void shakePercent({double bias = 1.0, double percent = 0.5, int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, 9, 7],
    [0, 5, 7, -6],
    [1, 2, 7, -6],
    [1, 1, 2, 2]
  ]);
  mt..shakePercent(bias: 1, percent: 0.5, seed: 0)..visible();
  print(mt.count((x) => x == x.toInt(), dim: -1));
}
```
### output
```text
[
 [ 1.00000  2.00000  3.00000  1.59552]
 [ 2.00000 -0.16072 -4.00000 Infinity]
 [ 0.36040  5.59324  7.00000 -6.78034]
 [ 1.64683  2.62451  7.00000 -6.00000]
 [ 1.00000  1.00000  1.14995  2.11472]
]
10
```
## shakeProbably
- 对每个数据概率性随机抖动，范围(-bias,bias)
```text
void shakeProbably({double bias = 1.0, double p = 0.5, int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, 9, 7],
    [0, 5, 7, -6],
    [1, 2, 7, -6],
    [1, 1, 2, 2]
  ]);
  mt
    ..shakeProbably(bias: 1, p: 0.75, seed: 0)
    ..visible()
    ..shakeProbably(bias: 1, p: 0.2, seed: 0)
    ..visible();
}
```
### output
```text
[
 [ 1.00000  2.00000  3.11472  1.95573]
 [ 2.00000  0.62451  8.18995  7.97010]
 [ 0.79149  5.74322  7.02362 -5.83102]
 [ 1.00000  1.31213  6.28323 -6.08534]
 [ 0.03197  0.66427  2.21624  2.00000]
]
[
 [ 1.00000  2.00000  3.11472  1.95573]
 [ 2.00000  0.62451  8.18995  7.97010]
 [ 0.79149  5.68677  7.02362 -5.83102]
 [ 1.00000  1.31213  6.28323 -6.08534]
 [ 0.03197  0.66427  2.21624  2.02362]
]
```
## shuffle
- 打乱数据
```text
void shuffle({int? seed, int dim = -1})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%8.0f";
  var mt = Matrix.fromList([
    [1, double.nan, 3, 1],
    [2, 0, 9, 7],
    [0, 5, 7, -6],
    [1, double.infinity, 7, -6],
    [1, 1, double.negativeInfinity, 2]
  ]);
  mt
    ..shuffle(dim: 0)
    ..visible()
    ..shuffle(dim: 1)
    ..visible()
    ..shuffle(dim: 2)
    ..visible();
}
```
### output
```text
[
 [        1       NaN         1         3]
 [        9         7         0         2]
 [        7         5        -6         0]
 [       -6  Infinity         1         7]
 [        1 -Infinity         2         1]
]
[
 [       -6 -Infinity         1         0]
 [        1         7         2         7]
 [        9  Infinity        -6         2]
 [        7         5         0         3]
 [        1       NaN         1         1]
]
[
 [        1         1         2 -Infinity]
 [       -6         7         0         2]
 [ Infinity         5         1         7]
 [       -6         1         0         1]
 [        3         9       NaN         7]
]
```
## uniform
- 均匀分布
```text
static T uniform<T extends MatrixBase<T>>(
      {double lb = 0.0,
      double ub = 1.0,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  MatrixRandom.uniform<Matrix>(row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 0.72182  0.36967  0.50301  0.59886  0.95493  0.90183  0.50644  0.13281]
 [ 0.92723  0.96414  0.03060  0.92897  0.90201  0.29696  0.81846  0.58139]
]
```
## normal
- 正态分布
```text
static T normal<T extends MatrixBase<T>>(
      {double mu = 0.0,
      double sigma = 1.0,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  MatrixRandom.normal<Matrix>(row: 2, column: 8).visible();
}
```
### output
```text
[
 [-2.11616 -2.44480  2.95000  1.16511 -1.44609  1.14767 -0.28159 -0.22208]
 [-0.23525  0.78347 -0.37689  1.11326 -0.02535  0.54844 -1.11553  0.25712]
]
```
## binomial
- 二项分布
- n是试验次数，p是成功的概率
```text
static T binomial<T extends MatrixBase<T>>(
      {required int n,
      required double p,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  MatrixRandom.binomial<Matrix>(n: 10, p: 0.4, row: 2, column: 5).visible();
}
```
### output
```text
[
 [  5   6   4   3   4]
 [  4   1   3   4   4]
]
```
## chisquare
- 卡方分布，其中正整数df是自由度
```text
static T chisquare<T extends MatrixBase<T>>(
      {required int df, required int row, required int column, int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  MatrixRandom.chisquare<Matrix>(df: 5, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 2.02621  3.94982  2.45784  3.73202  4.25828  8.80980  3.70948 10.56275]
 [ 3.50148  1.81609  6.09900  7.97319  7.45826  4.74143  2.30963  8.61327]
]
```
## exponential
- 指数分布，正实数lambda是速率参数
```text
static T exponential<T extends MatrixBase<T>>(
      {required double lambda,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  MatrixRandom.exponential<Matrix>(lambda: 2.5, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 0.08276  0.00139  0.29485  0.79533  0.12472  0.98942  0.74717  0.62893]
 [ 0.61888  1.48321  0.20256  0.03876  0.70940  0.35311  0.40923  0.24835]
]
```
## f
- F 分布。其中d1和d2是两个独立卡方分布的自由度
```text
static T f<T extends MatrixBase<T>>(
      {required int d1,
      required int d2,
      required int row,
      required int column,
      int? seed}) 
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  MatrixRandom.f<Matrix>(d1: 1, d2: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [  4.93056   0.11101   0.01529   1.57699   1.16049   0.71412   0.59531   1.83859]
 [  4.73860   0.91165   2.57683   0.11337   5.69172   0.01585   0.11492   0.44708]
]
```
## gamma
- 伽马分布。其中k是形状参数，theta是尺度参数。它俩都是正数
```text
static T gamma<T extends MatrixBase<T>>(
      {required double k,
      required double theta,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  MatrixRandom.gamma<Matrix>(k: 1, theta: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [  5.14067   1.42020   1.75349   0.71228   0.01489   0.82426   0.00388   0.06545]
 [  2.22228   7.38054   0.33947   0.71414   0.19316   3.16064   0.71124   3.24876]
]
```
## beta
- Beta分布，参数a和b分别是分子和分母的形状参数
```text
static T beta<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  MatrixRandom.beta<Matrix>(a: 1, b: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [  0.49407   0.39837   0.09070   0.11256   0.59922   0.50666   0.15258   0.70883]
 [  0.18135   0.19389   0.18008   0.41081   0.25688   0.21515   0.07910   0.33202]
]
```
## dirichlet
- 狄利克雷分布，alpha参数是一个长度为列且不小于2的浮点序列
- alpha 中的每个数字都必须大于0
```text
static T dirichlet<T extends MatrixBase<T>>(
      {required List<double> alpha, required int row, int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%3.5f";
  MatrixRandom.dirichlet<Matrix>(alpha: [1, 3.3, 1.5, 0.78, 2, 2, 1.7, 2], row: 2).visible();
}
```
### output
```text
[
 [  0.09739   0.46528   0.03357   0.00008   0.14472   0.13976   0.08812   0.03108]
 [  0.19171   0.25310   0.14525   0.02408   0.14559   0.16670   0.03892   0.03466]
]
```
## geometric
- 几何分布，其中p是成功的概率
```text
static T geometric<T extends MatrixBase<T>>(
      {required double p, required int row, required int column, int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  MatrixRandom.geometric<Matrix>(p: 0.25, row: 2, column: 10).visible();
}
```
### output
```text
[
 [  7   2   3   1   1   5   4   1  18   1]
 [ 10   1   4   2   1   7   2   2   3   9]
]
```
## gumbel
- Gumbel 分布
- 其中loc是分布众数的位置
- scale是分布的尺度参数，必须为非负值
```text
static T gumbel<T extends MatrixBase<T>>(
      {required double loc,
      required double scale,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.5f";
  MatrixRandom.gumbel<Matrix>(loc: 2, scale: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 0.79973  1.47329  0.77731  1.35254  1.03301  6.36100  5.02553  0.39647]
 [ 2.50385  3.34456  1.25769 -0.80591  6.03160  2.28924  2.21749  1.99499]
]
```
## hypergeometric
- 超几何分布，参数N、K、n分别表示元素总数、目标元素总数、抽取样本数，最终得到样本中目标元素的数量
```text
static T hypergeometric<T extends MatrixBase<T>>(
      {required int N,
      required int K,
      required int n,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  MatrixRandom.hypergeometric<Matrix>(N: 20,
      K: 10,
      n: 5,
      row: 2,
      column: 8).visible();
}
```
### output
```text
[
 [  0   2   2   2   2   2   2   1]
 [  3   2   1   2   4   2   3   3]
]
```
## laplace
- 拉普拉斯分布，又称双指数分布，mu为位置参数，非负b为尺度参数。
```text
static T laplace<T extends MatrixBase<T>>(
      {required double mu,
      required double b,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.laplace<Matrix>(mu: 0, b: 0.5, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 0.62375 -0.39557  0.05964  0.69604 -0.19187 -0.31969 -0.05227  0.16362]
 [ 0.00698 -1.03409 -0.06551  0.76127  2.03078 -0.47385  0.63251  0.91648]
]
```
## logistic
- Logistic分布，其中mu和s分别是位置和尺度参数，且s大于 0
```text
static T logistic<T extends MatrixBase<T>>(
      {required double mu,
      required double s,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.logistic<Matrix>(mu: 1, s: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [-5.19389 -5.07993 -0.57864  3.94618 -2.20507 -1.24739  1.12640  2.20015]
 [ 0.49239  3.60076  3.29199  2.94326 -1.70884  4.28270  2.13897 -4.37265]
]
```
## lognormal 
- 对数正态分布，其中mu和sigma分别是位置参数和尺度参数，且sigma大于 0
```text
static T lognormal<T extends MatrixBase<T>>(
      {required double mu,
      required double sigma,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.lognormal<Matrix>(mu: 2, sigma: 0.5, row: 2, column: 8).visible();
}
```
### output
```text
[
 [18.12334 12.84363  5.79773  6.37634  4.43129  8.25890  5.64034  7.05924]
 [ 9.87825  7.99804  6.27516  4.19677 11.05468 11.32761  6.01271  5.69678]
]
```
## multinomial
- 多项分布，其中n是试验次数，p是总和为1的概率列表
```text
static T multinomial<T extends MatrixBase<T>>(
      {required int n, required List<double> p, required int row, int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  MatrixRandom.multinomial<Matrix>(n: 10, p: [0.1, 0.15, 0.05, 0.2, 0.4, 0.1], row: 2).visible();
}
```
### output
```text
[
 [  0   2   0   2   5   1]
 [  1   1   0   4   4   0]
]
```
## poisson
- 泊松分布，参数lambda表示平均值
```text
static T poisson<T extends MatrixBase<T>>(
      {required double lambda,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.0f";
  MatrixRandom.poisson<Matrix>(lambda: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [  4   2   5   0   3   4   1   1]
 [  3   1   0   3   2   3   5   0]
]
```
## cauchy
- 柯西分布，参数x0表示中心位置，正数gamma表示尺度
```text
static T cauchy<T extends MatrixBase<T>>(
      {required double x0,
      required double gamma,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.cauchy<Matrix>(x0: 0, gamma: 1, row: 2, column: 8).visible();
}
```
### output
```text
[
 [-36.62911  0.72481  3.37703  1.14735  0.12744 -0.28093 -5.73963  0.85222]
 [ 2.07105  1.33930 -0.90362 -0.71522 -4.79772  3.65556 -0.45629 -0.69549]
]
```
## pareto
- 帕累托分布，正数xm是尺度参数，正数alpha是形状参数
```text
static T pareto<T extends MatrixBase<T>>(
      {required double xm,
      required double alpha,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.pareto<Matrix>(xm: 1, alpha: 1, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 2.13617  1.05138  2.59410  1.69382  2.13383  7.34943  1.93597  1.61736]
 [ 1.35915  1.16898  4.63186  4.15207  1.76849 14.69354  2.31302  2.73154]
]
```
## rayleigh
- 瑞利分布，正数sigma是尺度参数。
```text
static T rayleigh<T extends MatrixBase<T>>(
      {required double sigma,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.rayleigh<Matrix>(sigma: 1, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 1.07546  2.06677  1.11999  0.53733  1.10249  1.15054  2.22445  1.53285]
 [ 0.77856  1.41063  0.24988  2.02035  1.24209  1.57036  1.73024  2.23977]
]
```
## triangular
- 三角分布，下限a，上限b，众数c。
```text
static T triangular<T extends MatrixBase<T>>(
      {required double a,
      required double b,
      required double c,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.triangular<Matrix>(a: -2, b: 3, c: 0, row: 2, column: 9).visible();
}
```
### output
```text
[
 [ 0.71009 -0.91656  0.16837 -1.15603  1.52162  0.94240  0.88847  0.36057  0.14813]
 [ 1.97316 -0.85960  0.44336 -0.01748  0.50504  2.18705 -0.69879 -0.07549 -0.01691]
]
```
## wald
- 逆高斯分布（也称为 Wald 分布），均值为正数mu，形状参数为lambda
```text
static T wald<T extends MatrixBase<T>>(
      {required double mu,
      required double lambda,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.wald<Matrix>(mu: 1, lambda: 2, row: 2, column: 9).visible();
}
```
### output
```text
[
 [ 0.81247  0.62909  0.45730  3.96918  1.60884  0.48366  2.83001  1.14535  0.35252]
 [ 0.59226  0.86075  1.60548  0.96771  0.46557  0.68437  0.45168  1.52735  0.64942]
]
```
## weibull
- 威布尔分布，尺度参数lambda和形状参数k均为正数
```text
static T weibull<T extends MatrixBase<T>>(
      {required double k,
      required double lambda,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.weibull<Matrix>(k: 1, lambda: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 1.77253  2.04454  0.79726  0.03651  0.41815  1.14795  0.26157  0.63567]
 [ 1.26025  0.62709  2.27595  0.50974  0.14316  2.67833  0.65225  1.38974]
]
```
## vonmises
- 冯·米塞斯分布，参数mu和k分别表示位置和浓度，k > 0
```text
static T vonmises<T extends MatrixBase<T>>(
      {required double k,
      required double mu,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.vonmises<Matrix>(k: 1, mu: 2, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 0.21612  2.38583  2.33520  2.44294  0.70750  1.90340  2.35548  1.59108]
 [ 3.54407  2.16340  1.06748  3.17789  0.73116  1.55998  3.85376  1.58202]
]
```
## t
- 学生 t 分布，正整数 v表示自由度，mu是非中心参数。
```text
static T t<T extends MatrixBase<T>>(
      {required int v,
      required double mu,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.t<Matrix>(v: 5, mu: 1, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 0.62758  2.62640  2.62945  1.69008 -2.20297 -0.34357  2.35201  0.05813]
 [ 0.77000  0.98190  4.40171  1.47281  2.35428  0.31133  2.76713  1.65198]
]
```
## frechet
- Fréchet分布，也称为逆威布尔分布，正数alpha是形状参数，比例参数s也是正数，m是位置参数
```text
static T frechet<T extends MatrixBase<T>>(
      {required double alpha,
      double s = 1.0,
      double m = 0.0,
      required int row,
      required int column,
      int? seed})
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.5f";
  MatrixRandom.frechet<Matrix>(alpha: 1, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 1.03756  0.66498  6.86990  0.72205  1.37044 83.75532  0.82821  0.91106]
 [ 0.80854  2.80326  0.72205  2.69117  6.89905  0.71063  2.93813  2.07763]
]
```


[下一篇：可视化的抽象实现](visualization.md)
