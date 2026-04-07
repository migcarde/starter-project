import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void showSnackBar({
    required String message,
    required Color backgroundColor,
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
}
