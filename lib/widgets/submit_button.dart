// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.onPressed,
    this.text = 'Submit',
    this.padding = 0,
  });

  final VoidCallback onPressed;
  final String text;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
          child: Text(text),
        ),
      ),
    );
  }
}
