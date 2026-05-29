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
