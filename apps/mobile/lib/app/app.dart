import 'package:flutter/material.dart';

import 'router/app_router.dart';

class SosyalMedyaTakipApp extends StatelessWidget {
  const SosyalMedyaTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Takip Analizi',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5356D8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
