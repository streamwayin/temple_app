import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/about-us/screens/about_us_screen.dart';
import 'package:temple_app/features/contact-us/screens/contact_us_screen.dart';
import 'package:temple_app/features/my-profile/screens/privacy_policy_screen.dart';
import 'package:temple_app/widgets/utils.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _gap(30),
          _buildCircularAvatar(),
          _gap(15),
          _buildDisplayText(),
          Divider(),
          _gap(15),
          Expanded(
              child: ListView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(),
                      ));
                },
                child: _buildCardButton(
                  'Privacy',
                  Icons.privacy_tip_sharp,
                ),
              ),
              _gap(10),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUsScreen(),
                      ));
                },
                child: _buildCardButton(
                  "About Us",
                  Icons.privacy_tip_sharp,
                ),
              ),
              _gap(10),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactUsScreen(),
                      ));
                },
                child: _buildCardButton("Contact Us", Icons.help_outline),
              ),
              _gap(10),
              InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Utils.showSnackBar(
                        context: context, message: "Sucessfully logged out !!");
                  },
                  child: _buildCardButton("Log Out", Icons.logout)),
              _gap(10),
              ///////////////////////////////////////////
              //////////////////////////////////////////
              // Card(
              //   color: Colors.white70,
              //   margin: const EdgeInsets.only(left: 35, right: 35, bottom: 10),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30)),
              //   child: const ListTile(
              //     leading: Icon(
              //       Icons.add_reaction_sharp,
              //       color: Colors.black54,
              //     ),
              //     title: Text(
              //       'Invite a Friend',
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //     ),
              //     trailing: Icon(
              //       Icons.arrow_forward_ios_outlined,
              //       color: Colors.black54,
              //     ),
              //   ),
              // ),
            ],
          ))
        ],
      ),
    );
  }

  Card _buildCardButton(String title, IconData iconData) {
    return Card(
      margin: const EdgeInsets.only(left: 35, right: 35, bottom: 10),
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: ListTile(
        leading: Icon(
          iconData,
          // Icons.privacy_tip_sharp,
          color: Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.black54,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 55.h,
            child: Image.asset(
              "assets/figma/shree_bada_ramdwara.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            // height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Badge(
              child: const Icon(Icons.notifications_sharp,
                  color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildCircularAvatar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Color.fromARGB(255, 255, 184, 77),
          maxRadius: 65,
          // backgroundImage: AssetImage("assets/6195145.jpg"),
        ),
      ],
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);

  Widget _buildDisplayText() {
    return FirebaseAuth.instance.currentUser == null
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FirebaseAuth.instance.currentUser!.phoneNumber != null
                  ? Text(
                      "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                    )
                  : Text(
                      "${FirebaseAuth.instance.currentUser!.displayName}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                    )
            ],
          );
  }
}
