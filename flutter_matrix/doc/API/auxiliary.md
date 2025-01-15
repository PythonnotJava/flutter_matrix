# 辅助
> 辅助函数封装了一些尤其是对二维列表操作的非拓展方法，且大多均为私有方法。还有一些是辅助类。

## Typed
> enum Typed { int8, int16, int32, int64, int, float32, float64, double, bool, uint8, uint16, uint32, uint64, complex }
>
> Typed枚举目前作用于转换Matrix数据到指定类型的二维列表，具体请看[toList](basement.md#tolist)

## Alert
> final class Alert
> 
> Alert类用于警告某些类或者方法  

## Since
> final class Since
> 
> Since类用于在某些类或者方法发生重大变化的时候备注

[下一篇：函数工具](functools.md)