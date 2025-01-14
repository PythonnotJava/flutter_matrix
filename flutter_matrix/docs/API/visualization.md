# 可视化处理

## toHist
> Map<Range, int> toHist({required double start, required double end, required int counts })
> 
> 转直方图  
> 案例请参考[uniform](random.md#uniform)

## toBar
> Map<double, int> toBar()
> 
> 转柱状图（或者是条形图）
### test
```text
import '../flutter_matrix.dart';

main() {
  var mt = Matrix.fromList([
    [1, 2, 3, 4, 2, 1],
    [3, 4, 6, 0, 0, 3],
    [1, 5, 8, 4, 2, 3],
    [3, 4, 8, 9, 9, 5],
  ]);
  print(mt.toBar());
}
```
### output
```text
{1.0: 3, 2.0: 3, 3.0: 5, 4.0: 4, 6.0: 1, 0.0: 2, 5.0: 2, 8.0: 2, 9.0: 2}
```

