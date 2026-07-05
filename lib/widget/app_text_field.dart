import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';
import '../core/responsive_layout/dimensions.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? label;
  final String? hint;
  final TextStyle? hintTextStyle;
  final String? helper;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final bool obscure;
  final double? radius;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final VoidCallback? onSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocus,
    this.label,
    this.hint,
    this.helper,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.radius,
    this.borderColor,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.onSubmitted,
    this.hintTextStyle,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        widget.borderColor ?? AppColors.inputBorderColor;
    final effectiveRadius = widget.radius ?? Dimensions.r(12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.inputLabel,
          ),
          SizedBox(height: Dimensions.h(8)),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          maxLines: _obscureText ? 1 : widget.maxLines,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          style: AppTextStyles.inputText,
          textInputAction:
              widget.nextFocus != null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            } else {
              if (widget.onSubmitted != null) widget.onSubmitted!();
            }
          },
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.iconInactiveColor,
                      size: Dimensions.rs(20),
                    ),
                    onPressed: _toggleObscure,
                  )
                : widget.suffixIcon,
            hintText: widget.hint,
            hintStyle: widget.hintTextStyle ?? AppTextStyles.inputHint,
            helperText: widget.helper,
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: Dimensions.pSym(h: 16, v: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
              borderSide: BorderSide(color: effectiveBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
              borderSide: BorderSide(color: effectiveBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
              borderSide: const BorderSide(
                color: AppColors.redColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
              borderSide: const BorderSide(
                color: AppColors.redColor,
                width: 1.5,
              ),
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
