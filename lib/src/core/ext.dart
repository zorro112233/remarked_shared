import 'package:flutter/widgets.dart';

/// Создаем SizedBox из числа
extension SizedBoxX on num {
  /// Без адаптивности
  SizedBox get sbHeight => SizedBox(height: toDouble());

  /// Без адаптивности
  SizedBox get sbWidth => SizedBox(width: toDouble());
}
