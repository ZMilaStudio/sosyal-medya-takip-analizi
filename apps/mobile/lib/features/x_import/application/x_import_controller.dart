import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';

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

    try {
      final username = _normalizeUsername(rawUsername);
      final account = SocialAccount(
        platform: SocialPlatform.x,
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
        throw const XArchiveImportException(XArchiveImportError.archiveTooLarge);
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
        'X arşivi bu sürümün cihaz içi işlem sınırını aşıyor.',
      XArchiveImportError.invalidArchive =>
        'Seçilen dosya geçerli bir X ZIP arşivi değil.',
      XArchiveImportError.tooManyEntries =>
        'X arşivi beklenenden fazla dosya içeriyor.',
      XArchiveImportError.relationshipFileTooLarge =>
        'X takip ilişkisi dosyası güvenli işlem sınırını aşıyor.',
      XArchiveImportError.followersFileMissing =>
        'Arşivde data/follower.js dosyası bulunamadı.',
      XArchiveImportError.followingFileMissing =>
        'Arşivde data/following.js dosyası bulunamadı.',
      XArchiveImportError.unsafeRelationshipPath =>
        'Arşivde güvenli olmayan bir dosya yolu tespit edildi.',
      XArchiveImportError.invalidRelationshipFile =>
        'X takip verisi okunamadı. Arşiv biçimi değişmiş olabilir.',
    };
  }

  return 'X analizi tamamlanamadı veya cihaz geçmişine kaydedilemedi.';
}
