import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'Indikator Strategis BPS';
  static const String provinceName = 'Sulawesi Utara';
  
  // Colors
  static const Color primaryColor = Color(0xFF0C3B5E); // Prisma dark blue
  static const Color secondaryColor = Color(0xFFF97316); // Prisma orange badge
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color fabColor = Color(0xFF8B5CF6); // Purple FAB
  static const Color upTrendColor = Color(0xFF4ADE80); // Light green
  static const Color downTrendColor = Color(0xFFF87171); // Light red
  
  // API URLs
  static const String baseUrl = 'https://webapi.bps.go.id/v1/api';
  static const String indicatorsEndpoint = '/list/model/indicators';
}
