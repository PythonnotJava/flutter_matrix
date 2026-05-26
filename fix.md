# flutter_matrix 修复建议（可直接替换的函数集）

> 格式：每一条都给出「文件 / 原函数位置 / 问题说明 / 替换代码」。直接用对应的片段覆盖即可。
> 建议分批替换并跑一次单元测试，避免一次改太多难以定位。

---

## 0. 前置依赖

部分替换版本会用到若干小 helper（例如 `_isNotFinite`、`_logSumExp`），统一放在 `matrix_extension.dart` 文件顶部（位于 `extension MatrixExtension on List<List<double>>` 之前）：

```dart
// ---- helpers used by the patched functions below ----
double _stableExpShift(double x, double maxV) => math.exp(x - maxV);

// log(1 + exp(-|x|)) in a numerically stable way
double _softplusStable(double x) {
  if (x > 0) return x + math.log(1 + math.exp(-x));
  return math.log(1 + math.exp(x));
}

double _sigmoidStable(double x) {
  if (x >= 0) {
    final z = math.exp(-x);
    return 1.0 / (1.0 + z);
  } else {
    final z = math.exp(x);
    return z / (1.0 + z);
  }
}

bool _isPowerOfTwo(int n) => n >= 1 && (n & (n - 1)) == 0;
```

---

## 1. `shape` + `append` 突变失效（严重）

**文件**：`lib/src/matrix_extension.dart:18, 387-397`
**问题**：`shape` 每次返回新 `List<int>`，`append` 里的 `shape[0] += 1` / `shape[1] += 1` 改的是临时对象，无效。

> 说明：这个 extension 层的 `shape` 是派生属性，实际有效的是 `MatrixBase.shape`（`matrix_base.dart:185` 里会显式 `shape = self.shape`）。这里把 `append` 的无效赋值去掉即可，同时把 `shape` 缓存一个本地变量以避免在热路径反复分配。

```dart
void append(List<double> data, {bool horizontal = true}) {
  if (horizontal) {
    assert(isEmpty || data.length == this[0].length);
    add(List<double>.from(data));
  } else {
    final rows = length;
    assert(data.length == rows);
    for (int r = 0; r < rows; r++) {
      this[r].add(data[r]);
    }
  }
}
```

---

## 2. `_det` 奇异性判断用 `== 0`（严重）

**文件**：`lib/src/matrix_extension.dart:128-161`
**问题**：`matrixcpy[max_row][i] == 0` 对浮点不稳；应用 `tolerance_round`。另外顺手用已有的 `deepcopy` 代替手写拷贝。

```dart
static double _det(
    {required List<List<double>> mt_this, required List<int> mt_shape}) {
  var [row, column] = mt_shape;
  assert(row == column);
  final n = row;
  final matrixcpy = mt_this.deepcopy;
  double detValue = 1.0;

  for (int i = 0; i < n; i++) {
    int max_row = i;
    double max_abs = matrixcpy[i][i].abs();
    for (int k = i + 1; k < n; k++) {
      final v = matrixcpy[k][i].abs();
      if (v > max_abs) {
        max_abs = v;
        max_row = k;
      }
    }
    if (max_abs <= tolerance_round) {
      return 0.0;
    }
    if (max_row != i) {
      matrixcpy.swap(max_row, i);
      detValue = -detValue;
    }
    final pivot = matrixcpy[i][i];
    detValue *= pivot;
    for (int k = i + 1; k < n; k++) {
      final factor = matrixcpy[k][i] / pivot;
      if (factor == 0.0) continue;
      final rowI = matrixcpy[i];
      final rowK = matrixcpy[k];
      for (int j = i; j < n; j++) {
        rowK[j] -= factor * rowI[j];
      }
    }
  }
  return detValue;
}
```

---

## 3. `inverse` 用 adjugate / det 不可用（严重）

**文件**：`lib/src/matrix_extension.dart`（原 `inverse` 走 `adjugate / det`）
**问题**：O(n⁵) 以上，并且 det 重算。改为在 `[A | I]` 上直接 Gauss–Jordan。

> 把原先的 `inverse` getter 替换成下面这段；`adjugate` 保留只作为数学概念使用即可（或者你嫌它慢就别对外暴露）。

```dart
List<List<double>> get inverse {
  var [row, column] = shape;
  assert(row == column, 'inverse requires a square matrix');
  final n = row;

  // 构造增广矩阵 [A | I]
  final a = List.generate(
    n,
    (r) => List<double>.filled(2 * n, 0.0, growable: false),
    growable: false,
  );
  for (int r = 0; r < n; r++) {
    final src = this[r];
    final dst = a[r];
    for (int c = 0; c < n; c++) dst[c] = src[c];
    dst[n + r] = 1.0;
  }

  // Gauss-Jordan + partial pivoting
  for (int i = 0; i < n; i++) {
    int pivot = i;
    double maxAbs = a[i][i].abs();
    for (int k = i + 1; k < n; k++) {
      final v = a[k][i].abs();
      if (v > maxAbs) {
        maxAbs = v;
        pivot = k;
      }
    }
    if (maxAbs <= tolerance_round) {
      throw StateError('Matrix is singular (pivot ~ 0 at row $i)');
    }
    if (pivot != i) {
      final tmp = a[pivot];
      a[pivot] = a[i];
      a[i] = tmp;
    }

    final inv = 1.0 / a[i][i];
    final rowI = a[i];
    for (int c = 0; c < 2 * n; c++) rowI[c] *= inv;

    for (int r = 0; r < n; r++) {
      if (r == i) continue;
      final factor = a[r][i];
      if (factor == 0.0) continue;
      final rowR = a[r];
      for (int c = 0; c < 2 * n; c++) {
        rowR[c] -= factor * rowI[c];
      }
    }
  }

  // 取右半部分作为逆
  return List.generate(
    n,
    (r) => List<double>.generate(n, (c) => a[r][n + c], growable: true),
    growable: true,
  );
}
```

---

## 4. `product` 缓存不友好（严重）

**文件**：`lib/src/matrix_extension.dart:1256-1272`
**问题**：i-j-k 三重循环 + 内层列向访问。改成 i-k-j（列 j 在最内循环）让 `other[k]` 在 j 循环中保持命中。

```dart
List<List<double>> product({required List<List<double>> other}) {
  var [row, column] = shape;
  var [other_row, other_column] = other.shape;
  assert(column == other_row,
      'product: shape mismatch $shape x ${other.shape}');

  final data = List.generate(
    row,
    (_) => List<double>.filled(other_column, 0.0, growable: true),
    growable: true,
  );

  for (int i = 0; i < row; i++) {
    final rowI = this[i];
    final outI = data[i];
    for (int k = 0; k < column; k++) {
      final a = rowI[k];
      if (a == 0.0) continue;
      final rowK = other[k];
      for (int j = 0; j < other_column; j++) {
        outI[j] += a * rowK[j];
      }
    }
  }
  return data;
}
```

---

## 5. FFT 只用 `assert` 守卫 2 的幂（严重）

**文件**：`lib/src/matrix_extension.dart:970-976`
**问题**：release 下 `assert` 被剥离，非 2 的幂会返回错误结果。改为显式抛异常。

```dart
List<List<double>> fftComplex() {
  var [row, column] = shape;
  if (column != 2) {
    throw ArgumentError(
        'fftComplex expects [real, imag] rows (column == 2), got column=$column');
  }
  if (!_isPowerOfTwo(row) || row < 2) {
    throw ArgumentError(
        'fftComplex requires row to be a power of two and >= 2, got row=$row');
  }
  return _fft(mt_this: this, mt_shape: shape)
      .map((complex) => complex.toList)
      .toList();
}
```

---

## 6. 注册表 null 解引用（严重）

**文件**：`lib/src/matrix_base.dart:9-19`
**问题**：未注册的子类会抛出晦涩的类型转换/空检查错误。加一个带有明确报错信息的 helper。

```dart
final _subClassFromListConstructor = <Type, FromListConstructor>{
  Matrix: Matrix.fromList,
  MatrixCollection: MatrixCollection.fromList,
};

void registerSubClassFromListConstructor(
    Type type, FromListConstructor fromListConstructor) {
  _subClassFromListConstructor[type] = fromListConstructor;
}

FromListConstructor<T> _resolveFromList<T extends MatrixBase<T>>() {
  final ctor = _subClassFromListConstructor[T];
  if (ctor == null) {
    throw StateError(
      'Subclass "$T" is not registered. '
      'Call registerSubClassFromListConstructor($T, ${T}.fromList) '
      'before using MatrixBase generic constructors.',
    );
  }
  return ctor as FromListConstructor<T>;
}
```

然后把 `MatrixBase` 里所有形如
```dart
final fromList = _subClassFromListConstructor[T] as FromListConstructor<T>;
```
的行（`fill`/`arrange`/`linspace`/`deepCopy`/`broadcast`/`range`/`E`/`ELike`/`align`）统一改为：
```dart
final fromList = _resolveFromList<T>();
```

---

## 7. `shape` 减少重复分配（性能 / 严重）

**文件**：`lib/src/matrix_extension.dart:18`
**问题**：每次 getter 都 `new` 一个 `List<int>`。保留语义但提醒：热路径请用 `length` / `this[0].length` 自行缓存局部变量，不要反复读 `shape`。替换函数本身不需要改 `shape`，但把 `hasSameShape` 改成不走 `shape`：

```dart
bool hasSameShape(List<List<double>> other) =>
    length == other.length &&
    (isEmpty || this[0].length == other[0].length);
```

---

## 8. `switch(mode) + 闭包` 反模式（主要）

**文件**：`lib/src/matrix_extension.dart:77-88, 30-34, 212-241, 419-437`
**问题**：未知 mode 静默回退（`pow`、`identity`、`NaN`）。最小改动：抛异常。

```dart
static double Function(double, double) _abstractOperator(int mode) {
  return switch (mode) {
    0 => (x, y) => x + y,
    1 => (x, y) => x - y,
    2 => (x, y) => x * y,
    3 => (x, y) => x / y,
    4 => (x, y) => (x ~/ y).toDouble(),
    5 => (x, y) => (x % y).toDouble(),
    _ => throw ArgumentError('Unknown operator mode: $mode'),
  };
}

static double Function(double, double) _mathBasementDouble(int mode) {
  return switch (mode) {
    0 => _powDouble,
    1 => math.atan2,
    _ => throw ArgumentError('Unknown math basement double mode: $mode'),
  };
}

static double Function(double) _mathBasementSingle(int mode) {
  return switch (mode) {
    0 => math.sin,
    1 => math.cos,
    2 => math.tan,
    3 => math.asin,
    4 => math.acos,
    5 => math.atan,
    6 => sinh,
    7 => cosh,
    8 => tanh,
    9 => asinh,
    10 => acosh,
    11 => atanh,
    12 => math.exp,
    13 => math.log,
    14 => math.sqrt,
    15 => log10,
    16 => square,
    17 => cube,
    18 => abs,
    19 => ceil,
    20 => floor,
    21 => round,
    22 => degree,
    23 => radian,
    _ => throw ArgumentError('Unknown single math mode: $mode'),
  };
}
```

---

## 9. `Softmax` 数值稳定化（主要）

**文件**：`lib/src/matrix_extension.dart:1626-1674`
**问题**：没做 `exp(x - max(x))`，大 x 溢出为 `inf` → 除出 `NaN`。

```dart
List<List<double>> Softmax({int dim = -1}) {
  var [row, column] = shape;
  if (dim == 0) {
    // per-row softmax
    return List.generate(row, (r) {
      final src = this[r];
      double maxV = src[0];
      for (int c = 1; c < column; c++) {
        if (src[c] > maxV) maxV = src[c];
      }
      double sum = 0.0;
      final out = List<double>.filled(column, 0.0, growable: true);
      for (int c = 0; c < column; c++) {
        out[c] = math.exp(src[c] - maxV);
        sum += out[c];
      }
      if (sum == 0.0) sum = 1.0; // all -inf fallback
      for (int c = 0; c < column; c++) out[c] /= sum;
      return out;
    });
  } else if (dim == 1) {
    // per-column softmax
    final out = List.generate(
        row, (_) => List<double>.filled(column, 0.0, growable: true));
    for (int c = 0; c < column; c++) {
      double maxV = this[0][c];
      for (int r = 1; r < row; r++) {
        if (this[r][c] > maxV) maxV = this[r][c];
      }
      double sum = 0.0;
      for (int r = 0; r < row; r++) {
        final v = math.exp(this[r][c] - maxV);
        out[r][c] = v;
        sum += v;
      }
      if (sum == 0.0) sum = 1.0;
      for (int r = 0; r < row; r++) out[r][c] /= sum;
    }
    return out;
  } else {
    // global softmax over all elements
    double maxV = this[0][0];
    for (int r = 0; r < row; r++) {
      final src = this[r];
      for (int c = 0; c < column; c++) {
        if (src[c] > maxV) maxV = src[c];
      }
    }
    final out = List.generate(
        row, (_) => List<double>.filled(column, 0.0, growable: true));
    double sum = 0.0;
    for (int r = 0; r < row; r++) {
      final src = this[r];
      final dst = out[r];
      for (int c = 0; c < column; c++) {
        dst[c] = math.exp(src[c] - maxV);
        sum += dst[c];
      }
    }
    if (sum == 0.0) sum = 1.0;
    for (int r = 0; r < row; r++) {
      final dst = out[r];
      for (int c = 0; c < column; c++) dst[c] /= sum;
    }
    return out;
  }
}
```

---

## 10. `Sigmoid` / `Softplus` 数值稳定化（主要）

**文件**：`lib/src/matrix_extension.dart`（原先使用 `1/(1+exp(-x))` 和 `log(1+exp(x))`）

```dart
List<List<double>> Sigmoid() {
  return List.generate(
    length,
    (r) => List<double>.generate(
      this[r].length,
      (c) => _sigmoidStable(this[r][c]),
      growable: true,
    ),
    growable: true,
  );
}

List<List<double>> Softplus() {
  return List.generate(
    length,
    (r) => List<double>.generate(
      this[r].length,
      (c) => _softplusStable(this[r][c]),
      growable: true,
    ),
    growable: true,
  );
}
```

---

## 11. `argmin`/`argmax` 合并一次遍历（主要）

**文件**：`lib/src/matrix_extension.dart:902-924`
**问题**：先求 min/max 再 `indexOf`，两次扫描；且对含 NaN 的矩阵 `indexOf` 返回 -1。

```dart
Object _argMinMax(bool isMin, {int dim = -1}) {
  var [row, column] = shape;
  int _argRow(List<double> list) {
    int idx = 0;
    double best = list[0];
    for (int i = 1; i < list.length; i++) {
      final v = list[i];
      if (isMin ? v < best : v > best) {
        best = v;
        idx = i;
      }
    }
    return idx;
  }

  if (dim == 0) {
    return List.generate(row, (r) => _argRow(this[r]));
  } else if (dim == 1) {
    return List.generate(column, (c) {
      int idx = 0;
      double best = this[0][c];
      for (int r = 1; r < row; r++) {
        final v = this[r][c];
        if (isMin ? v < best : v > best) {
          best = v;
          idx = r;
        }
      }
      return idx;
    });
  } else {
    int bestR = 0, bestC = 0;
    double best = this[0][0];
    for (int r = 0; r < row; r++) {
      final src = this[r];
      for (int c = 0; c < column; c++) {
        final v = src[c];
        if (isMin ? v < best : v > best) {
          best = v;
          bestR = r;
          bestC = c;
        }
      }
    }
    return bestR * column + bestC;
  }
}
```

---

## 12. `sortExtension(dim:1)` 避免双次转置（主要）

**文件**：`lib/src/matrix_extension.dart:586-617`
**问题**：先整体转置再排再转回，分配多一份；改成"取一列 → 排序 → 写回"。

```dart
void sortExtension({bool reverse = false, int dim = -1}) {
  var [row, column] = shape;
  final cmp = reverse
      ? (double a, double b) => b.compareTo(a)
      : (double a, double b) => a.compareTo(b);

  if (dim == 0) {
    for (final list in this) {
      list.sort(cmp);
    }
  } else if (dim == 1) {
    final buf = List<double>.filled(row, 0.0, growable: false);
    for (int c = 0; c < column; c++) {
      for (int r = 0; r < row; r++) buf[r] = this[r][c];
      buf.sort(cmp);
      for (int r = 0; r < row; r++) this[r][c] = buf[r];
    }
  } else {
    final data = flattened..sort(cmp);
    int i = 0;
    for (int r = 0; r < row; r++) {
      final dst = this[r];
      for (int c = 0; c < column; c++) dst[c] = data[i++];
    }
  }
}
```

---

## 13. `reduceExtension` 去除临时突变（主要）

**文件**：`lib/src/matrix_extension.dart:1064-1089`
**问题**：全局分支里用 `this[0][0] = condition(element, v)` 临时注入初值，若 `condition` 抛异常 `this[0][0]` 就坏了。改为显式累积。

```dart
Object reduceExtension(double Function(double, double) condition,
    {double? element, int dim = -1}) {
  var [row, column] = shape;
  if (dim == 0) {
    return List.generate(row, (r) {
      final src = this[r];
      if (src.isEmpty) {
        if (element == null) {
          throw StateError('reduce on empty row without element');
        }
        return element;
      }
      double acc = element ?? src[0];
      final start = element == null ? 1 : 0;
      for (int i = start; i < src.length; i++) acc = condition(acc, src[i]);
      return acc;
    });
  } else if (dim == 1) {
    return List.generate(column, (c) {
      double acc = element ?? this[0][c];
      final start = element == null ? 1 : 0;
      for (int r = start; r < row; r++) acc = condition(acc, this[r][c]);
      return acc;
    });
  } else {
    double? acc = element;
    for (int r = 0; r < row; r++) {
      final src = this[r];
      for (int c = 0; c < column; c++) {
        acc = acc == null ? src[c] : condition(acc, src[c]);
      }
    }
    if (acc == null) {
      throw StateError('reduce on empty matrix without element');
    }
    return acc;
  }
}
```

---

## 14. `sumExtension` 消除冗余分支（次要）

**文件**：`lib/src/matrix_extension.dart:872-880`

```dart
Object sumExtension({int dim = -1}) =>
    reduceExtension((x, y) => x + y, dim: dim);
```

---

## 15. `linspace` 的 `size==1 && keep==true` 除零（主要）

**文件**：`lib/src/matrix_extension.dart:634-646`

```dart
static List<List<double>> linspace(
    {required double start,
    required double end,
    bool keep = true,
    required int row,
    required int column}) {
  assert(row > 0 && column > 0);
  final size = row * column;
  final double step;
  if (size == 1) {
    step = 0.0;
  } else {
    step = keep ? (end - start) / (size - 1) : (end - start) / size;
  }
  int index = 0;
  return List.generate(
      row, (_) => List.generate(column, (_) => start + index++ * step));
}
```

---

## 16. `ellipse_edge` 丢参（次要）

**文件**：`lib/src/matrix_extension.dart:1421-1437`（原函数转发 `custom_curve` 时漏传 `seed` / `bias`）。

```dart
static List<List<double>> ellipse_edge({
  required double a,
  required double b,
  required int size,
  int? seed,
  double? bias,
  bool uniform = true,
  List<double> vec = OriginVector,
}) {
  return custom_curve(
    xfunc: (t) => a * math.cos(t),
    yfunc: (t) => b * math.sin(t),
    theta_from: 0,
    theta_to: 2 * math.pi,
    size: size,
    seed: seed,
    bias: bias,
    uniform: uniform,
    vec: vec,
  );
}
```

---

## 17. `multinomial` 概率和比较改用 tolerance（次要）

**文件**：`lib/src/matrix_extension.dart:2192` 左右（原 `assert(p.sum == 1)`）

```dart
// 原 assert(p.sum == 1);
assert((p.fold<double>(0.0, (s, v) => s + v) - 1.0).abs() < 1e-9,
    'multinomial: probabilities must sum to 1 (got ${p.fold<double>(0.0, (s, v) => s + v)})');
```

---

## 18. `flatten` 返回类型与命名混乱（次要）

**文件**：`lib/src/matrix_extension.dart:524-534`
**问题**：`flatten` 返回 `[[...]]`，`flattened` getter 返回 `List<double>`，两种形状并存。若不破坏 API，至少修掉 `horizontal:false` 的列主 flatten 的列/行推断错误（当 row≠column 时原写法 `index % row` / `index ~/ row` 也是错的）：

```dart
List<List<double>> flatten({bool horizontal = true}) {
  var [row, column] = shape;
  if (horizontal) {
    final out = List<double>.filled(row * column, 0.0, growable: true);
    int i = 0;
    for (int r = 0; r < row; r++) {
      final src = this[r];
      for (int c = 0; c < column; c++) out[i++] = src[c];
    }
    return [out];
  } else {
    final out = List<double>.filled(row * column, 0.0, growable: true);
    int i = 0;
    for (int c = 0; c < column; c++) {
      for (int r = 0; r < row; r++) out[i++] = this[r][c];
    }
    return [out];
  }
}
```

---

## 19. `reshape` 每 cell 两次除法改为游标（次要）

**文件**：`lib/src/matrix_extension.dart:483-494`

```dart
List<List<double>> reshape({required int row, required int column}) {
  assert(row > 0 && column > 0 && row * column == size);
  var [oRow, oCol] = shape;
  int sr = 0, sc = 0;
  final out = List.generate(row, (_) {
    return List<double>.generate(column, (_) {
      final v = this[sr][sc];
      sc++;
      if (sc == oCol) {
        sc = 0;
        sr++;
      }
      return v;
    }, growable: true);
  }, growable: true);
  return out;
}
```

---

## 20. `equalTo` 在 release 下也校验 shape（次要）

**文件**：`lib/src/matrix_extension.dart:313-323`
**问题**：原先用 `assert(hasSameShape(other))` 在 release 被剥离。直接返回 false 更合理；且对未知类型返回 false 而非抛异常，和 Dart `==` 约定一致。

```dart
bool equalTo(Object other) {
  if (identical(this, other)) return true;
  if (other is List<List<double>>) {
    if (!hasSameShape(other)) return false;
    final rows = length;
    for (int r = 0; r < rows; r++) {
      final a = this[r];
      final b = other[r];
      if (a.length != b.length) return false;
      for (int c = 0; c < a.length; c++) {
        if (a[c] != b[c]) return false;
      }
    }
    return true;
  } else if (other is num) {
    final d = other.toDouble();
    for (final row in this) {
      for (final v in row) {
        if (v != d) return false;
      }
    }
    return true;
  }
  return false;
}
```

---

## 21. `prettyPrint` 把 ANSI 色码提到每行（次要）

**文件**：`lib/src/matrix_extension.dart:243-279`
**问题**：每个 cell 前后都 `rgb / reset`。放行级即可；并把 `RegExp` 提到 `static final`。

```dart
static final RegExp _formatRegex = RegExp(r'%([0-9]+)\.([0-9]+)f');

String prettyPrint({String? format, String color = '#ffd700'}) {
  format ??= data_format;
  final rgbColor = hexToAnsi(color);
  const resetColor = '\x1B[0m';
  final match = _formatRegex.firstMatch(format);
  if (match == null) {
    throw ArgumentError("Invalid format string. Use format like '%x.yf'.");
  }
  final width = int.parse(match.group(1)!);
  final precision = int.parse(match.group(2)!);

  final rows = length;
  final cols = isEmpty ? 0 : this[0].length;

  final buffer = StringBuffer();
  buffer.writeln('[');
  for (var r = 0; r < rows; r++) {
    final src = this[r];
    buffer.write(' [');
    buffer.write(rgbColor);
    for (var c = 0; c < cols; c++) {
      buffer.write(
          src[c].toStringAsFixed(precision).padLeft(width + precision + 1));
      if (c < cols - 1) buffer.write(' ');
    }
    buffer.write(resetColor);
    buffer.write(']');
    if (r < rows - 1) buffer.writeln();
  }
  buffer.write('\n]');
  return buffer.toString();
}
```

---

## 22. 拼写错误 `conditon` → `condition`（次要，破坏性）

**文件**：`lib/src/matrix_extension.dart:1102-1108`（`allExtension` 参数名）、`lib/src/matrix_functools.dart:10`（`all` 参数名）
**问题**：公开参数名拼错。这是破坏性变更，下一个大版本再改。

```dart
// matrix_extension.dart
Object allExtension(bool Function(double) condition, {int dim = -1}) {
  if (dim == 0) {
    return List.generate(shape[0], (r) => this[r].every(condition));
  } else if (dim == 1) {
    return List.generate(shape[1], (c) => column_(c).every(condition));
  } else {
    return !List.generate(shape[0], (r) => this[r].every(condition))
        .contains(false);
  }
}
```

```dart
// matrix_functools.dart
Object all(bool Function(double) condition, {int dim = -1}) =>
    self.allExtension(condition, dim: dim);
```

---

## 23. `row_` / `column_` 防御性拷贝的使用提醒（次要）

这两个方法每次都 deep-copy。**不改方法本身**（它们在文档中就是"拷贝"语义），但请把 `minExtension/maxExtension/getRangeExtension` 的 `dim:1` 分支里原先的 `column_(c).min` 改为就地求最小：

```dart
Object minExtension({int dim = -1}) {
  var [row, column] = shape;
  if (dim == 0) {
    return List.generate(row, (r) => this[r].min);
  } else if (dim == 1) {
    return List.generate(column, (c) {
      double v = this[0][c];
      for (int r = 1; r < row; r++) {
        if (this[r][c] < v) v = this[r][c];
      }
      return v;
    });
  } else {
    double v = this[0][0];
    for (int r = 0; r < row; r++) {
      final src = this[r];
      for (int c = 0; c < column; c++) {
        if (src[c] < v) v = src[c];
      }
    }
    return v;
  }
}

Object maxExtension({int dim = -1}) {
  var [row, column] = shape;
  if (dim == 0) {
    return List.generate(row, (r) => this[r].max);
  } else if (dim == 1) {
    return List.generate(column, (c) {
      double v = this[0][c];
      for (int r = 1; r < row; r++) {
        if (this[r][c] > v) v = this[r][c];
      }
      return v;
    });
  } else {
    double v = this[0][0];
    for (int r = 0; r < row; r++) {
      final src = this[r];
      for (int c = 0; c < column; c++) {
        if (src[c] > v) v = src[c];
      }
    }
    return v;
  }
}
```

---

## 24. `RandomGenerator.Multinomial` 用二分查找（次要）

**文件**：`lib/src/unrelated_util.dart:489-509`
**问题**：每次抽样在 `cumProbs` 上线性扫 O(k)。

```dart
List<int> Multinomial(math.Random rd, {required int n, required List<double> p}) {
  final k = p.length;
  final counts = List<int>.filled(k, 0);
  final cumProbs = List<double>.filled(k, 0.0);
  cumProbs[0] = p[0];
  for (int i = 1; i < k; i++) cumProbs[i] = cumProbs[i - 1] + p[i];

  for (int i = 0; i < n; i++) {
    final u = rd.nextDouble();
    // binary search: first index whose cumProbs >= u
    int lo = 0, hi = k - 1;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (cumProbs[mid] < u) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    counts[lo]++;
  }
  return counts;
}
```

---

## 25. `choose` 的部分洗牌（次要）

**文件**：`lib/src/unrelated_util.dart:182-204`
**问题**：不放回抽样时整体 shuffle 全 m，再 `take(n)`。改为 partial Fisher–Yates。

```dart
List<T> choose<T>({
  required List<T> list,
  required int n,
  int? m,
  bool back = false,
  int? seed,
}) {
  assert(n > 0);
  assert(m == null || (m > 0 && m <= list.length));
  m ??= list.length;
  final random = math.Random(seed);

  if (back) {
    final result = <T>[];
    for (int i = 0; i < n; i++) {
      result.add(list[random.nextInt(m)]);
    }
    return result;
  }

  assert(n <= m);
  // partial Fisher-Yates on [0..m)
  final indices = List<int>.generate(m, (i) => i, growable: false);
  for (int i = 0; i < n; i++) {
    final j = i + random.nextInt(m - i);
    final tmp = indices[i];
    indices[i] = indices[j];
    indices[j] = tmp;
  }
  return [for (int i = 0; i < n; i++) list[indices[i]]];
}
```

---

## 26. `diffCentral` 中的 `h` 上限过紧（次要）

**文件**：`lib/src/unrelated_util.dart:136-159`
**问题**：自适应 h 的上限 `100 * EPSILON ≈ 1.5e-6`，但常用经验值 `h ≈ EPSILON^(1/3) ≈ 6e-6`，导致自适应基本失效。

```dart
double diffCentral(double x, double Function(double) func) {
  const double baseH = EPSILON;
  final a = List<double>.filled(4, 0.0);
  final d = List<double>.filled(4, 0.0);

  for (int i = 0; i < 4; i++) {
    a[i] = x + (i - 2.0) * baseH;
    d[i] = func(a[i]);
  }
  for (int k = 1; k < 5; k++) {
    for (int i = 0; i < 4 - k; i++) {
      d[i] = (d[i + 1] - d[i]) / (a[i + k] - a[i]);
    }
  }
  double a3 = (d[0] + d[1] + d[2] + d[3]).abs();
  if (a3 < 100.0 * EPSILON) a3 = 100.0 * EPSILON;

  // h_opt ~ (eps / a3)^(1/3), 给一个合理上限避免过大
  double h = math.pow(EPSILON / (2.0 * a3), 1.0 / 3.0) as double;
  const double hMax = 1e-4;
  if (h > hMax) h = hMax;
  if (h < baseH) h = baseH;

  return (func(x + h) - func(x - h)) / (2.0 * h);
}
```

---

## 27. `Complex.tan` 避免重复计算（次要）

**文件**：`lib/src/complex.dart:136`
**问题**：`tan = sin/cos` 触发两次 `cosh/sinh/sin/cos`。直接公式法：

```dart
Complex get tan {
  final sr = math.sin(real);
  final cr = math.cos(real);
  final shi = sinh(imaginary);
  final chi = cosh(imaginary);
  final numR = sr * chi;
  final numI = cr * shi;
  final denR = cr * chi;
  final denI = -sr * shi;
  final denom = denR * denR + denI * denI;
  return Complex(
    real: (numR * denR + numI * denI) / denom,
    imaginary: (numI * denR - numR * denI) / denom,
  );
}
```

---

## 28. `erf` 避免 `math.pow`（次要）

**文件**：`lib/src/unrelated_util.dart:559-568`

```dart
double erf(double x) {
  if (x == 0) return 0;
  if (x < 0) return -erf(-x);
  final t = 1 / (1 + 0.3275911 * x);
  final t2 = t * t;
  final t3 = t2 * t;
  final t4 = t3 * t;
  final t5 = t4 * t;
  return 1.0 -
      math.exp(-x * x) *
          (0.254829592 * t -
              0.284496736 * t2 +
              1.421413741 * t3 -
              1.453152027 * t4 +
              1.061405429 * t5);
}
```

---

## 29. `inverse` 的 tolerance 死代码清理（次要）

**文件**：原 `inverse` 内的 `detV.abs() > tolerance_round.abs()`。
**问题**：`tolerance_round` 是正数常量，`.abs()` 无意义。按 §3 的新版 `inverse` 本身已经不依赖 det，直接作废即可。

---

## 30. `_det` / `_rref` 等手写 deepcopy 统一（次要）

把所有形如 `mt_this.map((row) => row.map((e) => e).toList()).toList()` 的手写深拷贝替换为：

```dart
final matrixcpy = mt_this.deepcopy;
```

位置：`matrix_extension.dart:134-135, 165-166` 等。

---

## 使用建议

1. 先合并 §1、§2、§3、§5、§6 这 5 个严重项，运行一次现有 demo 和 `dart analyze`。
2. 再合并 §4、§7–§14 这组性能 / 正确性修复；其中 §8 改成抛异常后如果发现内部还有用错误 mode 的调用路径，这里刚好能暴露。
3. §15–§20 是小范围正确性；§21–§30 可以按需挑。
4. §22（`conditon` → `condition`）是破坏性变更，建议留到下一个 major 版本并在 CHANGELOG 中注明。

