import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/widgets/utils.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  static const String routeName = "/privicy-policy-screen";
  @override
  Widget build(BuildContext context) {
    double textSize1 = 20;
    double textSize2 = 15;
    double textSize = 16.0;
    return Scaffold(
      appBar: Utils.buildAppBarWithBackButton(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'Streamway, Inc (“us”, “we”, or “our”) operates the https://streamway.in website (the “Service”).',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'We will not use or share your information with anyone except as described in this Privacy Policy.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Streamway, Inc (“us”, “we”, or “our”) operates the https://streamway.in website (the “Service”).We use your Personal Information for providing and improving the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, accessible at streamway.in/resources/terms.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Information Collection And Use',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                Text(
                  'While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to, your email address, name, other information (“Personal Information”).',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'We collect this information for the purpose of providing the Service, identifying and communicating with you, responding to your requests/inquiries, servicing your purchase orders, and improving our services.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Log Data',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'We may also collect information that your browser sends whenever you visit our Service (“Log Data”). This Log Data may include information such as your computer’s Internet Protocol (“IP”) address, browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages and other statistics.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'In addition, we may use third party services such as Google Analytics that collect, monitor and analyze this type of information in order to increase our Service’s functionality. These third party service providers have their own privacy policies addressing how they use such information.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Cookies',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'Cookies are files with a small amount of data, which may include an anonymous unique identifier. Cookies are sent to your browser from a web site and transferred to your device. We use cookies to collect information in order to improve our services for you.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. The Help feature on most browsers provide information on how to accept cookies, disable cookies or to notify you when receiving a new cookie.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'If you do not accept cookies, you may not be able to use most features of our Service and we recommend that you leave them turned on.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'Do Not Track Disclosure',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w600),
                ),
                _gap(10),
                Text(
                  'We support Do Not Track (“DNT”). Do Not Track is a preference you can set in your web browser to inform websites that you do not want to be tracked.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'You can enable or disable Do Not Track by visiting the Preferences or Settings page of your web browser.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Service Providers',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'We may employ third party companies and individuals to facilitate our Service, to provide the Service on our behalf, to perform Service-related services and/or to assist us in analyzing how our Service is used.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'These third parties have access to your Personal Information only to perform specific tasks on our behalf and are obligated not to disclose or use your information for any other purpose.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Business Transaction',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'If Streamway, Inc is involved in a merger, acquisition or asset sale, your Personal Information may be transferred as a business asset. In such cases, we will provide notice before your Personal Information is transferred and/or becomes subject to a different Privacy Policy',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Security',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'The security of your Personal Information is important to us, and we strive to implement and maintain reasonable, commercially acceptable security procedures and practices appropriate to the nature of the information we store, in order to protect it from unauthorized access, destruction, use, modification, or disclosure.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'However, please be aware that no method of transmission over the internet, or method of electronic storage is 100% secure and we are unable to guarantee the absolute security of the Personal Information we have collected from you.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'International Transfer',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'Your information, including Personal Information, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'If you are located outside United States and choose to provide information to us, please note that we transfer the information, including Personal Information, to United States and process it there.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Links To Other Sites',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party’s site. We strongly advise you to review the Privacy Policy of every site you visit.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'We have no control over, and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Personal Information Collected from Connected Third Party Accounts',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'If you link Streamway to a third party account, we may collect and store certain information.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'Streamway may allow you to connect a YouTube channel to your Streamway account. In this case, we will access certain information from YouTube about your channel using YouTube API Services. We may collect channel title, channel thumbnail, username / profile ID, email, access tokens, and live broadcasts. This includes information related to your live videos (such as comments, live viewer counts, ingest address, stream name). If you decide to connect a YouTube channel to your Streamway account, see Google‘s privacy policy. When disconnecting a YouTube channel on Streamway, Streamway will delete the stored data associated with that YouTube channel. In addition, you can revoke access via Google‘s security settings page. Similiarly Streamway allows you to collect more platforms like Facebook Twitch LinkedIn and many more. In that case, we will access certain information from that Third Party‘s API services. We will only collect necessary information to help you live broadcast on those Third Party platforms and to aggrigate and show analytics combined of all platforms. If you decide to connect a Third party Social platform (e.g. Facebook), we request you to check out respective platform‘s privacy policy. When disconnecting a Third party platform (e.g. Facebook page) on Streamway, Streamway will delete the stored data associated with that respective platform. In addition, you can revoke access via respective platform‘s security settings page.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Children’s Privacy',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'Only persons age 18 or older have permission to access our Service. Our Service does not address anyone under the age of 13 (“Children”).',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you learn that your Children have provided us with Personal Information, please contact us. If we become aware that we have collected Personal Information from a child under age 13 without verification of parental consent, we take steps to remove that information from our servers.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(15),
                Text(
                  'Changes To This Privacy Policy',
                  style: TextStyle(
                      fontSize: textSize1, fontWeight: FontWeight.bold),
                ),
                _gap(10),
                Text(
                  'This Privacy Policy is effective as of Friday, July 20th, 2020 and will remain in effect except with respect to any changes in its provisions in the future, which will be in effect immediately after being posted on this page.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'We reserve the right to update or change our Privacy Policy at any time and you should check this Privacy Policy periodically. Your continued use of the Service after we post any modifications to the Privacy Policy on this page will constitute your acknowledgment of the modifications and your consent to abide and be bound by the modified Privacy Policy.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
                Text(
                  'If we make any material changes to this Privacy Policy, we will notify you either through the email address you have provided us, or by placing a prominent notice on our website.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize, fontWeight: FontWeight.w400),
                ),
                _gap(10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);
}

class PrivacyPolicygenerator extends StatelessWidget {
  final String title;
  final List list;
  const PrivacyPolicygenerator(
      {super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    double textSize1 = 20;
    double textSize2 = 15;
    return Column(
      children: [
        Text(
          '$title',
          style: TextStyle(fontSize: textSize1, fontWeight: FontWeight.bold),
        ),
        _gap(10),
        Expanded(
          child:
              ListView.builder(itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Text(
                  '${list[index]}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: textSize2, fontWeight: FontWeight.w400),
                ),
                _gap(10),
              ],
            );
          }),
        ),
        _gap(15),
      ],
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);
}
