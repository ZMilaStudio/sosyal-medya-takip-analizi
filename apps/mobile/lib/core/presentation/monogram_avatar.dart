import 'package:flutter/material.dart';

class MonogramAvatar extends StatelessWidget {
  const MonogramAvatar({
    required this.username,
    this.size = 42,
    super.key,
  });

  final String username;
  final double size;

  static const _palette = <_AvatarColors>[
    _AvatarColors(Color(0xFFEEE9FF), Color(0xFF6947E8)),
    _AvatarColors(Color(0xFFFFE6F4), Color(0xFFD92D88)),
    _AvatarColors(Color(0xFFFFEFE3), Color(0xFFD96013)),
    _AvatarColors(Color(0xFFE6F1FF), Color(0xFF246BCE)),
    _AvatarColors(Color(0xFFE3F8F4), Color(0xFF138C7A)),
    _AvatarColors(Color(0xFFFFE8EE), Color(0xFFD63762)),
    _AvatarColors(Color(0xFFF0E7FF), Color(0xFF7A3FE0)),
    _AvatarColors(Color(0xFFE4F4FF), Color(0xFF1B77B8)),
  ];

  @override
  Widget build(BuildContext context) {
    final normalized = username.trim().toLowerCase();
    final colors = _palette[_stableIndex(normalized) % _palette.length];
    final letter = normalized.isEmpty
        ? '?'
        : normalized.characters.first.toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.background,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.foreground.withAlpha(28),
        ),
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: colors.foreground,
          fontSize: size * 0.39,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  int _stableIndex(String value) {
    var hash = 17;
    for (final codeUnit in value.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return hash;
  }
}

class _AvatarColors {
  const _AvatarColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
