import 'package:flutter/material.dart';

loading() {
  return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Colors.amber[800],
        )
      ]);
}
