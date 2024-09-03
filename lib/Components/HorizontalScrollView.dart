import 'package:flutter/material.dart';

class HorizontalScrollView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? margin;

  const HorizontalScrollView({super.key, required this.children, this.margin});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
     height:  height * 0.06,
      margin: margin,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      ),
    );
  }
}
