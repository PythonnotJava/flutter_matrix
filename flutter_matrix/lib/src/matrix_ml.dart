part of 'matrix_type.dart';

/// Extension of the matrix machine learning direction.
mixin MatrixML<T extends MatrixBase<T>> on MatrixBase<T> {
  /// When the data is mapped through Softmax,
  /// the maximum value in the data will be excluded in practice, which is not considered here.
  T Softmax({int dim = -1}) => _fromList(self.Softmax(dim: dim));

  /// Map the data through LeakyReLU.
  T LeakyReLU({double alpha = 0.01}) => _fromList(self.LeakyReLU(alpha: alpha));

  /// Activation function ReLU.
  T ReLU() => _fromList(self.ReLU());

  /// Activation function, also known as S-shaped growth curve.
  T Sigmoid() => _fromList(self.Sigmoid());

  /// Activation function ELU.
  T ELU({required double alpha}) => _fromList(self.ELU(alpha: alpha));

  /// Swish is a self-gating activation function.
  T Swish() => _fromList(self.Swish());

  /// Softsign function is another alternative to Tanh function.
  T Softsign() => _fromList(self.Softsign());

  /// The Softplus function can be seen as a smoothing of the ReLU function.
  T Softplus() => _fromList(self.Softplus());

  /// Mean absolute error, which is the average of the absolute errors between the predicted and observed values.
  Object MAE({required List<List<double>> other, int dim = -1}) => self.MAE(other: other, dim: dim);

  /// MSE measures the predictive performance of the model by calculating
  /// the average of the squared errors between the predicted values and the true values.
  Object MSE({required List<List<double>> other, int dim = -1}) => self.MSE(other: other, dim: dim);
}