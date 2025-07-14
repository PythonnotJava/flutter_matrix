# 工具包

## Typed
- Typed枚举目前作用于转换Matrix数据到指定类型的二维列表，具体请看[toList](basement.md#tolist)
```text
enum Typed { int8, int16, int32, int64, int, float32, float64, double, bool, uint8, uint16, uint32, uint64, complex }
```
## Alert
- Alert类用于警告某些类或者方法
```text
final class Alert {
  final String msg;
  const Alert(this.msg);
  String toString() => 'Alert : $msg';
}
```

## Since
- Since类用于在某些类或者方法发生重大变化的时候备注
```text
final class Since {
  final String msg;
  const Since(this.msg);
  String toString() => 'Since : $msg';
}
```

## Marker
- 通用标记
```text
final class Marker {
  final String? msg;
  const Marker([String? msg]) : msg = msg ?? "";
  String toString() => 'Marker : $msg';
}
```

## Range
- [Range] 是范围的抽象，其中 [start] 不能大于 [end]
- [count] 表示范围的等份数
- 当 [count] 等于零时，表示连续范围
- [closure_left]、[closure_right] 表示范围是否包含边界值
- 默认为左闭合、右开放的连续范围
- 当范围在任何边界无限大时，count 始终为 0，且边界只能开放

```text
Range({
    required this.start,
    required this.end,
    int count = 0,
    bool closure_left = true,
    bool closure_right = false,
  })
```



