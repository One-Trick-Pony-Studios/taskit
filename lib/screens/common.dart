import 'package:flutter/material.dart';

class TaskItHeader extends StatelessWidget {
  final bool showTitle;

  const TaskItHeader({super.key, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/app_icon.png',
              width: 100,
              height: 100,
              semanticLabel: 'TaskIt logo',
            ),
            if (showTitle) ...[
              const SizedBox(height: 16),
              const Text(
                'TaskIt',
                style: TextStyle(
                  fontFamily: 'RhodiumLibre',
                  fontSize: 40,
                  height: 18 / 40,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
