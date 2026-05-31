part of 'matrix_type.dart';

typedef FromListConstructor<T extends MatrixBase<T>> = T Function(
  List<List<double>> data, {
  int? known_row,
  int? known_column,
});

final _subClassFromListConstructor = <Type, FromListConstructor>{
  Matrix: Matrix.fromList,
  MatrixCollection: MatrixCollection.fromList
};

/// When any extended subclass inherits from [MatrixWrapper],
/// please register it before calling the class for the first time.
/// The value type is [FromListConstructor], which points to the constructor of the subclass.
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

/// MatrixBase is the matrix abstract base class,
/// which has built-in basic matrix operations and uses two-bit floating-point arrays for data storage.
abstract class MatrixBase<T extends MatrixBase<T>> {
  late List<List<double>> self;
  late List<int> shape;

  /// Any subclass that can be instantiated must implement this method.
  // ignore: unused_element_parameter
  T _fromList(List<List<double>> data, {int? known_row, int? known_column});

  /// Fill with specified [number].
  static T fill<T extends MatrixBase<T>>(
      {required double number, required int row, required int column}) {
    final fromList = _resolveFromList<T>();
    return fromList(
        MatrixExtension.fill(number: number, row: row, column: column),
        known_row: row,
        known_column: column);
  }

  /// Starting from [start], generate a matrix with an interval of 1.
  static T arrange<T extends MatrixBase<T>>(
      {double start = 0.0, required int row, required int column}) {
    final fromList = _resolveFromList<T>();
    return fromList(
        MatrixExtension.arrange(row: row, column: column, start: start),
        known_row: row,
        known_column: column);
  }

  /// Only data can be generated that is evenly distributed from [start] to [end].
  /// If [keep] is true, end is retained. Start is allowed to be greater than or equal to end.
  static T linspace<T extends MatrixBase<T>>(
      {required double start,
      required double end,
      bool keep = true,
      required int row,
      required int column}) {
    final fromList = _resolveFromList<T>();
    return fromList(
        MatrixExtension.linspace(
            start: start, end: end, row: row, column: column, keep: keep),
        known_row: row,
        known_column: column);
  }

  /// Deep copy a MatrixBase subclass to construct the matrix.
  static T deepCopy<T extends MatrixBase<T>>(MatrixBase other) {
    final fromList = _resolveFromList<T>();
    var [row, column] = other.shape;
    return fromList(other.self.deepcopy, known_row: row, known_column: column);
  }

  /// Broadcast multiple matrices, starting from the last dimension,
  /// each dimension is either equal or one of them is 1, otherwise the broadcast fails.
  static List<T> broadcast<T extends MatrixBase<T>>(List<T> mts) {
    final fromList = _resolveFromList<T>();
    final ls = [for (var mt in mts) mt.self];
    final bs = MatrixExtension.broadcast(ls);
    return [for (var list in bs) fromList(list)];
  }

  /// Starting from [start], generate a matrix with a step length of [step]。
  static T range<T extends MatrixBase<T>>(
      {double start = 0.0,
      double step = 1.0,
      required int row,
      required int column}) {
    final fromList = _resolveFromList<T>();
    return fromList(
        MatrixExtension.range(
            row: row, column: column, start: start, step: step),
        known_row: row,
        known_column: column);
  }

  /// Generates the n-th order identity matrix.
  static T E<T extends MatrixBase<T>>({required int n}) {
    final fromList = _resolveFromList<T>();
    return fromList(MatrixExtension.E(n: n), known_row: n, known_column: n);
  }

  /// Generates a quasi-identity matrix, depending on the minimum values in the row and column.
  static T ELike<T extends MatrixBase<T>>(
      {required int row, required int column}) {
    final fromList = _resolveFromList<T>();
    return fromList(MatrixExtension.ELike(row: row, column: column),
        known_row: row, known_column: column);
  }

  /// Align other short data according to the longest list.
  /// This method is based on the expansion of the original two-bit array, not copying and re-operating.
  /// Mode 0: Use number to supplement missing values
  /// Mode 1: Repeat the completion according to the original data of each row.
  /// For example: the longest is 10, and a row has only 4, 2, 6, then the completion is 4, 2, 6, 4, 2, 6, 4, 2, 6, 4. If the row is empty, all are covered with number.
  /// Other modes: Design rules according to func. The first parameter of func represents the current row list. Please handle the empty row situation.
  static T align<T extends MatrixBase<T>>(List<List<double>> data,
      {int mode = 0,
      double number = double.nan,
      double Function(List<double> list)? func}) {
    final fromList = _resolveFromList<T>();
    data.align(mode: mode, number: number, func: func);
    var [row, column] = data.shape;
    return fromList(data, known_row: row, known_column: column);
  }

  /// Format the output matrix.
  /// [format] is the unified format of the output data. If not, use [data_format] instead.
  /// data_format is a global variable that can be modified to control the output.
  /// [color] indicates the color of the data, which is a hexadecimal string.
  @override
  String toString({String? format, String color = '#ffd700'}) =>
      self.prettyPrint(format: format, color: color);

  /// Wraps the toString function and adds additional character printing function.
  /// Quickly view the matrix.
  void visible(
          {String? format,
          String color = '#ffd700',
          String? start_point,
          String? end_point}) =>
      self.definePrint(
          format: format,
          color: color,
          start_point: start_point,
          end_point: end_point);

  /// Get a copy of a row.
  List<double> row_(int index) => self.row_(index);

  /// Get a copy of a column.
  List<double> column_(int index) => self.column_(index);

  /// Determine whether two matrices share the same data.
  @Since('0.5.0')
  bool isShared(covariant MatrixBase other) => identical(self, other.self);

  /// Determines whether to replace nan or infinity in the matrix based on the input value.
  void setMask({double? nan_mask, double? inf_mask, double? nag_inf_mask}) =>
      self.setMask(
          nan_mask: nan_mask, inf_mask: inf_mask, nag_inf_mask: nag_inf_mask);

  /// Whether the matrix contains certain data, excluding [double.nan].
  bool contain(double element) => self.containExtension(element);

  /// Determine whether two matrices of the same type have the same data or whether the matrices are all certain data,
  /// while the `==` operator can only compare matrices of the same type
  bool equalTo(Object other) {
    if (other is MatrixBase && runtimeType == other.runtimeType) {
      return self.equalTo(other.self);
    } else if (other is num) {
      return self.equalTo(other);
    }
    throw UnsupportedError('The operation is not supported');
  }

  /// Convert a matrix to a list of different types of data.
  /// When converting to complex numbers, the matrix column must be 2.
  List<dynamic> toList(Typed type) => self.toListExtension(type);

  /// Add data to the matrix. At the beginning of the design, it was stipulated that the matrix can be increased or decreased.
  void append(List<double> data, {bool horizontal = true}) {
    self.append(data, horizontal: horizontal);
    shape = self.shape;
  }

  /// Determine whether they are of the same shape.
  bool hasSameShape(covariant MatrixBase other) =>
      shape[0] == other.shape[0] && shape[1] == other.shape[1];

  /// Data volume.
  int get size => shape[0] * shape[1];

  /// The matrix is flattened horizontally to a vector.
  List<double> get flattened => self.expand((e) => e).toList();

  /// Determine whether a matrix is a square matrix.
  bool get isSquare => shape[0] == shape[1];

  /// When two objects `==` is true, the [hashCode] must also be the same.
  /// Reference: https://api.dart.dev/dart-core/Object/hashCode.html
  @override
  int get hashCode => Object.hash(runtimeType, _deepEq.hash(self));

  /// `==` only supports data comparison of instances of the same class.
  @override
  bool operator ==(Object other) {
    if (other is MatrixBase && runtimeType == other.runtimeType) {
      return _deepEq.equals(self, other.self);
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  /// Overloading operators.
  /// - Compare data between similar matrix instances
  /// - Compare matrices and data
  bool _generalOperator(int mode, Object other) {
    if (other is MatrixBase && runtimeType == other.runtimeType) {
      return switch (mode) {
        0 => self > other.self,
        1 => self >= other.self,
        2 => self < other.self,
        3 => self <= other.self,
        _ => self >= other.self
      };
    } else if (other is num) {
      return switch (mode) {
        0 => self > other,
        1 => self >= other,
        2 => self < other,
        3 => self <= other,
        _ => self >= other
      };
    } else {
      throw UnsupportedError('The operation is not supported');
    }
  }

  bool operator >(Object other) => _generalOperator(0, other);
  bool operator >=(Object other) => _generalOperator(1, other);
  bool operator <(Object other) => _generalOperator(2, other);
  bool operator <=(Object other) => _generalOperator(3, other);

  void operator []=(int index, List<double> value) {
    var [row, column] = shape;
    assert(index >= 0 && index < row);
    self[index] = value;
  }

  List<double> operator [](int index) => this.self[index];

  void replaceRow(int index, List<double> value) {
    var [row, column] = shape;
    assert(index >= 0 && index < row);
    self[index].replaceRange(0, column, value);
  }

  T get deepcopy =>
      _fromList(self.deepcopy, known_row: shape[0], known_column: shape[1]);

  /// Concatenate two matrices.
  T concat({required T other, bool horizontal = true}) =>
      _fromList(self.concat(other: other.self, horizontal: horizontal));

  /// Reshape the matrix to ensure that the [size] of the previous and next shapes are the same.
  T reshape({required int row, required int column}) =>
      _fromList(self.reshape(row: row, column: column));

  /// Reshape the matrix. If the size becomes smaller,
  /// remove the redundant data; if the size becomes larger, use [number] to supplement it.
  T resize({required int row, required int column, double number = 0.0}) =>
      _fromList(self.resize(row: row, column: column));

  /// Flatten the matrix into a vector according to the direction.
  T flatten({bool horizontal = true}) =>
      _fromList(self.flatten(horizontal: horizontal));

  /// Slice operation, get the part from [start] to [end].
  /// If end is not set, the rest is intercepted from start.
  /// Allow start to be greater than end to perform reverse interception
  T slice({required int start, int? end, bool horizontal = true}) =>
      _fromList(self.slice(start: start, end: end, horizontal: horizontal));

  /// Select specified rows or columns to form a new matrix.
  /// The selection can be in any order.
  /// Can be repeated.
  T select({required List<int> target, bool horizontal = true}) =>
      _fromList(self.select(target: target, horizontal: horizontal));

  /// Get the matrix consisting of the remaining parts after removing some indices.
  /// The input is a [Set] of integers.
  T drop({required Set<int> target, bool horizontal = true}) =>
      _fromList(self.drop(target: target, horizontal: horizontal));

  /// Sorting matrix data.
  void sort({bool reverse = false, int dim = -1}) =>
      self.sortExtension(reverse: reverse, dim: dim);

  T _abstractOperatorAny(int mode, Object other) {
    final List<List<double>> Function(
        {int dim,
        double? number,
        List<List<double>>? other}) func = switch (mode) {
      == 0 => self.addExtension,
      == 1 => self.minusExtension,
      == 2 => self.multiplyExtension,
      == 3 => self.divideExtension,
      _ => self.addExtension
    };
    if (other is MatrixBase && runtimeType == other.runtimeType) {
      return _fromList(func(other: other.self));
    } else if (other is num) {
      return _fromList(func(number: other.toDouble()));
    } else {
      throw ArgumentError('Unsupported type: ${other.runtimeType}');
    }
  }

  T operator +(Object other) => _abstractOperatorAny(0, other);
  T operator -(Object other) => _abstractOperatorAny(1, other);
  T operator *(Object other) => _abstractOperatorAny(2, other);
  T operator /(Object other) => _abstractOperatorAny(3, other);

  /// Compare the corresponding elements of the two matrices one by one.
  /// The which is 0 for greater than, 1 for less than, 2 for greater than or equal to,
  /// 3 for less than or equal to, 4 for not equal to, and other values for equal to.
  /// Return the bool value for each comparison position, and finally form a two-dimensional Boolean array.
  List<BoolList> compare({required T other, int which = -1}) =>
      self.compareExtension(other: other.self, which: which);

  /// The matrix data is the power of number.
  T operator ^(Object other) {
    if (other is num) {
      return _fromList(self ^ other);
    }
    throw ArgumentError('Unsupported type: ${other.runtimeType}');
  }
}
