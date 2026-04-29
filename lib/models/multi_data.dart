class MultiData {
  final String label;
  final double value;
  final String unit;

  MultiData({
    required this.label,
    required this.value,
    required this.unit,
  });

  factory MultiData.fromJson(Map<String, dynamic> json) {
    return MultiData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
