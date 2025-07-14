# 可视化的抽象实现

## toHist
- 生成与直方图匹配的可视化抽象
- [start] 为计数值的起点，[end] 为计数值的终点
- [counts] 表示区间数，区间遵循左闭右开的原则
- 此方法的灵活性在于可以对某些区间数据进行直方图计数
- 请提取并处理特殊值
  
```text
Map<Range, int> toHist({required double start, required double end, required int counts })
```
### test
```dart
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = MatrixBase.range<Matrix>(row: 5, column: 6, start: 1)..visible();
  print(mt.toHist(start: 1, end: 20, counts: 2));
}
```
### output
```text
[
 [1.00000 2.00000 3.00000 4.00000 5.00000 6.00000]
 [7.00000 8.00000 9.00000 10.00000 11.00000 12.00000]
 [13.00000 14.00000 15.00000 16.00000 17.00000 18.00000]
 [19.00000 20.00000 21.00000 22.00000 23.00000 24.00000]
 [25.00000 26.00000 27.00000 28.00000 29.00000 30.00000]
]
{Range: [1.0, 10.5), count: 0: 10, Range: [10.5, 20.0), count: 0: 9}
```

## toBar
- 抽象直方图统计
```text
Map<double, int> toBar()
```
### test
```text
import 'package:flutter_matrix/matrix_type.dart';

main() {
  var mt = Matrix.fromList([
    [1, 4, 0, 8, 2],
    [2, 1, 9, 8, 2],
    [8, 2, 0, 8, 2],
    [5, 4, 6, 2, 8],
  ])..visible();
  print(mt.toBar());
}
```
### output
```text
[
 [1.00000 4.00000 0.00000 8.00000 2.00000]
 [2.00000 1.00000 9.00000 8.00000 2.00000]
 [8.00000 2.00000 0.00000 8.00000 2.00000]
 [5.00000 4.00000 6.00000 2.00000 8.00000]
]
{1.0: 2, 4.0: 2, 0.0: 2, 8.0: 5, 2.0: 6, 9.0: 1, 5.0: 1, 6.0: 1}
```

[下一篇：复数定义](complex.md)