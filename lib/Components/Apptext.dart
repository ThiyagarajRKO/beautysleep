import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLine;
  final EdgeInsets? margin, padding;
  final Decoration? decoration;
  final Function()? onClick;
  final Alignment? alignment;

  const AppText(this.text,
      {super.key, this.style,
      this.textAlign,
      this.overflow,
      this.maxLine,
      this.margin,
      this.decoration,
      this.alignment,
      this.onClick,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: decoration,
        alignment: alignment,
        child: Text(
          text,
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          textScaleFactor: 1,
          maxLines: maxLine,
        ),
      ),
    );
  }
}
