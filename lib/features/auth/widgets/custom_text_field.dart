import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.isPassword,
    required this.controller,
    required this.hintText,
    this.fill = false,
    this.maxLines = 6,
    this.minLines = 1,
  });

  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final bool? fill;
  final int maxLines;
  final int minLines;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: (widget.isPassword) ? obscureText : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "password is required";
        } else if (value.length < 6) {
          return 'password should have at least 6 charactor';
        }
        return null;
      },
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        filled: widget.fill,
        fillColor: Colors.white,
        hintText: widget.hintText,
        isDense: true,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: (widget.isPassword)
            ? InkWell(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child:
                    Icon(obscureText ? Icons.visibility_off : Icons.visibility))
            : null,
      ),
    );
  }
}
