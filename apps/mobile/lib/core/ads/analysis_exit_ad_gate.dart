import 'package:flutter/material.dart';

import 'ads_coordinator.dart';

class AnalysisExitAdGate extends StatefulWidget {
  const AnalysisExitAdGate({required this.child, super.key});

  final Widget child;

  @override
  State<AnalysisExitAdGate> createState() => _AnalysisExitAdGateState();
}

class _AnalysisExitAdGateState extends State<AnalysisExitAdGate> {
  bool _allowPop = false;
  bool _handlingExit = false;

  @override
  void initState() {
    super.initState();
    AdsCoordinator.instance.markAnalysisCompleted();
  }

  Future<void> _handleExit() async {
    if (_handlingExit) return;
    _handlingExit = true;

    await AdsCoordinator.instance.showInterstitialIfEligible();
    if (!mounted) return;

    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleExit();
      },
      child: widget.child,
    );
  }
}
