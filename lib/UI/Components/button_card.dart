import 'package:flutter/material.dart';

import '../../Core/Colors/main_colors.dart';
import '../../Core/Text Syles/text_styles.dart';

class ButtonCard extends StatelessWidget {
  final Function onTap;
  final String buttonText;
  const ButtonCard({super.key,required this.onTap,required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: MainColors.getPrimaryColor(),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(buttonText, style: MainTextStyles.getButtonTextStyle()),
      ),
    );
  }
}
