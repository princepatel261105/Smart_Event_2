import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      icon = Icons.warning;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blue;
      icon = Icons.info;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
}

enum SnackBarType { success, error, warning, info }

Future<void> showCustomDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? buttonLabel,
  VoidCallback? onConfirm,
  String? cancelButtonLabel,
  VoidCallback? onCancel,
  bool isDangerous = false,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (cancelButtonLabel != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onCancel?.call();
            },
            child: Text(cancelButtonLabel),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? Colors.red : Colors.blue.shade700,
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          child: Text(buttonLabel ?? 'OK'),
        ),
      ],
    ),
  );
}
