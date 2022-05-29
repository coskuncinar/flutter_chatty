import 'package:flutter/material.dart';

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Color(0xffBB86FC),
  secondary: Color(0xff03DAC6),
  surface: Color(0xff181818),
  background: Color(0xff121212),
  error: Color(0xffCF6679),
  onPrimary: Color(0xff000000),
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffffffff),
  onBackground: Color(0xffffffff),
  onError: Color(0xff000000),
  brightness: Brightness.dark,
);

class AppColors {
  static const kBlueColor = Color(0xFF3C82FF);
  static const kBlackColor = Color(0xFF000000);
  static const kwhiteColor = Color(0xFFFFFFFF);
  static const kDarkblack = Color(0xFF8B959A);
}

// custom text widget
Widget customText({required String txt, required TextStyle style}) {
  return Text(
    txt,
    style: style,
  );
}

// inkwell buttons pic
Widget inkwellButtons({
  required Image image,
}) {
  return Expanded(
    child: SizedBox(
      width: 170,
      height: 60,
      child: image,
    ),
  );
}

// sign up button
Widget signUpContainer({required String st}) {
  return Container(
    width: double.infinity,
    height: 60,
    decoration: BoxDecoration(
      color: AppColors.kBlueColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: customText(
          txt: st,
          style: const TextStyle(
            color: AppColors.kwhiteColor,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          )),
    ),
  );
}

// rich text
TextSpan richTextSpan({required String one, required String two}) {
  return TextSpan(children: [
    TextSpan(text: one, style: const TextStyle(fontSize: 13, color: AppColors.kBlackColor)),
    TextSpan(
        text: two,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.kBlueColor,
        )),
  ]);
}

// TextField
Widget customTextField({required String lone, required String htwo}) {
  return TextField(
    decoration: InputDecoration(
        labelText: lone,
        hintText: htwo,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(
          width: 5,
          color: AppColors.kDarkblack,
          style: BorderStyle.solid,
        ))),
    autofocus: true,
    keyboardType: TextInputType.multiline,
  );
}
