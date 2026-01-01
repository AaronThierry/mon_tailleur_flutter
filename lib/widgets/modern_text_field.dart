import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ModernTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? hintText;
  final IconData? icon;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int? maxLines;

  const ModernTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.hintText,
    this.icon,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    // Support both parameter styles for backward compatibility
    final effectiveHint = widget.hintText ?? widget.hint ?? '';
    final effectiveIcon = widget.prefixIcon ?? widget.icon;

    return AnimatedContainer(
      duration: AppTheme.fastAnimation,
      decoration: BoxDecoration(
        borderRadius: AppTheme.inputRadius,
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: effectiveHint,
            prefixIcon: effectiveIcon != null
                ? Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      effectiveIcon,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : null,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}