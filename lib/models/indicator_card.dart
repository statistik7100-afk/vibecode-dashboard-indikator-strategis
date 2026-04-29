import 'single_data.dart';
import 'multi_data.dart';

class IndicatorCard {
  final String id;
  final String category;
  final String title;
  final String type;
  final dynamic data; // Can be SingleData or List<MultiData>
  final Map<String, dynamic> period;

  IndicatorCard({
    required this.id,
    required this.category,
    required this.title,
    required this.type,
    required this.data,
    required this.period,
  });

  factory IndicatorCard.fromJson(Map<String, dynamic> json) {
    final type = json['type'] ?? 'single';
    dynamic parsedData;

    if (type == 'single') {
      parsedData = SingleData.fromJson(json['data'] ?? {});
    } else if (type == 'multi') {
      parsedData = (json['data'] as List?)
              ?.map((e) => MultiData.fromJson(e))
              .toList() ??
          [];
    }

    return IndicatorCard(
      id: json['id'] ?? '',
      category: json['category'] ?? 'Lainnya',
      title: json['title'] ?? '',
      type: type,
      data: parsedData,
      period: json['period'] ?? {},
    );
  }

  String get periodLabel {
    final label = period['label'];
    final year = period['year'];
    if (label != null && year != null) return '$label $year';
    if (year != null) return year.toString();
    return label ?? '';
  }
}
