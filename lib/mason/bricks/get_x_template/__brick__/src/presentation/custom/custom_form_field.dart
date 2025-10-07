import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/utils/screen_utils.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? label;
  final Widget? icon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final int? maxLines;
  final InputDecoration? decoration;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const CustomFormField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.validator,
    this.onSaved,
    this.icon,
    this.suffixIcon,
    this.border,
    this.maxLines,
    this.decoration,
    this.onChanged,
    this.initialValue,
    this.backgroundColor = ColorManager.titleColor,
    this.textColor = ColorManager.bodyColor,
    this.fontSize = 14,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle hintStyle = TextStyle(color: ColorManager.bodyColor, fontWeight: FontWeight.w400, fontSize: ScreenUtils.getFontSize(context, fontSize));
    TextStyle textStyle = TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: ScreenUtils.getFontSize(context, fontSize));
    InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: backgroundColor),
    );
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: textStyle,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: decoration ??
          InputDecoration(
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.all(12.0),
            hintText: hint?.tr,
            labelText: label?.tr,
            prefixIcon: icon,
            suffixIcon: suffixIcon,
            border: border ?? inputBorder,
            enabledBorder: border ?? inputBorder,
            labelStyle: textStyle,
            hintStyle: hintStyle,
          ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? label;
  final Widget? icon;
  final InputBorder? border;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final int? maxLines;
  final InputDecoration? decoration;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const PasswordFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.label,
    this.icon,
    this.border,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.maxLines = 1,
    this.decoration,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool secure = true;

  @override
  Widget build(BuildContext context) {
    BorderSide borderSide = const BorderSide(color: ColorManager.titleColor, width: 1);
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: borderSide,
    );
    TextStyle hintStyle = TextStyle(color: ColorManager.bodyColor, fontWeight: FontWeight.w400, fontSize: ScreenUtils.getFontSize(context, 12));
    TextStyle textStyle = TextStyle(color: ColorManager.bodyColor, fontWeight: FontWeight.w700, fontSize: ScreenUtils.getFontSize(context, 12));
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        initialValue: widget.initialValue,
        controller: widget.controller,
        enabled: widget.enabled,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator,
        maxLines: widget.maxLines,
        style: textStyle,
        obscureText: secure,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        decoration: widget.decoration ??
            InputDecoration(
              filled: true,
              fillColor: ColorManager.titleColor,
              hintText: widget.hint?.tr,
              labelText: widget.label?.tr,
              hintStyle: hintStyle,
              labelStyle: textStyle,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              icon: widget.icon,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    secure = !secure;
                  });
                },
                child: Icon(
                  secure ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                ),
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(borderSide: borderSide.copyWith(color: ColorManager.primaryColor)),
              errorMaxLines: 2,
            ),
      ),
    );
  }
}
