import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_spacing.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    super.key,
  });

  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      validator: widget.validator,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _isObscured = !_isObscured),
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  size: AppSizes.icon,
                ),
              )
            : null,
      ),
    );
  }
}
