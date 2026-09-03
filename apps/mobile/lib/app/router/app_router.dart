import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';

import '../../core/ads/ad_screen_frame.dart';
import '../../core/ads/analysis_exit_ad_gate.dart';
import '../../features/about/presentation/about_privacy_screen.dart';
import '../../features/analysis/presentation/analysis_screen.dart';
import '../../features/data_management/presentation/local_data_management_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/ignored_accounts/presentation/ignored_accounts_screen.dart';
import '../../features/instagram_guide/presentation/instagram_export_guide_screen.dart';
import '../../features/x_guide/presentation/x_archive_guide_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AdScreenFrame(child: child),
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
          path: '/data-management',
          name: 'data-management',
          builder: (context, state) => const LocalDataManagementScreen(),
        ),
        GoRoute(
          path: '/about-privacy',
          name: 'about-privacy',
          builder: (context, state) => const AboutPrivacyScreen(),
        ),
        GoRoute(
          path: '/instagram-guide',
          name: 'instagram-guide',
          builder: (context, state) => const InstagramExportGuideScreen(),
        ),
        GoRoute(
          path: '/x-guide',
          name: 'x-guide',
          builder: (context, state) => const XArchiveGuideScreen(),
        ),
        GoRoute(
          path: '/analysis',
          name: 'analysis',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! FollowAnalysisResult) {
              return const HomeScreen();
            }
            return AnalysisExitAdGate(
              child: AnalysisScreen(result: extra),
            );
          },
        ),
      ],
    ),
  ],
);
