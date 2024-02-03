import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/repositories/auth_repository.dart';
import 'package:temple_app/widgets/utils.dart';

class AskNameScreen extends StatefulWidget {
  const AskNameScreen({super.key});

  @override
  State<AskNameScreen> createState() => _AskNameScreenState();
}

class _AskNameScreenState extends State<AskNameScreen> {
  TextEditingController nameController = TextEditingController();
  AuthRepository authRepository = AuthRepository();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoggedIn == true) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: Utils.buildAppBarNoBackButton(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/figma/img_16_sign_up_screen.png",
                ),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _gap(40),
                _gap(40),
                _buildAntimCharan(),
                _gap(40),
                _buildApnaNaamDarjKaran(),
                _gap(10),
                _buildTextField(),
                _gap(20),
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
                      await authRepository
                          .addNameToUserCollection(nameController.text.trim());
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "आगे बड़े",
                            style:
                                TextStyle(fontFamily: "KRDEV020", fontSize: 16),
                          ),
                          Text(
                            "Done",
                            style:
                                TextStyle(fontFamily: "KRDEV020", fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _gap(30),
                // _buildYaText(),
                // _gap(20),
                // _buildGoogleLoginButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomTextField _buildTextField() {
    return CustomTextField(
      isPassword: false,
      controller: nameController,
      hintText: "Name",
    );
  }

  Text _buildApnaNaamDarjKaran() {
    return Text(
      "अपना नाम दर्ज करें",
      style: TextStyle(
          fontFamily: "KRDEV020", fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Center _buildAntimCharan() {
    return Center(
      child: Text(
        "अंतिम चरण",
        style: TextStyle(
            fontFamily: "KRDEV020", fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Center _buildGoogleLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 255, 225, 225), // background
            // foregroundColor: Colors.white, // foreground
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
        onPressed: () async {
          context.read<AuthBloc>().add(SignInWithgoogleEvent2(
              user: FirebaseAuth.instance.currentUser!, context: context));
        },
        child: SizedBox(
          width: 250.w,
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10.w),
              SizedBox(
                  height: 25.h,
                  child: Image.asset(
                    "assets/images/google.png",
                    scale: 25,
                  )),
              SizedBox(width: 10.w),
              Text(
                "गूगल से भरें",
                style: TextStyle(fontFamily: "KRDEV020", fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildYaText() {
    return Center(
      child: Text(
        "या",
        style: TextStyle(
            fontFamily: "KRDEV020", fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _gap(int height) {
    return SizedBox(height: height.h);
  }
}
