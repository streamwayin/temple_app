import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonBackgroundComponent extends StatelessWidget {
  const CommonBackgroundComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/Asset 1@4x.svg',
      semanticsLabel: 'Scaffold Background',
      fit: BoxFit.cover,
    );
  }
}
