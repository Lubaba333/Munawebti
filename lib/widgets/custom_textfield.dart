import 'package:flutter/material.dart';
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.enabled
            ? Colors.white.withOpacity(0.7)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isFocused
              ? AppColors.mauve
              : Colors.grey.shade200,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: AppColors.mauve.withOpacity(0.3),
                  blurRadius: 12,
                )
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
  
  // ✅ 1. تثبيت لون النص الرئيسي ليكون واضحاً على الخلفية الفاتحة
  style: const TextStyle(
    color: AppColors.darkPurple, // أو Colors.black87
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),

  decoration: InputDecoration(
    hintText: widget.hint,
    
    // ✅ 2. تحسين لون النص التوضيحي (Hint) ليكون مرئياً
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontSize: 15,
    ),
    
    prefixIcon: widget.icon != null
        ? Icon(widget.icon, color: AppColors.deepPurple)
        : null,
        
    suffixIcon: widget.isPassword
        ? IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
              color: AppColors.deepPurple,
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