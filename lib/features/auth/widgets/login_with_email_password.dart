import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/custom_auth_button.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';

class LoginWithEmailPassword extends StatelessWidget {
  const LoginWithEmailPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Column(
      children: [
        SizedBox(height: 70.h),
        CustomTextField(
            isPassword: false, controller: emailController, hintText: 'email'),
        SizedBox(height: 10.h),
        CustomTextField(
            isPassword: false,
            controller: passwordController,
            hintText: 'password'),
        SizedBox(height: 20.h),
        CustomAuthButton(
          assetUrl: 'assets/images/mail.png',
          title: 'Login with mail',
          onTap: () {
            context.read<AuthBloc>().add(SignInRequested(
                emailController.text.toString(),
                passwordController.text.toString()));
          },
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
