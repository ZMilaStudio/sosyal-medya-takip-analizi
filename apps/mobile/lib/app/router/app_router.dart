import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';

import '../../features/analysis/presentation/analysis_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/ignored_accounts/presentation/ignored_accounts_screen.dart';
import '../../features/instagram_guide/presentation/instagram_export_guide_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/ignored-accounts',
      name: 'ignored-accounts',
      builder: (context, state) => const IgnoredAccountsScreen(),
    ),
    GoRoute(
      path: '/instagram-guide',
      name: 'instagram-guide',
      builder: (context, state) => const InstagramExportGuideScreen(),
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
