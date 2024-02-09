import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/about-us/screens/about_us_screen.dart';
import 'package:temple_app/features/contact-us/screens/contact_us_screen.dart';
import 'package:temple_app/features/my-profile/screens/privacy_policy_screen.dart';
import 'package:temple_app/features/sightseen/screens/sightseen_screen.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildAppBarNoBackButton(),
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
                  onTap: () async {
                    Share.share(
                        "https://play.google.com/store/apps/details?id=in.streamway.temple_app",
                        subject: "Check out this app ");
                  },
                  child: _buildCardButton("Share app", Icons.share)),
              _gap(10),
              InkWell(
                onTap: () {
                  FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                      name: "screen_view",
                      parameters: {"TITLE": AboutUsScreen.routeName});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUsScreen(),
                      ));
                },
                child: _buildCardButton(
                  "हमारे बारे में",
                  Icons.privacy_tip_sharp,
                ),
              ),
              _gap(10),
              InkWell(
                onTap: () {
                  FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                      name: "screen_view",
                      parameters: {"TITLE": ContactUsScreen.routeName});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactUsScreen(),
                      ));
                },
                child: _buildCardButton("संपर्क करें", Icons.help_outline),
              ),
              _gap(10),
              InkWell(
                onTap: () {
                  FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                      name: "screen_view",
                      parameters: {"TITLE": SigntseenScreen.routeName});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SigntseenScreen(),
                      ));
                },
                child: _buildCardButton("दर्शनीय स्थल", Icons.wallpaper),
              ),
              _gap(10),
              InkWell(
                onTap: () {
                  FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                      name: "screen_view",
                      parameters: {"TITLE": PrivacyPolicyScreen.routeName});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(),
                      ));
                },
                child: _buildCardButton(
                  'गोपनीयता',
                  Icons.privacy_tip_sharp,
                ),
              ),
              _gap(10),

              InkWell(
                  onTap: () async {
                    Uri link =
                        Uri.parse('https://support.streamway.in/contact/');
                    if (await canLaunchUrl(link)) {
                      launchUrl(link, mode: LaunchMode.externalApplication);
                    } else {
                      print('failed to https://support.streamway.in/contact/');
                    }
                  },
                  child: _buildCardButton("ऐप डेवलपर्स", Icons.people_alt)),
              _gap(10),
              InkWell(
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    FirebaseAuth.instance.signOut();
                    Utils.showSnackBar(
                        context: context, message: "Sucessfully logged out !!");
                    sharedPreferences.setBool(IS_USER_LOGGED_IN, false);
                  },
                  child: _buildCardButton("लॉग आउट", Icons.logout)),
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
