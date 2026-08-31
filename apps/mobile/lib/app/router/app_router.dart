import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';

import '../../features/analysis/presentation/analysis_screen.dart';
import '../../features/home/presentation/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/analysis',
      name: 'analysis',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! InstagramFollowAnalysisResult) {
          return const HomeScreen();
        }
        return AnalysisScreen(result: extra);
      },
    ),
  ],
);
