import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';

import '../../../core/ads/ads_coordinator.dart';
import '../../../data/local/follow_history_provider.dart';

final xImportControllerProvider =
    AsyncNotifierProvider<XImportController, XFollowAnalysisResult?>(
  XImportController.new,
);

class XImportController extends AsyncNotifier<XFollowAnalysisResult?> {
  static const _useCase = XFollowAnalysisUseCase();
  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9_]{1,15}$');

  @override
  FutureOr<XFollowAnalysisResult?> build() => null;

  Future<XFollowAnalysisResult?> pickAndAnalyze(String rawUsername) async {
    state = const AsyncLoading();
    AdsCoordinator.instance.setBannerSuppressed(true);

    try {
      final account = _account(rawUsername);
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['zip'],
      );

      if (file == null) {
        state = const AsyncData(null);
        return null;
      }

      final length = await file.length();
      if (length > _useCase.archiveImporter.maxArchiveBytes) {
        throw const XArchiveImportException(XArchiveImportError.archiveTooLarge);
      }

      final bytes = await file.readAsBytes();
      final result = await _analyzeAndSave(
        account,
        (previous) => _useCase.execute(
          zipBytes: bytes,
          account: account,
          capturedAt: DateTime.now().toUtc(),
          previous: previous,
        ),
      );
      state = AsyncData(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    } finally {
      AdsCoordinator.instance.setBannerSuppressed(false);
    }
  }

  Future<XFollowAnalysisResult?> pickRelationshipFiles(
    String rawUsername,
  ) async {
    state = const AsyncLoading();
    AdsCoordinator.instance.setBannerSuppressed(true);

    try {
      final account = _account(rawUsername);
      final selected = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['js'],
      );

      if (selected.isEmpty) {
        state = const AsyncData(null);
        return null;
      }

      final files = <String, List<int>>{};
      for (final file in selected) {
        final length = await file.length();
        if (length > _useCase.archiveImporter.maxRelationshipFileBytes) {
          throw XArchiveImportException(
            XArchiveImportError.relationshipFileTooLarge,
            path: file.name,
          );
        }
        files[file.name] = await file.readAsBytes();
      }

      final result = await _analyzeAndSave(
        account,
        (previous) => _useCase.executeRelationshipFiles(
          files: files,
          account: account,
          capturedAt: DateTime.now().toUtc(),
          previous: previous,
        ),
      );
      state = AsyncData(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    } finally {
      AdsCoordinator.instance.setBannerSuppressed(false);
    }
  }

  Future<XFollowAnalysisResult> _analyzeAndSave(
    SocialAccount account,
    XFollowAnalysisResult Function(FollowSnapshot? previous) analyze,
  ) async {
    final database = ref.read(followHistoryDatabaseProvider);
    final previous = await database.latestSnapshot(account);
    final result = analyze(previous);
    await database.saveSnapshot(result.snapshot);
    ref.invalidate(recentFollowAccountsProvider);
    return result;
  }

  SocialAccount _account(String rawUsername) => SocialAccount(
        platform: SocialPlatform.x,
        username: _normalizeUsername(rawUsername),
      );

  String _normalizeUsername(String rawUsername) {
    final username = rawUsername.trim().replaceFirst(RegExp(r'^@'), '');
    if (!_usernamePattern.hasMatch(username)) {
      throw const FormatException(
        'Geçerli X kullanıcı adını gir. Örnek: kullanici_adi',
      );
    }
    return username;
  }
}

String xImportErrorMessage(Object error) {
  if (error is FormatException) return error.message;

  if (error is XArchiveImportException) {
    return switch (error.code) {
      XArchiveImportError.archiveTooLarge =>
        'X arşivi çok büyük. ZIP’i çıkarıp yalnız follower.js ve following.js dosyalarını seç.',
      XArchiveImportError.invalidArchive =>
        'Seçilen dosya geçerli bir X ZIP arşivi değil.',
      XArchiveImportError.tooManyEntries =>
        'X arşivi beklenenden fazla dosya içeriyor. Yalnız follower.js ve following.js dosyalarını seç.',
      XArchiveImportError.relationshipFileTooLarge =>
        'X takip ilişkisi dosyası güvenli işlem sınırını aşıyor.',
      XArchiveImportError.followersFileMissing =>
        'follower.js seçilmedi veya arşivde bulunamadı.',
      XArchiveImportError.followingFileMissing =>
        'following.js seçilmedi veya arşivde bulunamadı.',
      XArchiveImportError.unsafeRelationshipPath =>
        'Arşivde güvenli olmayan bir dosya yolu tespit edildi.',
      XArchiveImportError.invalidRelationshipFile =>
        'X takip verisi okunamadı. Arşiv biçimi değişmiş olabilir.',
    };
  }

  return 'X analizi tamamlanamadı veya cihaz geçmişine kaydedilemedi.';
}
