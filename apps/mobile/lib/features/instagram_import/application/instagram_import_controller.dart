import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';

import '../../../data/local/follow_history_provider.dart';

final instagramImportControllerProvider = AsyncNotifierProvider<
    InstagramImportController, InstagramFollowAnalysisResult?>(
  InstagramImportController.new,
);

class InstagramImportController
    extends AsyncNotifier<InstagramFollowAnalysisResult?> {
  static const _useCase = InstagramFollowAnalysisUseCase();
  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9._]{1,30}$');

  @override
  FutureOr<InstagramFollowAnalysisResult?> build() => null;

  Future<InstagramFollowAnalysisResult?> pickAndAnalyze(
    String rawUsername,
  ) async {
    state = const AsyncLoading();

    try {
      final username = _normalizeUsername(rawUsername);
      final account = SocialAccount(
        platform: SocialPlatform.instagram,
        username: username,
      );
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
        throw const InstagramArchiveImportException(
          InstagramArchiveImportError.archiveTooLarge,
        );
      }

      final bytes = await file.readAsBytes();
      final database = ref.read(followHistoryDatabaseProvider);
      final previous = await database.latestSnapshot(account);
      final result = _useCase.execute(
        zipBytes: bytes,
        account: account,
        capturedAt: DateTime.now().toUtc(),
        previous: previous,
      );

      await database.saveSnapshot(result.snapshot);
      ref.invalidate(recentFollowAccountsProvider);
      state = AsyncData(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }

  String _normalizeUsername(String rawUsername) {
    final username = rawUsername.trim().replaceFirst(RegExp(r'^@'), '');
    if (!_usernamePattern.hasMatch(username)) {
      throw const FormatException(
        'Geçerli Instagram kullanıcı adını gir. Örnek: kullanici.adi',
      );
    }
    return username;
  }
}

String instagramImportErrorMessage(Object error) {
  if (error is FormatException) {
    return error.message;
  }

  if (error is InstagramArchiveImportException) {
    return switch (error.code) {
      InstagramArchiveImportError.archiveTooLarge =>
        'ZIP dosyası çok büyük. Meta’dan yalnız “Takipçiler ve takip edilenler” verisini dışa aktar.',
      InstagramArchiveImportError.invalidArchive =>
        'Seçilen dosya geçerli bir ZIP arşivi değil.',
      InstagramArchiveImportError.tooManyEntries =>
        'Arşiv beklenenden fazla dosya içeriyor. Yalnız takip verilerini dışa aktarmayı dene.',
      InstagramArchiveImportError.relationshipFileTooLarge =>
        'Takip ilişkisi dosyası güvenli işlem sınırını aşıyor.',
      InstagramArchiveImportError.followersFileMissing =>
        'Arşivde takipçiler dosyası bulunamadı.',
      InstagramArchiveImportError.followingFileMissing =>
        'Arşivde takip edilenler dosyası bulunamadı.',
      InstagramArchiveImportError.unsafeRelationshipPath =>
        'Arşivde güvenli olmayan bir dosya yolu tespit edildi.',
      InstagramArchiveImportError.invalidRelationshipFile =>
        'Instagram takip verisi okunamadı. Export biçimi değişmiş olabilir.',
    };
  }

  return 'Analiz tamamlanamadı veya cihaz geçmişine kaydedilemedi. Lütfen tekrar dene.';
}
