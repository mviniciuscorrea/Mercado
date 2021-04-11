import 'package:flutter/material.dart';

loading() {
  return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: Color(0xff056162),
        )
      ]);
}
