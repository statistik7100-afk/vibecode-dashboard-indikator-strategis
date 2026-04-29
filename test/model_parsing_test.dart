import 'package:flutter_test/flutter_test.dart';
import 'package:vibecode_dashboard_indikator_strategis/models/bps_response.dart';
import 'package:vibecode_dashboard_indikator_strategis/models/single_data.dart';
import 'package:vibecode_dashboard_indikator_strategis/models/multi_data.dart';

void main() {
  group('Model Parsing Tests', () {
    test('Should parse BpsResponse with Single and Multi cards correctly', () {
      final json = {
        "meta": {
          "province": "Sulawesi Utara",
          "release_month": "Februari",
          "release_year": 2026
        },
        "cards": [
          {
            "id": "tpt",
            "category": "Ketenagakerjaan",
            "title": "Tingkat Pengangguran Terbuka (TPT)",
            "type": "single",
            "data": {"value": 5.78, "unit": "persen"},
            "period": {"label": "November", "year": 2025}
          },
          {
            "id": "ihk_inflasi",
            "category": "Harga & Inflasi",
            "title": "Inflasi",
            "type": "multi",
            "data": [
              {"label": "bulan ke bulan", "value": 0.67, "unit": "persen"},
              {"label": "tahun ke tahun", "value": 3.04, "unit": "persen"}
            ],
            "period": {"label": "Januari", "year": 2026}
          }
        ]
      };

      final response = BpsResponse.fromJson(json);

      expect(response.meta['province'], 'Sulawesi Utara');
      expect(response.cards.length, 2);

      // Test Single Card
      final tptCard = response.cards[0];
      expect(tptCard.id, 'tpt');
      expect(tptCard.type, 'single');
      expect(tptCard.data, isA<SingleData>());
      expect((tptCard.data as SingleData).value, 5.78);
      expect(tptCard.periodLabel, 'November 2025');

      // Test Multi Card
      final inflasiCard = response.cards[1];
      expect(inflasiCard.id, 'ihk_inflasi');
      expect(inflasiCard.type, 'multi');
      expect(inflasiCard.data, isA<List<MultiData>>());
      final multiData = inflasiCard.data as List<MultiData>;
      expect(multiData.length, 2);
      expect(multiData[0].label, 'bulan ke bulan');
      expect(multiData[0].value, 0.67);
    });

    test('Should handle null/missing fields gracefully', () {
      final json = {
        "cards": [
          {
            "id": "missing_data",
            "type": "single",
            "data": null,
            "period": null
          }
        ]
      };

      final response = BpsResponse.fromJson(json);
      final card = response.cards[0];

      expect(card.category, 'Lainnya'); // Default value
      expect(card.data, isA<SingleData>());
      expect((card.data as SingleData).value, 0.0); // Default value
      expect(card.periodLabel, ''); // Default value
    });

    test('Should parse trend data in SingleData correctly', () {
      final json = {
        "value": 127.89,
        "unit": "indeks",
        "direction": "up",
        "change_value": 2.14,
        "change_unit": "persen"
      };

      final data = SingleData.fromJson(json);

      expect(data.value, 127.89);
      expect(data.direction, 'up');
      expect(data.changeValue, 2.14);
      expect(data.changeUnit, 'persen');
    });
  });
}
