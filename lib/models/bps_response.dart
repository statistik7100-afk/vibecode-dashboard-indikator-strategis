import 'indicator_card.dart';

class BpsResponse {
  final Map<String, dynamic> meta;
  final List<IndicatorCard> cards;

  BpsResponse({
    required this.meta,
    required this.cards,
  });

  factory BpsResponse.fromJson(Map<String, dynamic> json) {
    return BpsResponse(
      meta: json['meta'] ?? {},
      cards: (json['cards'] as List?)
              ?.map((e) => IndicatorCard.fromJson(e))
              .toList() ??
          [],
    );
  }
}
