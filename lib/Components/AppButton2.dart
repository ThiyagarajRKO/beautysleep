import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton2 extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final double fontSize;
  final VoidCallback onPressed;
  final Color titleColor;
  final Color color;
  final Color borderColor;
  final FontWeight fontWeight;

  const AppButton2({super.key, 
    required this.width,
    required this.height,
    required this.title,
    required this.fontSize,
    required this.onPressed,
    required this.titleColor,
    required this.color,
    required this.borderColor,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: titleColor,
          backgroundColor: color,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
        ),
      ),
    );
  }
}
