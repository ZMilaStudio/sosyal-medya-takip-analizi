import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/ads/ads_coordinator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SosyalMedyaTakipApp()));

  // Let Flutter render the first frame before any consent/ad SDK work starts.
  // Advertising is optional for app startup: if initialization fails, the
  // analysis experience must remain usable and AdsCoordinator will fail closed.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(
      Future<void>.delayed(
        const Duration(milliseconds: 750),
        AdsCoordinator.instance.initialize,
      ),
    );
  });
}
