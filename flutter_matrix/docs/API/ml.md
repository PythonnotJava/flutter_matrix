# 一些机器学习工具的简单实现

## Softmax

> Matrix Softmax({int dim = -1})
>
> 将数据映射为概率分布，定义如下（实际中会考虑排除数据中的最大值，这里不考虑）：
>
> $$
> Softmax(X) = \frac{e^{x_i}}{\displaystyle \sum_{i \in N } e^{x_i}}
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.6f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 3, 4, 9],
    [3, 5, 7, 6]
  ]);
  print(mt.Softmax(dim: 0));
  print(mt.Softmax(dim: 1));
  print(mt.Softmax(dim: 2));
}
```

### output

```text
[
 [ 0.082595  0.224515  0.610296  0.082595]
 [ 0.000903  0.002454  0.006670  0.989973]
 [ 0.012038  0.088947  0.657233  0.241783]
]
[
 [ 0.090031  0.042010  0.017148  0.000319]
 [ 0.244728  0.114195  0.046613  0.952270]
 [ 0.665241  0.843795  0.936240  0.047411]
]
[
 [ 0.000275  0.000747  0.002032  0.000275]
 [ 0.000747  0.002032  0.005522  0.819600]
 [ 0.002032  0.015012  0.110921  0.040805]
]
```

## LeakyReLU

> Matrix LeakyReLU({double alpha = 0.01})
>
> LeakyReLU是一种改进的激活函数，旨在解决ReLU函数中负输入导致的零梯度问题。
>
> $$
> LeakyReLU(X) =
> $$

\begin{cases}
x, & x > 0 \\
\alpha x, & x \le 0
\end{cases}$$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.6f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.LeakyReLU());
}
```

### output

```text
[
 [ 1.000000  2.000000  3.000000  1.000000]
 [ 2.000000  0.000000 -0.040000 -0.020000]
 [ 0.000000  5.000000  7.000000 -0.060000]
]
```

## ReLU

> Matrix ReLU()
>
> 激活函数ReLU。
>
> $$
> ReLU(x) = max(x, 0)
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.0f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.ReLU());
}

```

### output

```text
[
 [  1   2   3   1]
 [  2   0  -0  -0]
 [  0   5   7  -0]
]
```

## Sigmoid

> Matrix Sigmoid()
>
> 激活函数，也被称为S型生长曲线。
>
> $$
> Sigmoid(x) = \frac{1}{1 + e^{-x}}
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.Sigmoid());
}

```

### output

```text
[
 [ 0.73106  0.88080  0.95257  0.73106]
 [ 0.88080  0.50000  0.01799  0.11920]
 [ 0.50000  0.99331  0.99909  0.00247]
]
```

## ELU

> Matrix ELU({required double alpha})
>
> 激活函数ELU。
>
> $$
> ELU(x) = \begin{cases} x, &x > 0 \\ \alpha (e^x - 1), & x \le 0\end{cases}
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.ELU(alpha: 0.1));
}
```

### output

```text
[
 [ 1.00000  2.00000  3.00000  1.00000]
 [ 2.00000  0.00000 -0.09817 -0.08647]
 [ 0.00000  5.00000  7.00000 -0.09975]
]
```

## Swish

> Matrix Swish()
>
> Swish是一种自我门控的激活函数。
>
> $$
> Swish(x) = x * Sigmoid(x)
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.Swish());
}
```

### output

```text
[
 [ 0.73106  1.76159  2.85772  0.73106]
 [ 1.76159  0.00000 -0.07194 -0.23841]
 [ 0.00000  4.96654  6.99362 -0.01484]
]
```

## Softsign

> Matrix Softsign()
>
> Softsign函数是Tanh函数的另一个替代选择。
>
> $$
> Softsign(x) = \frac{x}{1+ |x|}
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.Softsign());
}
```

### output

```text
[
 [ 0.50000  0.66667  0.75000  0.50000]
 [ 0.66667  0.00000 -0.80000 -0.66667]
 [ 0.00000  0.83333  0.87500 -0.85714]
]
```

## Softplus

> Matrix Softplus()
>
> Softplus函数可以看作是ReLU函数的平滑。
>
> $$
> Softplus(x) = log(1 + e^x)
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  data_format = "%2.5f";
  var mt = Matrix.fromList([
    [1, 2, 3, 1],
    [2, 0, -4, -2],
    [0, 5, 7, -6]
  ]);
  print(mt.Softplus());
}
```

### output

```text
[
 [ 1.31326  2.12693  3.04859  1.31326]
 [ 2.12693  0.69315  0.01815  0.12693]
 [ 0.69315  5.00672  7.00091  0.00248]
]
```

## MAE

> Object MAE({required Matrix other, int dim = -1})
>
> 平均绝对值误差，它表示预测值和观测值之间绝对误差的平均值。
>
> $$
> MAE(X, h) = \frac{1}{n} \displaystyle \sum_{i \in N} |y_i - \hat{y_i}|
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  var mt = Matrix.fromList([
    [1.2, 1.3, 4.2, 2.2, 1.4],
    [0, 0.3, 2.3, 1.3, 1.7],
    [1.9, 1.83, 1.2, 2, 2.1]
  ]);
  print(mt.MAE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 0));
  print(mt.MAE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 1));
  print(mt.MAE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 2));
}
```

### output

```text
[1.06, 0.8, 0.8059999999999998]
[0.6999999999999998, 0.61, 1.5666666666666667, 0.8333333333333334, 0.7333333333333334]
0.8886666666666666
```

## MSE

> Object MSE({required Matrix other, int dim = -1})
>
> MSE通过计算预测值和真实值之间的误差平方的平均值，来衡量模型的预测性能。
>
> $$
> MSE = \frac{1}{n} \displaystyle \sum_{i \in N} (y_i - \hat{y}_i) ^2
> $$

### test

```text
import '../lib/flutter_matrix.dart';

main(){
  var mt = Matrix.fromList([
    [1.2, 1.3, 4.2, 2.2, 1.4],
    [0, 0.3, 2.3, 1.3, 1.7],
    [1.9, 1.83, 1.2, 2, 2.1]
  ]);
  print(mt.MSE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 0));
  print(mt.MSE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 1));
  print(mt.MSE(other: Matrix.fill(number: 1, row: mt.shape[0], column: mt.shape[1]), dim: 2));
}
```

### output

```text
[2.3940000000000006, 0.7519999999999999, 0.74978]
[0.6166666666666666, 0.42296666666666666, 3.99, 0.8433333333333334, 0.62]
1.2985933333333333
```
