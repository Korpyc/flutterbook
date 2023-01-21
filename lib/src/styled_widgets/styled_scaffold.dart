import 'package:flutter/material.dart';

class ScaffoldWithNavPanel extends StatelessWidget {
  final Widget navPanel;
  final Widget? child;

  const ScaffoldWithNavPanel({
    required this.navPanel,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: WidgetsBinding.instance.focusManager.primaryFocus?.unfocus,
      child: Scaffold(
        body: Row(
          children: [
            navPanel,
            Expanded(
              child: Container(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
