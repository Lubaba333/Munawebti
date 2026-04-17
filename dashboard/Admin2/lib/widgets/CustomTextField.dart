import 'package:flutter/material.dart';
import 'AppColors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final double fontSize;
  final double paddingVertical;

  // ✅ أضفنا هذا
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.fontSize = 14,
    this.paddingVertical = 14,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() => isFocused = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused ? Colors.deepPurple : Colors.grey.shade300,
          ),
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.deepPurple)
                : null,

            // ✅ أضف هذا السطر هنا ليتم عرض الأيقونة المرسلة من الخارج
            suffixIcon: widget.suffixIcon,

            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.paddingVertical,
            ),
          ),
        ),
      ),
    );
  }
}