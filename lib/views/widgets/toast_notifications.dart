import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToastNotification({
  required BuildContext context,
  required ToastificationType type,
  required String title,
  ToastificationStyle style = ToastificationStyle.flat,
  Alignment alignment = Alignment.topCenter,
  Duration autoCloseDuration = const Duration(seconds: 4),
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  final toast = toastification.show(
    context: context,
    type: type,
    style: style,
    title: Text(title),
    alignment: alignment,
    autoCloseDuration: autoCloseDuration,
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
    foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
  );
  toastification.dismiss(toast);
}