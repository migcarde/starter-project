import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.body,
    this.text,
    this.actions,
    this.leading,
    this.floatingActionButton,
  });

  final String? text;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          text ?? '',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        leading: leading,
        actions: actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  factory BaseScaffold.withBackNavigation({
    required Widget body,
    String? text,
    VoidCallback? onTapGoBack,
    List<Widget>? actions,
    FloatingActionButton? floatingActionButton,
  }) =>
      BaseScaffold(
        text: text,
        actions: actions,
        leading: Builder(
          builder: (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTapGoBack != null
                ? onTapGoBack()
                : Navigator.of(context).pop(),
            child: const Icon(Icons.chevron_left, color: Colors.black),
          ),
        ),
        body: body,
        floatingActionButton: floatingActionButton,
      );
}
