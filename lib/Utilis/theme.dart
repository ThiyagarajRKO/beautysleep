import 'package:flutter/material.dart';

class AppTheme {

  static const Color textColor = Color(0xff555555);
  static const Color primaryColor = Color(0xffffffff);
  static const Color App_color = Color(0xffffffff);
  static const Color secondaryColor = Color(0xff119a8e);
  static const Color appgreen = Color(0xff119a8e);
  static const Color fluorescentGreen = Color(0xff36ec7d);
  static const Color buttonBlack = Color(0xff333333);
  static const Color liteGreen = Color(0xff97fec5);
  static const Color backgroundGrey = Color(0xffe6e6e6);
  static const Color labelColor = Color(0x4D252525);
  static const Color labelColor50 = Color(0x80252525);
  static const Color borderShade1 = Color(0x33252525);
  static const Color labelColor90 = Color(0xE6252525);
  static const Color bottomTabsLabelInActiveColor = Color(0xff808895);
  static const Color cancelBorder = Color(0xFFD9D9D9);
  static const Color appBlack = Color(0xFF252525);
  static const Color BorderLightGrey = Color(0xffF5F5F5);
  static const Color SelectedOrange = Color(0xb3fff9f1);
  static const Color divderColor = Color(0x1A000000);
  static const Color inputBorderColor = Color(0x33252525);
  static const Color selectPointTextColor = Color(0xCC252525);
  static const Color appCyanColor = Colors.cyan;
  static const Color appRedColor =  Colors.red;
  static const Color appBlueColor = Colors.blue;
  static const Color appgreenColor = Colors.green;
  static const Color appGreyColor = Colors.grey;
  static const Color appYellowColor = Colors.yellow;
  static const Color appPurpleColor = Colors.purple;
  static const Color appOrangeColor = Colors.orange;
  static const Color appDeepPurpleColor = Colors.deepPurple;
  static const Color lableColor90 = Color(0xE6252525);
  static const Color yellow = Color(0xFFFFBE00);
  static const Color skyBlue = Color(0xFF009F9D);

}

class FormThemes {
  static const Color appTheme = Color(0xff9cb533);
  static const Color appLabelColor = Color(0xff202020);
  static const Color appHeaderColor = Color(0xff9e7d49);
  static const Widget SpaceDivider = SizedBox(height: 20.0);
  static const Color inputBorderColor = Color(0x33252525);

  static const TextStyle formHeaderStyle = TextStyle(
      fontSize: 20.0, color: Color(0xff202020), fontWeight: FontWeight.bold);

  // Textinput
  static const Color labelColor = Colors.white;
  static const BorderRadius inputBorderRadius =
  BorderRadius.all(Radius.circular(8.0));

  static const Map<String, OutlineInputBorder> inputOutlineBorder = {
    "focusedBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "disabledBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "enabledBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "errorBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "focusedErrorBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "border": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    )
  };

  static const BorderRadius inputLeftBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(10), bottomLeft: Radius.circular(10));

  static const Map<String, OutlineInputBorder> inputLeftOutlineBorder = {
    "focusedBorder": OutlineInputBorder(
      borderRadius: inputLeftBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "disabledBorder": OutlineInputBorder(
      borderRadius: inputLeftBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "enabledBorder": OutlineInputBorder(
      borderRadius: inputLeftBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "errorBorder": OutlineInputBorder(
      borderRadius: inputLeftBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "focusedErrorBorder": OutlineInputBorder(
      borderRadius: inputLeftBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "border": OutlineInputBorder(
      borderRadius: inputLeftBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    )
  };

  static const BorderRadius inputRightBorderRadius = BorderRadius.only(
      topRight: Radius.circular(10), bottomRight: Radius.circular(10));

  static const Map<String, OutlineInputBorder> customRightDropdownBorder = {
    "focusedBorder": OutlineInputBorder(
      borderRadius: inputRightBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "disabledBorder": OutlineInputBorder(
      borderRadius: inputRightBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "enabledBorder": OutlineInputBorder(
      borderRadius: inputRightBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "errorBorder": OutlineInputBorder(
      borderRadius: inputRightBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "focusedErrorBorder": OutlineInputBorder(
      borderRadius: inputRightBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    ),
    "border": OutlineInputBorder(
      borderRadius: inputRightBorderRadius,
      borderSide: BorderSide(color: inputBorderColor),
    )
  };

  // Buttons
  static WidgetStateProperty<Color> Function(Color btnBGColor) buttonBgColor =
      (btnBGColor) => WidgetStateProperty.all<Color>(btnBGColor);
  static WidgetStateProperty<Color> Function(Color btnFGColor) buttonFgColor =
      (btnFGColor) => WidgetStateProperty.all<Color>(btnFGColor);

  // Text buttons
  static WidgetStateProperty<TextStyle> Function({Color textColor})
  textButtonStyle = ({textColor = Colors.white}) =>
      WidgetStateProperty.all<TextStyle>(TextStyle(color: textColor));

  // Form input
  static const Color formLabelColor = appLabelColor;
  static const Color formInputColor = appTheme;

  // Form Radio
  static const Color formRadioSelectedColor = appTheme;
  static const Color formRadioUnSelectedColor = Color(0xffF1F6FB);
  static WidgetStateProperty<Color> formRadioSelectedLabelColor =
  WidgetStateProperty.all<Color>(Colors.white);
  static WidgetStateProperty<Color> formRadioUnSelectedLabelColor =
  WidgetStateProperty.all<Color>(appLabelColor);

  // Form Dropdown
  static const Color formDropdownBorderColor = Color(0xffF5F5F5);
  static const Map<String, OutlineInputBorder> formDropdownBorder = {
    "focusedBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: formDropdownBorderColor),
    ),
    "disabledBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: formDropdownBorderColor),
    ),
    "enabledBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: formDropdownBorderColor),
    ),
    "errorBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: formDropdownBorderColor),
    ),
    "focusedErrorBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: formDropdownBorderColor),
    ),
    "border": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: Colors.white),
    )
  };

  // Dropdown
  static const Color dropdownBorderColor = Color(0xff772D82);
  static const Map<String, OutlineInputBorder> dropdownBorder = {
    "focusedBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: dropdownBorderColor),
    ),
    "disabledBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: dropdownBorderColor),
    ),
    "enabledBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: dropdownBorderColor),
    ),
    "errorBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: dropdownBorderColor),
    ),
    "focusedErrorBorder": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: dropdownBorderColor),
    ),
    "border": OutlineInputBorder(
      borderRadius: inputBorderRadius,
      borderSide: BorderSide(color: dropdownBorderColor),
    )
  };

  // Form checkbox
  static Color checkBoxColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
      WidgetState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return const Color(0xff34C759);
    }
    return const Color(0xffD4D4D4);
  }

  // Gradient Buttons
  static const Gradient successBtnGradient = LinearGradient(
      stops: [0, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: successBtnGradientColor);
  static const List<Color> successBtnGradientColor = [
    Color(0xff34C759),
    Color(0xff00711D)
  ];

  // Danger gradient
  static const Gradient dangerBtnGradient = LinearGradient(
      stops: [0, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: dangerBtnGradientColor);
  static const List<Color> dangerBtnGradientColor = [
    Color(0xffFF3737),
    Color(0xffBE0000)
  ];

  // Stupid designer
  static const Gradient pinkBtnGradient = LinearGradient(
      stops: [0, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: pinkBtnGradientColor);
  static const List<Color> pinkBtnGradientColor = [
    Color(0xffF9468E),
    Color(0xffCB0052)
  ];

  // Stupid designer
  static const Gradient warningBtnGradient = LinearGradient(
      stops: [0, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: warningBtnGradientColor);
  static const List<Color> warningBtnGradientColor = [
    Color(0xffFCDE41),
    Color(0xffFDB107)
  ];

  static const Gradient disableBtnGradient = LinearGradient(
      stops: [0, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: disableBtnGradientColor);
  static const List<Color> disableBtnGradientColor = [
    Color(0xffB0B3C4),
    Color(0xff808895)
  ];
}


