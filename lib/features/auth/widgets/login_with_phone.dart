import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/auth_bloc.dart';

class LoginWithPhone extends StatelessWidget {
  const LoginWithPhone({super.key});

  @override
  Widget build(BuildContext context) {
    final submitNumberKey = GlobalKey<FormState>();
    const countryPicker = FlCountryCodePicker();
    final _phoneNoController = TextEditingController();
    CountryCode code =
        const CountryCode(name: 'India', code: 'IN', dialCode: '+91');
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
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
              'We will send a code to confirm your number to proceed your reservation.',
              maxLines: 2,
            ),
            SizedBox(height: 40.h),
            OutlinedButton(
              onPressed: () {
                if (submitNumberKey.currentState!.validate()) {
                  BlocProvider.of<AuthBloc>(context).add(
                    SendOtpToPhoneEvent(
                        phoneNumber:
                            '${code.dialCode}${_phoneNoController.text}'),
                  );
                }
              },
              child: const Text(
                'Send otp',
              ),
            ),
            SizedBox(height: 30.h)
          ],
        );
      },
    );
  }
}
