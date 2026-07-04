class Formatters {
  const Formatters._();

  static String formatVolume(int ml) {
    if (ml < 1000) {
      return '$ml ml';
    }

    if (ml % 1000 == 0) {
      return '${ml ~/ 1000} L';
    }

    return '${(ml / 1000).toStringAsFixed(1)} L';
  }

  static String formatAmount(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}
