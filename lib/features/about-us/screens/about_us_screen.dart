import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  static const String routeName = "/contact-us";
  @override
  Widget build(BuildContext context) {
    List<String> descriptionText = [
      'यह सन्तों की तपःस्थली है जो जोधपुर शहर से उत्तर दिशा में पहाड़ियों के बीच सूरसागर सरोवर पर स्थित है। विरक्त शाखा के प्रवत्तर्क श्री परसरामजी महाराज ने यहीं पर ईश वन्दना की थी।',
      'वि.सं. 1844 में खेड़ापा रामस्नेही सम्प्रदाय के आद्याचार्य श्री रामदासजी महाराज से दीक्षा लेकर गुरु आज्ञा से साधना हेतु भ्रमण करते हुए वि.सं. 1760 में श्री परसरामजी महाराज सूरसागर पधारे। यहां बनी छतरी में विराजमान होकर तप किया।',
      'शहर से दूर एकान्त रमणीय स्थान पर महाराजश्री के भजन के प्रभाव से धर्मप्रेमीजन दर्शन हेतु आने लगे तब छतरी के पास ही जोधपुर के शासक द्वारा एक छोटा-सा स्थान बना दिया गया जो आज श्रीबड़ारामद्वारा के नाम से प्रसिद्ध है। महाराज के शिष्य परम्परा में पांच परमहंस महात्मा क्रमशः श्री सेवगरामजी महाराज, श्री मोहब्बतरामजी महाराज श्री सुबदरामजी महाराज श्री सम्पतरामजी महाराज श्री हरसुखदासजी महाराज श्री रामबल्लभजी महाराज हुए। परमहंस परम्परा में सन्तों के जल छानने के लिए एक पत्थर का पात्र है जिसे कुण्डी कहते हैं, जो आज भी पानी छानने के काम आता है सन्तों की पावन तपःस्थली में वर्तमान में श्री मोहनदासजी महाराज विराजमान है। श्री रामप्रसादजी महाराज अभी अधिकारीजी हैं। लगभग 20 सन्त यहां स्थायी रूप से महाराजश्री के सान्निध्य में रहते हैं।',
      'प्रतिवर्ष पौष माह में यहां बरसी उत्सव का कार्यक्रम आयोजित होता है जिसमें स्थानीय व बाहर से सन्तों का आगमन अनेक स्थानों से होता है। सन्तों द्वारा प्रवचन, कथा, भजन कीर्तन का आयोजन विशेष रूप से होता है।',
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _gap(20),
              Text(
                "श्रीबड़ारामद्वारा सूरसागर जोधपुर का संक्षिप्त परिचय",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.sp, decoration: TextDecoration.underline),
              ),
              _gap(20),
              CircleAvatar(
                radius: 80.sp,
                backgroundImage:
                    const AssetImage("assets/images/babaji_image.png"),
              ),
              _gap(5),
              aboutUsText(descriptionText[0]),
              _gap(10),
              aboutUsText(descriptionText[1]),
              _gap(10),
              aboutUsText(descriptionText[2]),
              _gap(10),
              aboutUsText(descriptionText[3]),
              _gap(10),
              _gap(10),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     AboutUsSocialLogo(url: 'assets/images/youtube.png'),
              //     AboutUsSocialLogo(url: 'assets/images/instagram.png'),
              //     AboutUsSocialLogo(url: 'assets/images/facebook.png'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Text aboutUsText(String content) {
    return Text(
      textAlign: TextAlign.justify,
      content,
      style: TextStyle(fontFamily: "KRDEV020", fontSize: 16.sp),
    );
  }

  SizedBox _gap(int height) {
    return SizedBox(
      height: height.h,
    );
  }
}

class AboutUsSocialLogo extends StatelessWidget {
  const AboutUsSocialLogo({
    super.key,
    required this.url,
  });
  final String url;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(height: 40.h, child: Image.asset(url)),
    );
  }
}
