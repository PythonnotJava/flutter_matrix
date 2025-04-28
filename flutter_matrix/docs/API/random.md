# 概率论与数理统计

## mean
> Object mean({int dim = -1})
> 
> 求均值
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fromList([
    [1, 2, 3, 4],
    [double.infinity, 2, 2, 3],
    [0, 4, 6, -2]
  ]);
  print(mt.mean(dim: 0));
  print(mt.mean(dim: 1));
  print(mt.mean(dim: 2));
}
```
### output
```text
[2.5, Infinity, 2.0]
[Infinity, 2.0, 2.75, 1.25]
Infinity
```
## median
> Object median({int dim = -1})
> 
> 求中位数
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fromList([
    [1, 2, 3, 4, 6, 7, 10],
    [double.infinity, 2, 2, 3, 4, 7, -65],
    [0, 4, 6, -2, 1, -2, -2]
  ]);
  print(mt.median(dim: 0));
  print(mt.median(dim: 1));
  print(mt.median(dim: 2));
}
```
### output
```text
[4.0, 3.0, 0.0]
[1.0, 2.0, 3.0, 3.0, 4.0, 7.0, -2.0]
3.0
```
## mode
> Object mode({int dim = -1})
> 
> 求众数
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fromList([
    [1, 2, 3, 4, 6, 7, 10],
    [double.infinity, 2, 2, 3, 4, 7, -65],
    [0, 4, 6, -2, 1, -2, -2],
    [double.infinity, 2, 2, 3, 4, 7, -65],
  ]);
  print(mt.mode(dim: 0));
  print(mt.mode(dim: 1));
  print(mt.mode(dim: 2));
}
```
### output
```text
[1.0, 2.0, -2.0, 2.0]
[Infinity, 2.0, 2.0, 3.0, 4.0, 7.0, -65.0]
2.0
```
## shuffle
> void shuffle({int? seed, int dim = -1})
> 
> 随机打乱，seed是随时数种子
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.2f";
  Matrix.linspace(start: 0, end: 1, row: 5, column: 10)..visible();
  var m12 = Matrix.linspace(start: 0, end: 1, row: 5, column: 10);
  var m13 = Matrix.linspace(start: 0, end: 1, row: 5, column: 10);
  var m14 = Matrix.linspace(start: 0, end: 1, row: 5, column: 10);
  m12..shuffle(dim: 0)..visible();
  m13..shuffle(dim: 1)..visible();
  m14..shuffle(dim: 10)..visible();
}
```
### output
```text
[
 [ 0.00  0.02  0.04  0.06  0.08  0.10  0.12  0.14  0.16  0.18]
 [ 0.20  0.22  0.24  0.27  0.29  0.31  0.33  0.35  0.37  0.39]
 [ 0.41  0.43  0.45  0.47  0.49  0.51  0.53  0.55  0.57  0.59]
 [ 0.61  0.63  0.65  0.67  0.69  0.71  0.73  0.76  0.78  0.80]
 [ 0.82  0.84  0.86  0.88  0.90  0.92  0.94  0.96  0.98  1.00]
]
[
 [ 0.06  0.18  0.14  0.16  0.02  0.12  0.08  0.04  0.10  0.00]
 [ 0.29  0.20  0.39  0.31  0.22  0.35  0.37  0.27  0.24  0.33]
 [ 0.41  0.47  0.57  0.49  0.51  0.55  0.43  0.45  0.59  0.53]
 [ 0.67  0.73  0.63  0.71  0.61  0.65  0.76  0.80  0.69  0.78]
 [ 1.00  0.94  0.98  0.92  0.96  0.88  0.90  0.86  0.84  0.82]
]
[
 [ 0.20  0.84  0.04  0.27  0.29  0.92  0.53  0.35  0.98  0.80]
 [ 0.82  0.22  0.24  0.06  0.90  0.51  0.94  0.96  0.16  0.18]
 [ 0.41  0.02  0.86  0.88  0.49  0.31  0.12  0.76  0.57  0.39]
 [ 0.00  0.63  0.45  0.67  0.08  0.10  0.73  0.14  0.78  1.00]
 [ 0.61  0.43  0.65  0.47  0.69  0.71  0.33  0.55  0.37  0.59]
]
[
 [ 0.55  0.41  0.96  0.27  0.92  0.82  0.57  0.39  0.73  0.63]
 [ 0.88  0.29  0.43  0.98  0.22  0.78  0.94  0.45  0.76  0.37]
 [ 0.69  0.16  0.84  1.00  0.90  0.71  0.20  0.51  0.53  0.49]
 [ 0.08  0.33  0.65  0.31  0.10  0.59  0.18  0.02  0.86  0.67]
 [ 0.80  0.04  0.61  0.06  0.35  0.14  0.00  0.47  0.12  0.24]
]
```
## uniform
> static Matrix uniform({double lb = 0.0, double ub = 1.0, required int row, required int column, int? seed})
> 
> 均匀分布
### test
```text
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'flutter_matrix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 生成1K个标准均匀分布的数据并且使用柱状图可视化
  static Matrix datas = MatrixRandom.uniform(row: 1, column: 1000, seed: 42);
  static Map<List<double>, int> maps = datas.toHist(start: 0.0, end: 1.0, counts: 10);
  var ls = maps.keys.toList();

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true, // 设置为 true 显示左侧 Y 轴刻度
        reservedSize: 40, // 留出空间
        interval: 3, // 设置刻度间隔
        getTitlesWidget: getLeftTitles, // 自定义左侧刻度标签
      ),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  // 自定义 Y 轴刻度标签
  Widget getLeftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value % 3 == 0) { // 仅在指定刻度显示标签
      text = value.toInt().toString();
    } else {
      text = '';
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = ls[value.toInt()].toString();
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> buildGroup(){
    return List<BarChartGroupData>.generate(ls.length, (r){
      return BarChartGroupData(
        x: r,
        barRods: [
          BarChartRodData(toY: maps.values.elementAt(r).toDouble()),
        ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BarChart(
          BarChartData(
            barGroups: buildGroup(),
            titlesData: titlesData,
          ),
        ),
      ),
    );
  }
}
```
### output
![均匀分布](src/uniform.png)
## normal
> static Matrix normal({double mu = 0.0, double sigma = 1.0, required int row, required int column, int? seed})
> 
> 正态分布
### test
```text
static Matrix datas = MatrixRandom.normal(row: 1, column: 10000, seed: 42);
static Map<List<double>, int> maps = datas.toHist(start: -10.0, end: 10.0, counts: 100);
var ls = maps.keys.toList();
```
### output
![正态分布](src/normal.png)
## shake_total
> void shake_total({double bias = 1.0, int? seed})
> 
> 对整体数据随机上下限抖动最大abs(bias)值
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fill(number: 2, row: 4, column: 6)..visible();
  mt..shake_total(bias: 1, seed: 3)..visible();
}
```
### output
```text
[
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
]
[
 [1.84526 1.93082 1.21542 1.07671 2.73399 1.04996]
 [2.86985 1.04787 2.03070 2.86932 1.36468 2.91896]
 [2.23152 2.47494 2.37738 2.75460 1.98057 2.90156]
 [1.61362 1.21451 2.29266 1.64790 2.31230 1.48668]
]
```
## shake_percent
> void shake_percent({double bias = 1.0, double percent = 0.5, int? seed})
> 
> 随机抖动percent占比的数据
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fill(number: 2, row: 4, column: 6)..visible();
  mt..shake_percent(bias: 1, seed: 3, percent: 0.5)..visible();
  print(mt.count((x) => x == 2) == 4 * 6 ~/ 2);
} 
```
### output
```text
[
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
]
[
 [2.00000 2.00000 1.04996 1.04787 2.00000 1.21542]
 [1.07671 2.00000 2.00000 2.86932 1.36468 2.03070]
 [1.93082 2.86985 2.00000 2.91896 2.00000 2.00000]
 [1.84526 2.00000 2.73399 2.00000 2.00000 2.00000]
]
true
```
## shake_probably
> void shake_probably({double bias = 1.0, double p = 0.5, int? seed})
> 
> 按照概率对数据随机抖动
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fill(number: 2, row: 4, column: 6)..visible();
  mt..shake_probably(bias: 1, seed: 3, p: 0.25)..visible();
} 
```
### output
```text
[
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
]
[
 [2.00000 1.19765 2.00000 1.59960 2.00000 2.00000]
 [2.00000 2.00000 2.00000 1.29358 2.16905 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
 [2.00000 2.00000 2.00000 2.00000 2.00000 2.00000]
]
```

## binomial
> static Matrix binomial({required int n, required double p, required int row, required int column, int? seed})
> 
> 二项式分布（伯努利分布），其中n是试验次数，p是成功的概率。

### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = '%2.0f';
  var mt = MatrixRandom.binomial(n: 10, p: 0.6, row: 3, column: 6);
  mt.visible();
}
```
### output
```text
[
 [  9   5   6   6   6   7]
 [  6   7   6   5   5   6]
 [  5   5   7   4   9   6]
]
```
## chisquare
> static Matrix chisquare({ required int df, required int row, required int column, int? seed })
> 
> 卡方分布，其中正整数df是自由度。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  var mt = MatrixRandom.chisquare(df: 3, row: 3, column: 6);
  mt.visible();
}
```
### output
```text
[
 [5.42309 5.67948 0.43278 9.90406 0.08491 0.75004]
 [0.69392 1.83211 4.31445 3.21911 9.51412 7.66674]
 [4.24697 0.43563 1.39504 4.06116 0.95671 3.23452]
]
```
## exponential
> static Matrix exponential({ required double lambda, required int row, required int column, int? seed })
> 
> 指数分布，正实数λ是速率参数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  var mt = MatrixRandom.exponential(lambda: 3, row: 3, column: 7);
  mt.visible();
}
```
### output
```text
[
 [0.59205 0.30458 0.44661 0.37097 0.68382 0.37191 0.19418]
 [0.87269 0.48058 0.11004 0.41595 0.09100 0.68939 0.04317]
 [0.08204 0.16524 1.15535 0.70234 0.04674 0.30218 0.07011]
]
```
## f
> static Matrix f({ required int d1, required int d2, required int row, required int column, int? seed })
> 
> F 分布。其中 d1 和 d2 ] 是两个独立卡方分布的自由度。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.f(d1: 3, d2: 4, row: 4, column: 6);
  mt.visible();
}
```
### output
```text
[
 [ 0.92346  0.66244  3.03371  0.18384  0.63915  0.97611]
 [ 0.91794  0.54395  0.33545  1.28692  0.01852  1.13263]
 [ 2.17837  0.24876  3.40228  0.11621  0.76633  0.47811]
 [ 1.02146  4.00121  0.25865  2.29399  2.07985  0.07998]
]
```
## gamma
> static Matrix gamma({ required double k, required double theta, required int row, required int column, int? seed })
> 
> 伽马分布，其中k是形状参数，theta是尺度参数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.gamma(k: 2.3, theta: 1.2, row: 2, column: 9);
  mt.visible();
}
```
### output
```text
[
 [ 1.97898  2.11548  1.97235  2.01070  1.97023  2.15622  1.96931  1.96695  1.97193]
 [ 1.99453  1.98793  1.98049  1.99853  2.01608  2.06490  1.96879  2.18777  2.01119]
]
```
## beta
> static Matrix beta({ required double a, required double b, required int row, required int column, int? seed })
> 
> 贝塔分布，参数a和b分别是分子和分母的形状参数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.beta(a: 1.4, b: 1.5, row: 3, column: 6);
  mt.visible();
}
```
### output
```text
[
 [ 0.49674  0.47748  0.49000  0.51771  0.48358  0.53437]
 [ 0.47219  0.48763  0.47852  0.48319  0.45656  0.46501]
 [ 0.47745  0.47656  0.47766  0.48641  0.46924  0.47451]
]
```
## dirichlet
> static Matrix dirichlet({ required List<double> alpha, required int row, int? seed })
> 
> 狄利克雷分布，alpha参数是长度为列且不小于2的浮点序列，alpha中的每个数都必须大于0。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.dirichlet(alpha: [2, 3, 4, 5, 2, 1, 1, 9], row: 5);
  mt.visible();
}
```
### output
```
[
 [ 0.06777  0.10927  0.14974  0.19033  0.06799  0.02707  0.03108  0.35675]
 [ 0.06782  0.10716  0.15432  0.18717  0.07829  0.02750  0.02718  0.35056]
 [ 0.07176  0.11077  0.14973  0.19066  0.06803  0.02759  0.02731  0.35416]
 [ 0.06923  0.10830  0.15226  0.19454  0.06776  0.02710  0.02705  0.35375]
 [ 0.06978  0.10861  0.14912  0.19070  0.06796  0.03449  0.02751  0.35182]
]
``` 
## geometric
> static Matrix geometric({ required double p, required int row, required int column, int? seed })
> 
> 几何分布，其中p是成功的概率。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.0f";
  var mt = MatrixRandom.geometric(p: 0.1, row: 4, column: 7);
  mt.visible();
}
```
### output
```text
[
 [  1   3   1   1  33   2  15]
 [  4   3   2   6   1  12  18]
 [ 24   2   6   9  33   7   2]
 [  6   7  11   5  16   4  10]
]
```
## gumbel
> static Matrix gumbel({ required double loc, required double scale, required int row, required int column, int? seed })
> 
> 耿贝尔分布，其中loc是分布的众数的位置，scale是分布的尺度参数，并且必须为非负数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.gumbel(loc: 0, scale: 1, row: 2, column: 9);
  mt.visible();
}
```
### output
```text
[
 [-0.22699 -0.70834  2.46328 -0.27267  1.13736 -0.50648  0.10226  1.58143  3.05194]
 [ 1.54331 -0.05892  0.14372  3.15481  0.44702  0.25944 -0.13567  0.74313  0.23801]
]
```
## hypergeometric
> static Matrix hypergeometric({ required int N, required int K, required int n, required int row, required int column, int? seed })
> 
> 超几何分布，参数N、K、n分别表示元素总数、目标元素总数、抽取的样本数，最终得到样本中目标元素的数量。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.0f";
  var mt = MatrixRandom.hypergeometric(N: 100, K: 10, n: 50, row: 6, column: 6);
  mt.visible();
}
```
### output
```text
[
 [  2   8   6   6   5   3]
 [  4   4   2   7   3   5]
 [  6   2   2   7   6   3]
 [  3   5   5   7   6   7]
 [  7   8   6   7   5   5]
 [  5   4   7   8   4   3]
]
```
## laplace
> static Matrix laplace({ required double mu, required double b, required int row, required int column, int? seed })
> 
> 拉普拉斯分布，又称双指数分布，mu是位置参数，非负数b是尺度参数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.laplace(mu: 1, b: 2, row: 2, column: 8);
  mt.visible();
}
```
### output
```text
[
 [ 5.15415  2.07610 -1.37176 -2.41060 -0.99129  3.98637  0.31916  0.24522]
 [ 3.38619  4.86480 -1.78386  0.54009 -4.79726  4.24814  2.09560  2.00870]
]
```

## logistic
> static Matrix logistic({ required double mu, required double s, required int row, required int column, int? seed })
>
> 逻辑分布，其中mu和s分别是位置参数和尺度参数，s大于0。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.logistic(mu: 0, s: 1, row: 5, column: 6);
  mt.visible();
}
```
### output
```text
[
 [-2.34886 -0.62398 -0.72241 -0.47850 -3.57510  1.69050]
 [-0.65039  2.70643 -3.55987 -0.00253 -1.33383 -1.94184]
 [ 1.59177  2.44618  0.56556 -2.60605 -2.48145  0.41531]
 [-0.63856  0.37617  0.94475 -2.98747  3.46455  0.92113]
 [ 0.43686 -1.55776  1.55957  0.78217 -1.36549 -1.23248]
]
```

## lognormal
> static Matrix lognormal({ required double mu, required double sigma, required int row, required int column, int? seed })
> 
> 对数正态分布，其中mu和sigma分别是位置参数和尺度参数，sigma大于0。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = MatrixRandom.lognormal(mu: 0, sigma: 1, row: 5, column: 6);
  mt.visible();
}
```
### output
```text
[
 [ 0.37147  0.43134  2.04398  0.59404  0.89507  0.46283]
 [ 0.25305  3.53500  2.45734  0.25765  0.91990  1.25516]
 [ 1.50877  2.68362  1.31308  2.22121  0.44431  1.59400]
 [ 2.17962  4.71739  0.97841  0.41853  0.75954  1.39914]
 [ 0.30549  1.09713  2.18105  0.99588  8.03950  1.81075]
]
```

## multinomial
> static Matrix multinomial({ required int n, required List<double> p, required int row, int? seed })
> 
> 多项式分布，其中n表示实验次数，p是概率列表且和为1。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.0f";
  var mt = MatrixRandom.multinomial(n: 8, p: [0.15, 0.2, 0.1, 0.35, 0.05, 0.15], row: 5);
  mt.visible();
}
```
### output
```text
[
 [  2   2   1   3   0   0]
 [  1   5   0   1   0   1]
 [  0   1   0   4   1   2]
 [  2   0   0   3   1   2]
 [  1   2   1   3   1   0]
]
```

## poisson
> static Matrix poisson({ required double lambda, required int row, required int column, int? seed })
> 
> 泊松分布，参数lambda表示平均值。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  MatrixRandom.poisson(lambda: 3, row: 5, column: 9).visible();
}
```
### output
```text
[
 [ 2.00000  7.00000  4.00000  3.00000  5.00000  5.00000  1.00000  3.00000  7.00000]
 [ 1.00000  1.00000  2.00000  3.00000  5.00000  0.00000  2.00000  3.00000  5.00000]
 [ 2.00000  4.00000  0.00000  0.00000  5.00000  1.00000  2.00000  2.00000  4.00000]
 [ 1.00000  3.00000  5.00000  5.00000  4.00000  2.00000  4.00000  3.00000  5.00000]
 [ 4.00000  3.00000  1.00000  2.00000  2.00000  3.00000  0.00000  2.00000  6.00000]
]
```

## cauchy
> static Matrix cauchy({ required double x0, required double gamma, required int row, required int column, int? seed })
> 
> 柯西分布，参数x0是中心位置，正数gamma表示规模。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%3.5f";
  MatrixRandom.cauchy(x0: 0, gamma: 1, row: 3, column: 7).visible();  // stand-cauchy-distribution.
}
```
### output
```text
[
 [ -0.12131   9.06796  -3.06638   0.83097   1.10302  -0.78527  -1.10908]
 [  0.44494   5.59788  -5.16476  -3.09094   0.01960   2.58699   0.27861]
 [  0.01088  -0.87127  -2.68039  -0.02322   1.45664  -0.32921   0.25879]
]
```

## pareto
> static Matrix pareto({ required double xm, required double alpha, required int row, required int column, int? seed })
> 
> 帕累托分布，xm是规模参数，正数alpha是形状参数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%3.5f";
  MatrixRandom.pareto(xm: 0.5, alpha: 2, row: 3, column: 8).visible();
}
```
### output
```text
[
 [  1.63208   0.51504   0.51024   0.98437   0.52300   1.09564   1.39615   1.12143]
 [  0.66684   1.17252   0.50457   0.52373   0.61724   0.57446   0.66170   0.62191]
 [  0.51333   0.51563   0.66283   0.50024   0.52752   0.96687   0.63692   0.71290]
]
```
## rayleigh
> static Matrix rayleigh({ required double sigma, required int row, required int column, int? seed })
> 
> 瑞利分布，正数sigma是规模参数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.2f";
  MatrixRandom.rayleigh(sigma: 5, row: 2, column: 8).visible();
}
```
### output
```text
[
 [ 4.14  4.63 11.24 13.64 10.93  2.56  7.49  3.43]
 [ 3.73  1.64  8.93  3.25  9.83  5.23  4.97 11.78]
]
```
## triangular
> static Matrix triangular({ required double a, required double b, required double c, required int row, required int column, int? seed })
> 
> 三角分布，下限为a，上限为b，众数为c。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.2f";
  MatrixRandom.triangular(a: 1, b: 8, c: 5, row: 4, column: 8).visible();
}
```
### output
```text
[
 [ 3.66  4.67  3.68  5.92  4.96  2.80  6.62  5.98]
 [ 7.31  3.36  6.46  2.76  4.51  6.39  4.88  2.89]
 [ 6.81  6.93  5.15  3.55  4.90  6.11  4.44  7.10]
 [ 3.94  1.76  6.95  3.74  3.87  1.95  4.79  4.48]
]
```
## wald
> static Matrix wald({ required double mu, required double lambda, required int row, required int column, int? seed })
> 
> 逆高斯分布（也称为Wald 分布），平均值mu和形状参数lambda均为正数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.2f";
  MatrixRandom.wald(mu: 1, lambda: 2, row: 2, column: 6).visible();
}
```
### output
```text
[
 [ 0.82  0.53  0.90  1.89  1.10  1.61]
 [ 0.43  0.24  0.34  1.03  0.65  1.39]
]
```
## weibull
> static Matrix weibull({ required double k, required double lambda, required int row, required int column, int? seed })
> 
> 韦伯分布，尺度参数lambda和形状参数k均为正数。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.2f";
  MatrixRandom.weibull(k: 1, lambda: 2, row: 2, column: 6).visible();
}
```
### output
```text
[
 [ 2.85  1.49  0.61  1.87  1.71  4.27]
 [ 0.57  0.12  1.19  0.36  5.12  1.33]
]
```
## vonmises
> static Matrix vonmises({ required double k, required double mu, required int row, required int column, int? seed })
> 
> 冯·米塞斯分布，参数mu和k分别表示位置和集中度，k>0。
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.2f";
  MatrixRandom.vonmises(k: 1, mu: 0, row: 10, column: 10).visible();
}
```
### output
```text
[
 [-0.09 -0.85  0.63  0.59 -1.30  0.48  1.02  0.81 -1.13 -0.08]
 [ 0.51 -1.47 -0.11  0.69 -0.19 -0.04  0.49  0.96  0.20  0.82]
 [-1.12 -0.84 -1.13  1.60  0.21 -0.55 -0.43  1.27 -1.41  1.64]
 [-0.96 -1.76 -0.65  0.37 -0.57  0.09  0.30 -1.70  1.50 -0.22]
 [-0.49  0.26 -0.54 -0.96  0.31 -0.89 -0.20 -1.15  0.23  0.55]
 [ 1.09 -1.07  1.56  0.63  1.03  1.44 -1.46  0.61 -0.30  0.27]
 [ 0.51  0.92 -1.11 -0.41 -1.37 -0.98  0.62 -0.66 -0.60  0.80]
 [-0.55 -0.76 -0.45  0.42  0.01  0.13 -0.97  0.75 -0.94 -0.38]
 [ 0.08 -0.89 -0.50  1.46  0.99  1.55  1.19 -1.71 -1.11  1.09]
 [-1.14 -1.00 -1.91 -0.24  1.22 -0.36 -0.81 -0.55 -0.30  1.06]
]
```
## t
> static Matrix t({ required int v, required double mu, required int row, required int column, int? seed })
> 
> 学生t分布，正整数v表示自由度，mu是非中心参数
### test
```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.2f";
  var mt = MatrixRandom.t(v: 2, mu: 0, row: 5, column: 8);
  mt.visible();
}
```
### output
```text
[
 [-0.40 -0.42 -1.23 -2.11 -0.63 -0.29 -7.35  1.27]
 [-0.62  0.82  0.98  1.41 -1.53 -4.18 -2.16  0.29]
 [ 3.05 -1.58 -0.14 -1.29 -4.22 -4.17 -2.38  0.54]
 [ 1.11  0.37 -0.79  2.72 -0.19  0.70 -0.38 -1.37]
 [-0.36 -1.06 -1.33  1.33 -4.32  0.73 -1.34  0.06]
]
```

[下一篇：线性代数](linalg.md)