import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:temple_app/features/auth/screens/ask_name_screen.dart';

import '../bloc/auth_bloc.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget(
      {Key? key, required this.verificationId, required this.phoneNo})
      : super(key: key);

  final String verificationId;
  final String phoneNo;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final GlobalKey<FormState> _otpFormKey = GlobalKey();
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.navigateToAskNameScreen != null &&
            state.navigateToAskNameScreen == true) {
          if (state.ifUserExists == true) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AskNameScreen()));
          }
        }
      },
      child: Form(
        key: _otpFormKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'A verification code has been sent to ${widget.phoneNo} ',
              ),
              SizedBox(height: 60.h),
              Pinput(
                length: 6,
                controller: codeController,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 255, 225, 225), // background
                      // foregroundColor: Colors.white, // foreground
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  onPressed: () async {
                    if (_otpFormKey.currentState!.validate()) {
                      _verifyOtp(
                          context: context,
                          otp: codeController.text.toString());
                    }
                  },
                  child: SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ओटीपी सत्यापित करें",
                          style: TextStyle(
                              fontFamily: "KRDEV020", fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOtp({required BuildContext context, required String otp}) {
    BlocProvider.of<AuthBloc>(context).add(VerifySentOtpEvent(
        otpCode: otp, verificationId: widget.verificationId));
    codeController.clear();
  }
}
