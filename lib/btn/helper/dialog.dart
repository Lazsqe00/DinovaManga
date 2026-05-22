import 'package:flutter/material.dart';

Future<String?> showConfirmDialog(BuildContext context, String dispMessage) {
  return showDialog<String?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Xác nhận"),
      content: Text(dispMessage),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop("cancel"),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop("ok"),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

void showSnackBar(BuildContext context, String message, [int second = 3]) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: second),
    ),
  );

