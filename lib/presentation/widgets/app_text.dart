import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool isTitle;
  final bool isHeading;
  final bool isSubtitle;
  final bool isCaption;

  const AppText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.fontSize,
        this.fontWeight,
        this.color,
        this.isTitle = false,
        this.isHeading = false,
        this.isSubtitle = false,
        this.isCaption = false,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    TextStyle defaultStyle;

    if (isHeading) {
      defaultStyle = textTheme.headlineMedium!;
    } else if (isTitle) {
      defaultStyle = textTheme.titleLarge!;
    } else if (isSubtitle) {
      defaultStyle = textTheme.titleMedium!;
    } else if (isCaption) {
      defaultStyle = textTheme.bodySmall!;
    } else {
      defaultStyle = textTheme.bodyMedium!;
    }

    return Text(
      text,
      style: (style ?? defaultStyle).copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
