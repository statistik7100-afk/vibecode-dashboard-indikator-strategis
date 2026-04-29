import 'package:flutter/material.dart';
import '../models/bps_response.dart';
import '../models/indicator_card.dart';
import '../services/api_service.dart';

enum DataState { initial, loading, loaded, error }

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  DataState _state = DataState.initial;
  DataState get state => _state;

  BpsResponse? _data;
  BpsResponse? get data => _data;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Grouped cards by category
  Map<String, List<IndicatorCard>> get groupedCards {
    if (_data == null) return {};
    final groups = <String, List<IndicatorCard>>{};
    for (var card in _data!.cards) {
      groups.putIfAbsent(card.category, () => []).add(card);
    }
    return groups;
  }

  Future<void> fetchDashboardData() async {
    _state = DataState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _data = await _apiService.getIndicators();
      _state = DataState.loaded;
    } catch (e) {
      _state = DataState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
