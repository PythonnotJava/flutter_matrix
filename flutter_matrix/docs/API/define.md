# 类型定义和构建

> 矩阵是矩阵类。
> - 内部使用`List`（属性名self)存储核心数据，默认构造时，不考虑是否为空。
> - 如果一个形状（属性名shape）被传入，它将基于传入的形状，传入时可以指定形状，避免形状再计算。
> - 为了增加灵活性，矩阵中的列表在创建时默认都是可增长的。
> - 在实现矩阵方法时，一切从简，更多的考虑是逻辑而不是性能，但是也不是完全离谱到抛弃性能。

## 基础构造函数
> Matrix(List<List<num>> data, {int? known_row, int? known_column})
>   
> 传入一个二维列表并复数数据存储到矩阵，可以选择性传入已知的形状参数

### 测试
```dart
import 'flutter_matrix.dart';

main() {
  var mt1 = Matrix([
    [4, 1, 0, 9],
    [0, 3, 1, 9],
    [5, 6, 3, 2],
  ]);
  print(mt1);
}
```

### 输出
```text
[
 [4.00000 1.00000 0.00000 9.00000]
 [0.00000 3.00000 1.00000 9.00000]
 [5.00000 6.00000 3.00000 2.00000]
]
```


