import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Utilis/theme.dart';

class TextInput extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final bool isCapsNumeric;
  final double? height;
  final double? contentPaddingV;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final bool obscureText;
  final bool margin;

  final bool isEntryField;
  final bool dropDownWithCheckBox;
  final bool isSelected;
  final bool isMistake;
  final bool isCapital;
  final bool demoCar;
  final FocusNode? focusNode;
  final int? MaxLength;
  final bool isReadOnly;
  final bool enableInteractiveSelection;
  final Color textColor;
  final Color backgroundColor;
  final TextInputType? textInputType;
  final VoidCallback? onPressed;
  final String? icon;
  final void Function(String) onTextChange;
  final Icon? sufficIcon;
  final bool? isLoading;

  final Color hintTextColor;
  final Color labelTextColor;

  const TextInput({super.key, 
    required this.label,
    required this.onTextChange,
    this.obscureText = false,
    this.dropDownWithCheckBox = false,
    this.isReadOnly = false,
    this.isCapsNumeric = false,
    this.isEntryField = true,
    this.isSelected = false,
    this.isMistake = false,
    this.isCapital = false,
    this.demoCar = false,
    this.MaxLength,
    this.margin = true,
    this.enableInteractiveSelection = true,
    this.controller,
    this.contentPaddingV,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.height,
    this.hintText,
    this.errorText,
    this.onPressed,
    this.initialValue = "",
    this.textInputType,
    this.icon,
    this.sufficIcon,
    this.focusNode,
    this.isLoading = false,
    this.textColor = AppTheme.textColor,
    this.hintTextColor = AppTheme.buttonBlack,
    this.labelTextColor = AppTheme.labelColor,
    this.backgroundColor = AppTheme.backgroundGrey,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool showPassword = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Center(
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          color: widget.backgroundColor,
          child: TextFormField(
              focusNode: widget.focusNode,
              autofocus: false,
              autocorrect: false,
              enableSuggestions: false,
              onTap: widget.onPressed,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              readOnly: widget.isReadOnly ? true : false,
              keyboardType: widget.textInputType,
              textCapitalization: widget.isCapital
                  ? TextCapitalization.characters
                  : widget.textInputType! == TextInputType.emailAddress
                      ? TextCapitalization.none
                      : TextCapitalization.words,
              minLines: widget.textInputType == TextInputType.multiline ? 3 : 1,
              maxLines: widget.textInputType == TextInputType.multiline ? 3 : 1,
              inputFormatters: widget.isCapsNumeric
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9A-Z]")),
                    ]
                  : widget.textInputType! == TextInputType.number ||
                          widget.textInputType! == TextInputType.phone
                      ? [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[;+_!@#$%^&*(),.?":{}|<> ]')),
                        ]
                      : widget.textInputType! == TextInputType.emailAddress
                          ? [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'[A-Z]')),
                              // Disallow suggestions
                            ]
                          : [
                              FilteringTextInputFormatter.deny(RegExp(r'%')),
                              // Disallow suggestions
                            ],
              maxLength: widget.MaxLength,
              onChanged: widget.onTextChange,
              controller: widget.controller,
              style: TextStyle(
                  letterSpacing: 0.2,
                  color: widget.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.label,
                counter: const Offstage(),
                suffix: widget.isLoading!
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ))
                    : null,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(
                    color: widget.controller.isNull
                        ? AppTheme.textColor
                        : widget.controller!.value.text.isEmpty
                            ? AppTheme.textColor
                            : AppTheme.labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppTheme.labelColor,
                ),
                errorText: widget.errorText,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: widget.contentPaddingV.isNull
                        ? 10.0
                        : widget.contentPaddingV!),
              )),
        ),
      ),
    );
  }
}
