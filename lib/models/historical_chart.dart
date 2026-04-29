class HistoricalData {
  final String period;
  final double value;

  HistoricalData({
    required this.period,
    required this.value,
  });

  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    return HistoricalData(
      period: json['period'] ?? '',
      value: (json['value'] ?? 0.0).toDouble(),
    );
  }
}

class IndicatorDetail {
  final String id;
  final String title;
  final String description;
  final List<HistoricalData> history;

  IndicatorDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.history,
  });

  factory IndicatorDetail.fromJson(Map<String, dynamic> json) {
    return IndicatorDetail(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      history: (json['history'] as List?)
              ?.map((e) => HistoricalData.fromJson(e))
              .toList() ??
          [],
    );
  }
}
