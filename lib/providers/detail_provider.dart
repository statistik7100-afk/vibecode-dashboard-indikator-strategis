import 'package:flutter/material.dart';
import '../models/historical_chart.dart';
import '../services/api_service.dart';
import 'dashboard_provider.dart';

class DetailProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  DataState _state = DataState.initial;
  DataState get state => _state;

  IndicatorDetail? _detail;
  IndicatorDetail? get detail => _detail;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchIndicatorDetail(String id) async {
    _state = DataState.loading;
    _errorMessage = '';
    _detail = null;
    notifyListeners();

    try {
      _detail = await _apiService.getIndicatorDetail(id);
      _state = DataState.loaded;
    } catch (e) {
      _state = DataState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
