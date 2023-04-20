import 'package:flutter/material.dart';

import 'app_colors.dart';

InputDecoration appInputDecoration = InputDecoration(
  hintStyle: const TextStyle(fontSize: 14),
  contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.0),
    borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.0),
    borderSide: const BorderSide(width: 1, color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.0),
    borderSide: const BorderSide(width: 1, color: Colors.red),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.0),
    borderSide: BorderSide(width: 1, color: AppColors.primary),
  ),
);
