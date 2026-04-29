class SingleData {
  final double value;
  final String unit;
  final String? direction;
  final double? changeValue;
  final String? changeUnit;
  final String? changeType;
  final String? status;
  final String? description;

  SingleData({
    required this.value,
    required this.unit,
    this.direction,
    this.changeValue,
    this.changeUnit,
    this.changeType,
    this.status,
    this.description,
  });

  factory SingleData.fromJson(Map<String, dynamic> json) {
    return SingleData(
      value: (json['value'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? '',
      direction: json['direction'],
      changeValue: json['change_value'] != null ? (json['change_value']).toDouble() : null,
      changeUnit: json['change_unit'],
      changeType: json['change_type'],
      status: json['status'],
      description: json['description'],
    );
  }
}
