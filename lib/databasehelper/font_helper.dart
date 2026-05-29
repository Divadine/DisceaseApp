import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle getFont(String fontName) {
    switch (fontName) {
      case "Poppins":
        return GoogleFonts.poppins();

      case "Roboto Serif":
        return GoogleFonts.robotoSerif();

      case "Open Sans":
        return GoogleFonts.openSans();

      case "Nunito Sans":
        return GoogleFonts.nunitoSans();

      default:
        return GoogleFonts.inter();
    }
  }
}

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final bool? softwrap;

  const AppText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
    this.softwrap,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style ??
          appTextStyle(
            color: color ?? Colors.black,
            fontWeight: fontWeight,
            fontSize: fontSize,
            textDecoration: textDecoration,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
      softWrap: softwrap,
    );
  }
}

TextStyle appTextStyle({
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
  double? height,
  TextDecoration? textDecoration,
}) {
  return TextStyle(
    fontFamily: "GothamRounded",
    color: color,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontSize: fontSize,
    height: height,
    decoration: textDecoration,
    decorationColor: color,
  );
}
