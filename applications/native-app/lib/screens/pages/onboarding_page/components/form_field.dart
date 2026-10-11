import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/app_theme.dart';

/// 入力欄の上に出す小さな見出し。
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: context.appColors.textSecondary,
      ),
    );
  }
}

/// 1行の入力欄。見た目はテーマの InputDecoration に任せる。
class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.autofocus = false,
    this.autofillHints,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
    this.errorText,
    this.style = const TextStyle(fontSize: 16),
  });

  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autocorrect: !obscureText,
      enableSuggestions: !obscureText,
      autofocus: autofocus,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      onSubmitted: onSubmitted,
      style: style,
      decoration: InputDecoration(hintText: hintText, errorText: errorText),
    );
  }
}
