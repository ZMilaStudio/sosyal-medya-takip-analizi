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

  /// True when [analysis] was calculated against an older snapshot.
  /// This lets presentation distinguish "first import" from "compared but no
  /// changes" without inferring state from empty change sets.
  final bool comparedToPrevious;
}
