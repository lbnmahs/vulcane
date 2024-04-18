import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required BuildContext context, required String label, Widget? suffixIcon
}) {
  return InputDecoration(
    label: Text(label),
    suffixIcon: suffixIcon,
    labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      fontWeight: FontWeight.w600
    ),
    floatingLabelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w600
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Theme.of(context).colorScheme.primaryContainer,
    contentPadding: const EdgeInsets.all(10.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),    
  );
}