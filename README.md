# Flutter Matrix  

---
<div style="text-align: center;">
    <a href="https://github.com/PythonnotJava/flutter_matrix">
        <img src="https://github.com/PythonnotJava/flutter_matrix/raw/V0.1.X/flutter_matrix/docs/design.png" alt="" style="border-radius: 20px; display: block;"/>
    </a>
</div>

## 💡What's the Flutter Matrix?

<p style="text-indent: 2em">
The matrix class designed for Flutter supports any platform 
because it is implemented in pure Dart. It supports basic matrix operations,
linear algebra, probability theory and mathematical statistics, 
geometric simulation, center difference, and more.
</p>

<p style="text-indent: 2em">
Pub address : 
<a href="https://pub.dev/packages/flutter_matrix" target="_blank">
    https://pub.dev/packages/flutter_matrix
</a>
</p>

## 🗺️RoadMap

```mermaid
graph TB 
    ListExtension([MatrixExtension])
    Basement[(MatrixBase)]
    Wrapper[(MatrixWrapper)]
    Geometry(MatrixGeometry)
    Linalg(MatrixLinalg)
    Math(MatrixMath)
    MachineLearning(MatrixML)
    Random(MatrixRandom)
    Visualization(MatrixVisualization)
    Matrix{{Matrix}}
    MatrixCollection{{MatrixCollection}}
    
    ListExtension --> Basement --> Wrapper --> Matrix;
    Wrapper --> MatrixCollection;

    subgraph ExtensionModules
        Geometry(MatrixGeometry)
        Linalg(MatrixLinalg)
        Math(MatrixMath)
        MachineLearning(MatrixML)
        Random(MatrixRandom)
        Visualization(MatrixVisualization)
    end
    
    ExtensionModules --> Basement
    
```

--- 

```mermaid
mindmap
  root((flutter_matrix))
    MatrixBase
      构造 / 工厂
        fill
        arrange
        range
        linspace
        E
        ELike
        deepCopy
        broadcast
        align
      形状操作
        reshape
        resize
        flatten
        concat
        slice
        select
        drop
        append
      访问 / 查询
        row_
        column_
        contain
        equalTo
        isShared
        hasSameShape
        size
        flattened
        isSquare
        deepcopy
      输出
        toString
        visible
        setMask
        toList
        replaceRow
        sort
        compare

    Linalg 线性代数
      基本属性
        det
        rank
        trace
        inverse
        adjugate
        rref
        T_
        transpose
      乘法
        product
        kronecker
      初等变换
        elementaryExchange
        elementaryMultiply
        elementaryAdd
      余子式
        coincidental

    Math 数学
      三角函数
        sin
        cos
        tan
        asin
        acos
        atan
        atan2
      双曲函数
        sinh
        cosh
        tanh
        asinh
        acosh
        atanh
      指数 / 对数
        exp
        log
        log10
        sqrt
      取整 / 符号
        abs
        ceil
        floor
        round
        sgn
        square
        cube
      角度转换
        degree
        radian
      聚合
        min
        max
        sum
        argmin
        argmax
        getRange
        power
      广播运算
        add
        minus
        multiply
        divide
      傅里叶
        fft_Complex
        dftComplex
        dft
        toComplexLike
      微分
        diff

    Functools 函数工具
      判断
        any
        all
        count
      变换
        customize
        confront
        clip
        replace
        reduce

    ML 机器学习
      激活函数
        ReLU
        LeakyReLU
        ELU
        Sigmoid
        Softmax
        Swish
        Softsign
        Softplus
      损失函数
        MAE
        MSE

    Random 概率统计
      统计量
        mean
        median
        mode
      数据扰动
        shakeTotal
        shakePercent
        shakeProbably
        shuffle
      连续分布
        uniform
        normal
        exponential
        gamma
        beta
        dirichlet
        laplace
        logistic
        lognormal
        cauchy
        pareto
        rayleigh
        triangular
        wald
        weibull
        vonmises
        gumbel
        frechet
        chisquare
        f
        t
      离散分布
        binomial
        geometric
        hypergeometric
        multinomial
        poisson

    Geometry 几何
      变换
        rotateTransform
        projectionTransform
        shearTransform
        scaleTransform
      曲线
        curve
        custom_curve
        line
        xline
        yline
      椭圆 / 圆
        ellipse_edge
        ellipse_area
        circle_edge
        circle_area
      三维
        camera

    Visualization 可视化
      toHist
      toBar

    Complex 复数
      构造
        fromPolar
        fromList
      属性
        mod
        arg
        conjugate
        isNan
      运算
        exp
        sqrt
        sin
        cos
        tan
      转换
        toList
        toPoint
        toFloat64x2
        deepcopy

    Utils 工具函数
      数学函数
        sinh / cosh / tanh
        asinh / acosh / atanh
        log10
        square / cube / abs
        ceil / floor / round
        degree / radian
        diffCentral
        adaptiveSimpson
        binomialCoefficient
        erf
      随机采样
        choose
      颜色
        hexToAnsi
      RandomGenerator 单例
        StandardNormal / Normal
        Uniformm
        Binomial / Multinomial / Poisson
        Geometric / Hypergeometric
        Gamma / Beta / Dirichlet
        Chisquare / F / Student_t
        Exponential / Laplace / Logistic
        Lognormal / Wald / Weibull
        Cauchy / Pareto / Rayleigh
        Triangular / Gumbel / Vonmises / Frechet
```




## 📄Need a local document?
<p style="text-indent: 2em">
Flutter Matrix provides a local doc 
(by markdown, but you need to rename the folder to docs first)
folder and a mkdocs-based building module.
If you have Python in your environment, 
change to the same directory as the mkdocs.yml file and run the following command.
</p>

```text
pip install mkdocs mkdocs-material pymdown-extensions mkdocs-material-extensions
```
<p style="text-indent: 2em">
After successfully installing the above libraries, run the following command again. 
You will find that you have generated a folder named site. Open the index.html in the folder to browse the online web documents.

</p>

```
mkdocs build
```

<p style="text-indent: 2em">
I also provide online documents: <a href="https://www.robot-shadow.cn/src/pkg/Flutter_Matrix/site/">👉Click Me!👈</a>

</p>

## 🛎️Attention.
- Flutter Matrix can run in a pure Dart environment.

## ✍️Example
- Use `arrange` to generate a data matrix with evenly spaced intervals.
```dart
import 'package:flutter_matrix/matrix_type.dart';

main(){
  data_format = "%2.0f";
  var t = MatrixBase.linspace<Matrix>(
      row: 10, 
      column: 10, 
      start: 1, 
      end: 100, 
      keep: true
  );
  t.visible();
}
```
- Output.
```text
[
 [  1   2   3   4   5   6   7   8   9  10]
 [ 11  12  13  14  15  16  17  18  19  20]
 [ 21  22  23  24  25  26  27  28  29  30]
 [ 31  32  33  34  35  36  37  38  39  40]
 [ 41  42  43  44  45  46  47  48  49  50]
 [ 51  52  53  54  55  56  57  58  59  60]
 [ 61  62  63  64  65  66  67  68  69  70]
 [ 71  72  73  74  75  76  77  78  79  80]
 [ 81  82  83  84  85  86  87  88  89  90]
 [ 91  92  93  94  95  96  97  98  99 100]
]
```

- 3D transformation of geometry

![img](https://github.com/PythonnotJava/flutter_matrix/raw/V1.X.X/flutter_matrix/example/3d.png)