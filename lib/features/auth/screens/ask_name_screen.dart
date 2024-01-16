import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/repositories/auth_repository.dart';

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
        appBar: _buildAppBar(context),
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
                Center(
                  child: Text(
                    "अंतिम चरण",
                    style: TextStyle(
                        fontFamily: "KRDEV020",
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _gap(40),
                Text(
                  "अपना नाम दर्ज करें",
                  style: TextStyle(
                      fontFamily: "KRDEV020",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                _gap(10),
                CustomTextField(
                  isPassword: false,
                  controller: nameController,
                  hintText: "Name",
                ),
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
                    onPressed: () {
                      // User? user = FirebaseAuth.instance.currentUser;
                      authRepository
                          .addNameToUserCollection(nameController.text.trim());
                    },
                    child: SizedBox(
                      width: 150.w,
                      height: 40.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "आगे बड़े",
                            style:
                                TextStyle(fontFamily: "KRDEV020", fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _gap(30),
                _buildYaText(),
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
                      context.read<AuthBloc>().add(SignInWithgoogleEvent2(
                          user: FirebaseAuth.instance.currentUser!,
                          context: context));
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
                            style:
                                TextStyle(fontFamily: "KRDEV020", fontSize: 16),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfffeebbd),
              Color(0xfffff1e5),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close_rounded,
              size: 40,
            ))
      ],
    );
  }

  Widget _gap(int height) {
    return SizedBox(height: height.h);
  }
}
