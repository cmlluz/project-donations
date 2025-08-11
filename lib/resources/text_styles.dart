import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class TextStylesConstants {
  static final TextStyle kpoppinsLight = GoogleFonts.poppins(
    fontWeight: FontWeight.w300,
  );

  static final TextStyle kpoppinsRegular = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
  );

  static final TextStyle kpoppinsMedium = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
  );

  static final TextStyle kpoppinsSemiBold = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle kpoppinsBold = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle kpoppinsBlack = GoogleFonts.poppins(
    fontWeight: FontWeight.w900,
  );

  static final TextStyle kinterRegular = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
  );

  static final TextStyle kinterSemiBold = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle kinterBold = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle krobotoBold = GoogleFonts.roboto(
    fontWeight: FontWeight.w700,
    fontSize: 14.0,
  );

  static final TextStyle krobotoRegular = GoogleFonts.roboto(
    fontWeight: FontWeight.w400,
    fontSize: 18.0,
  );

  static const TextStyle kcustomButtonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle kcustomTextField = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ConstantsColors.blackShade900,
  );

  static const TextStyle kgalleryStateText = TextStyle(
    color: ConstantsColors.blackShade900,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle kformularyTitle = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );

  static final TextStyle kTitleProfile = GoogleFonts.poppins(
    fontSize: 18.0,
    color: ConstantsColors.blueShade900,
  );

  static final TextStyle kformularyText = GoogleFonts.poppins(
    fontSize: 16.0,
  );

  static const TextStyle kTitle = TextStyle(
    color: ConstantsColors.blackShade900,
    fontWeight: FontWeight.w500,
    fontSize: 24,
  );
}
