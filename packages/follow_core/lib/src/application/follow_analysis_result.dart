import '../models/follow_analysis.dart';
import '../models/follow_snapshot.dart';

/// Shared presentation-facing result for archive-based follow analysis.
abstract class FollowAnalysisResult {
  const FollowAnalysisResult({
    required this.snapshot,
    required this.analysis,
    this.comparedToPrevious = false,
  });

  final FollowSnapshot snapshot;
  final FollowAnalysis analysis;
  final bool comparedToPrevious;
}
