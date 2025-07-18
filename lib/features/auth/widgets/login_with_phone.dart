import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/auth_bloc.dart';

final submitNumberKey = GlobalKey<FormState>();

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  FlCountryCodePicker countryPicker = FlCountryCodePicker();
  final _phoneNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CountryCode code =
        const CountryCode(name: 'India', code: 'IN', dialCode: '+91');
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            InkWell(
              onTap: () async {
                CountryCode? local =
                    await countryPicker.showPicker(context: context);
                // Null check
                if (local != null) {
                  // ignore: use_build_context_synchronously
                  context
                      .read<AuthBloc>()
                      .add(CountryCodeUpdatedEvent(code: local));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${state.code.name} (${state.code.dialCode})'),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Form(
              key: submitNumberKey,
              child: TextFormField(
                maxLength: 10,
                controller: _phoneNoController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return " Enter 10 digit mobile no.";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: const Icon(Icons.check),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'हम आपके नंबर की पुष्टि करने के लिए एक कोड भेजेंगे।',
              maxLines: 2,
              style: TextStyle(
                fontFamily: "KRDEV020",
              ),
            ),
            const Text(
              'We will send a code to verify your number.',
              maxLines: 2,
              style: TextStyle(
                fontFamily: "KRDEV020",
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 241, 133, 44), // background
                    foregroundColor: Colors.white, // foreground
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                onPressed: () {
                  if (submitNumberKey.currentState!.validate()) {
                    BlocProvider.of<AuthBloc>(context).add(
                      SendOtpToPhoneEvent(
                          phoneNumber:
                              '${code.dialCode}${_phoneNoController.text}'),
                    );
                    print(_phoneNoController.text);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'OTP भेजें',
                      ),
                      const Text(
                        'Send otp',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h)
          ],
        );
      },
    );
  }
}
