import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utlis/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = true;
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.enabled
            ? (isDark ? Colors.white.withOpacity(.06) : Colors.white.withOpacity(.7))
            : (isDark ? Colors.white.withOpacity(.035) : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isFocused
              ? AppColors.mauve
              : isDark
                  ? AppColors.mauve.withOpacity(.18)
                  : Colors.grey.shade200,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: AppColors.mauve.withOpacity(isDark ? .18 : .30),
                  blurRadius: 12,
                ),
              ]
            : [],
      ),
      child: Focus(
        onFocusChange: (val) {
          setState(() => isFocused = val);
        },
        child: TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: widget.isPassword ? obscure : false,
          keyboardType: widget.keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.darkPurple,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              fontSize: 15,
            ),
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: isDark ? AppColors.mauve : AppColors.deepPurple,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: isDark ? AppColors.mauve : AppColors.deepPurple,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}