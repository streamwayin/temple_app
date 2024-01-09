import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/constants.dart';

class YataraScreen extends StatelessWidget {
  const YataraScreen({super.key});
  static const String routeName = '/yatara-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _gap(5),
              buildCard(),
              _gap(10),
              buildCard(),
              _gap(10),
              buildCard(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _gap(int height) {
    return SizedBox(height: height.h);
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
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
}

Card buildCard() {
  var cardImage = Stack(
    children: [
      SizedBox(
        height: 200,
        width: double.infinity,
        child: Image.asset(
          "assets/images/back.jpg",
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromARGB(54, 236, 158, 80)),
      )
    ],
  );
  var supportingText =
      'Beautiful home to rent, recently refurbished with modern appliances...';
  return Card(
    color: Color.fromARGB(255, 248, 193, 148),
    elevation: 4.0,
    child: Column(
      children: [
        Container(
          color: Colors.green,
          height: 200.0,
          width: double.infinity,
          child: cardImage,
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(supportingText),
        ),
        // ButtonBar(
        //   children: [
        //     TextButton(
        //       child: const Text('CONTACT AGENT'),
        //       onPressed: () {/* ... */},
        //     ),
        //     TextButton(
        //       child: const Text('LEARN MORE'),
        //       onPressed: () {/* ... */},
        //     )
        //   ],
        // )
      ],
    ),
  );
}
