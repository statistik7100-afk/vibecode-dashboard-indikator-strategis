import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibecode_dashboard_indikator_strategis/core/constants.dart';
import 'package:vibecode_dashboard_indikator_strategis/providers/dashboard_provider.dart';
import 'package:vibecode_dashboard_indikator_strategis/providers/detail_provider.dart';
import 'package:vibecode_dashboard_indikator_strategis/ui/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DetailProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor, 
            primary: AppConstants.primaryColor,
            background: AppConstants.backgroundColor,
          ),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: AppConstants.primaryColor),
            titleTextStyle: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
