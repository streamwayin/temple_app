import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/login_with_phone.dart';
import 'package:temple_app/features/auth/widgets/otp_screen.dart';
import 'package:temple_app/widgets/utils.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = "auth-screen";
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: Utils.buildAppBarNoBackButton(),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthErrorState) {
          Utils.showSnackBar(context: context, message: state.errorMessagge);
        }
        if (state is PhoneAuthCodeSentSuccess) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpWidget(
                        phoneNo: state.phoneNumber,
                        verificationId: state.verificationId,
                      )));
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/figma/img_16_sign_up_screen.png",
                      ),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0)
                      .copyWith(top: 24.0),
                  child: Column(
                    children: [
                      _gap(50),
                      Text(
                        "हर सुविधा का आनंद लेना शुरू करने के लिए लॉग इन करें ।",
                        style: TextStyle(
                            fontFamily: "KRDEV020",
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      // (state is PhoneAuthCodeSentSuccess)
                      //     ?
                      // OtpWidget(
                      //     verificationId: state.verificationId,
                      //     phoneNo: state.phoneNumber)
                      // :
                      LoginWithPhone()
                    ],
                  ),
                ),
              ),
            ),
            (state.watingForOtp == true)
                ? Utils.showLoadingOnSceeen()
                : const SizedBox(),
          ],
        );
      }),
    );
  }

  SizedBox _gap(int height) {
    return SizedBox(
      height: height.h,
    );
  }
}
