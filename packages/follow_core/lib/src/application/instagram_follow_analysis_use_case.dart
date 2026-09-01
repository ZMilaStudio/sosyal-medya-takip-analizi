import '../analysis/follow_analysis_engine.dart';
import '../importers/instagram/instagram_archive_importer.dart';
import '../models/follow_snapshot.dart';
import '../models/social_account.dart';
import '../models/social_platform.dart';
import 'follow_analysis_result.dart';

class InstagramFollowAnalysisResult extends FollowAnalysisResult {
  const InstagramFollowAnalysisResult({
    required super.snapshot,
    required super.analysis,
    required this.followerSourceFiles,
    required this.followingSourceFiles,
  });

  final List<String> followerSourceFiles;
  final List<String> followingSourceFiles;
}

/// End-to-end application use-case for one Instagram export analysis.
///
/// The presentation layer only needs to provide the selected ZIP bytes and
/// account metadata. Import details, snapshot construction and set analysis stay
/// outside Flutter widgets so the same flow can be reused by Android, iOS or a
/// future desktop client.
class InstagramFollowAnalysisUseCase {
  const InstagramFollowAnalysisUseCase({
    this.archiveImporter = const InstagramArchiveImporter(),
    this.analysisEngine = const FollowAnalysisEngine(),
  });

  final InstagramArchiveImporter archiveImporter;
  final FollowAnalysisEngine analysisEngine;

  InstagramFollowAnalysisResult execute({
    required List<int> zipBytes,
    required SocialAccount account,
    required DateTime capturedAt,
    FollowSnapshot? previous,
  }) {
    if (account.platform != SocialPlatform.instagram) {
      throw ArgumentError.value(
        account.platform,
        'account.platform',
        'InstagramFollowAnalysisUseCase requires an Instagram account.',
      );
    }

    final imported = archiveImporter.importBytes(zipBytes);
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: capturedAt,
      followers: imported.followers,
      following: imported.following,
      sourceType: SnapshotSourceType.archive,
      sourceFormat: _sourceFormat(
        imported.followerFiles,
        imported.followingFiles,
      ),
    );

    final analysis = analysisEngine.analyze(
      current: snapshot,
      previous: previous,
    );

    return InstagramFollowAnalysisResult(
      snapshot: snapshot,
      analysis: analysis,
      followerSourceFiles: imported.followerFiles,
      followingSourceFiles: imported.followingFiles,
    );
  }

  String _sourceFormat(
    List<String> followerFiles,
    List<String> followingFiles,
  ) {
    final paths = [...followerFiles, ...followingFiles];
    final hasJson = paths.any((path) => path.toLowerCase().endsWith('.json'));
    final hasHtml = paths.any((path) => path.toLowerCase().endsWith('.html'));

    if (hasJson && hasHtml) return 'instagram-export-mixed';
    if (hasHtml) return 'instagram-export-html';
    return 'instagram-export-json';
  }
}
