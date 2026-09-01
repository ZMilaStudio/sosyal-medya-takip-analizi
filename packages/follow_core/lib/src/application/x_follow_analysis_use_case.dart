import '../analysis/follow_analysis_engine.dart';
import '../importers/x/x_archive_importer.dart';
import '../models/follow_snapshot.dart';
import '../models/social_account.dart';
import '../models/social_platform.dart';
import 'follow_analysis_result.dart';

class XFollowAnalysisResult extends FollowAnalysisResult {
  const XFollowAnalysisResult({
    required super.snapshot,
    required super.analysis,
    super.comparedToPrevious,
    required this.followerSourceFiles,
    required this.followingSourceFiles,
  });

  final List<String> followerSourceFiles;
  final List<String> followingSourceFiles;
}

/// End-to-end analysis for one official X archive import.
class XFollowAnalysisUseCase {
  const XFollowAnalysisUseCase({
    this.archiveImporter = const XArchiveImporter(),
    this.analysisEngine = const FollowAnalysisEngine(),
  });

  final XArchiveImporter archiveImporter;
  final FollowAnalysisEngine analysisEngine;

  XFollowAnalysisResult execute({
    required List<int> zipBytes,
    required SocialAccount account,
    required DateTime capturedAt,
    FollowSnapshot? previous,
  }) {
    _validateAccount(account);
    final imported = archiveImporter.importBytes(zipBytes);
    return _buildResult(
      imported: imported,
      account: account,
      capturedAt: capturedAt,
      previous: previous,
    );
  }

  XFollowAnalysisResult executeRelationshipFiles({
    required Map<String, List<int>> files,
    required SocialAccount account,
    required DateTime capturedAt,
    FollowSnapshot? previous,
  }) {
    _validateAccount(account);
    final imported = archiveImporter.importRelationshipFiles(files);
    return _buildResult(
      imported: imported,
      account: account,
      capturedAt: capturedAt,
      previous: previous,
    );
  }

  XFollowAnalysisResult _buildResult({
    required XArchiveImportResult imported,
    required SocialAccount account,
    required DateTime capturedAt,
    required FollowSnapshot? previous,
  }) {
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: capturedAt,
      followers: imported.followers,
      following: imported.following,
      sourceType: SnapshotSourceType.archive,
      sourceFormat: 'x-archive-js',
    );

    final analysis = analysisEngine.analyze(
      current: snapshot,
      previous: previous,
    );

    return XFollowAnalysisResult(
      snapshot: snapshot,
      analysis: analysis,
      comparedToPrevious: previous != null,
      followerSourceFiles: imported.followerFiles,
      followingSourceFiles: imported.followingFiles,
    );
  }

  void _validateAccount(SocialAccount account) {
    if (account.platform != SocialPlatform.x) {
      throw ArgumentError.value(
        account.platform,
        'account.platform',
        'XFollowAnalysisUseCase requires an X account.',
      );
    }
  }
}
