import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';

class SignupWithEmail extends StatelessWidget {
  const SignupWithEmail({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Column(
      children: [
        SizedBox(height: 30.h),
        CustomTextField(
            isPassword: false,
            controller: nameController,
            hintText: 'enter name'),
        SizedBox(height: 10.h),
        CustomTextField(
            isPassword: false, controller: emailController, hintText: 'Email'),
        SizedBox(height: 10.h),
        CustomTextField(
            isPassword: true,
            controller: passwordController,
            hintText: 'Enter password'),
        SizedBox(height: 30.h),
        OutlinedButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignUpRequested(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                  nameController.text.toString()));
            },
            child: const Text('Create account')),
        SizedBox(height: 30.h)
      ],
    );
  }
}
