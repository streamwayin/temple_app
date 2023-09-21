import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.isPassword,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final bool isPassword;
  final String hintText;

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
      decoration: InputDecoration(
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
