import 'package:flutter/material.dart';

import '../Utilis/theme.dart';
import 'Apptext.dart';

class AppTabMenu extends StatelessWidget {
  final EdgeInsets? margin, padding;
  final bool isSelected;
  final String title;
  final Function() onClick;
  final bool disable;
  final Color? color;
  final double? height;
  final TextStyle? style;

  const AppTabMenu({
    super.key,
    this.margin,
    this.padding,
    this.height,
    this.color,
    this.style,
    this.isSelected = false,
    this.title = '',
    required this.onClick,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !disable,
      child: GestureDetector(
        onTap: () => onClick(),
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin:
              margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
            gradient: color == null
                ? const LinearGradient(
                    begin: Alignment(-1.0, 0.0),
                    // Corresponds to 89.7 degrees
                    end: Alignment(1.0, 0.0),
                    // End point for the gradient
                    colors: [
                      AppTheme.appgreen, // #119A8E color
                      AppTheme.fluorescentGreen, // #119A8E color
                      // #36EC7D color
                    ],
                    stops: [0.003, 0.998], // 0.3% and 99.8% stops
                  )
                : null,
          ),
          height: height ?? 34,
          child: Center(
            child: AppText(
              title,
              maxLine: 1,
              style: style ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
