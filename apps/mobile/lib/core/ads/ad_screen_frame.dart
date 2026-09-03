import 'package:flutter/material.dart';

import 'anchored_adaptive_banner.dart';

class AdScreenFrame extends StatelessWidget {
  const AdScreenFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const AnchoredAdaptiveAdBanner(),
      ],
    );
  }
}
