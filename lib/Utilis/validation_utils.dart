class ValidationUtils {
  static bool isNullEmptyOrFalse(String? o) =>
      o == null || false == o || "" == o;

  static bool isNullEmptyFalseOrZero(Object? o) =>
      o == null || false == o || 0 == o || "" == o;

  static bool isSuccessResponse(int statusCode) =>
      statusCode > 199 && statusCode < 300;

  static bool isEmail(String email) {
    String passwordValidationRule =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(passwordValidationRule);
    return regExp.hasMatch(email);
  }

  static bool isValidString(String? value) {
    return (value != null && value.trim().isNotEmpty);
  }

  static String? pinValidation(String value) {
    if (value.isEmpty) {
      return "PIN cannot be blank";
    } else if (value.trim().length != 6) {
      return "PIN should be 6 digits";
    } else if (ValidationUtils.isNumeric(value.trim())) {
      return null;
    } else {
      return "Please enter valid pin";
    }
  }

  static String? passwordValidation(String value) {
    if (value.isEmpty) {
      return "Password cannot be blank";
    } else if (value.trim().length < 6) {
      return "PIN should be above 6 digits";
    } else {
      return null;
    }
  }

  static bool isNumeric(String value) {
    String nameValidationRule = "[0-9]";
    RegExp regExp = RegExp(nameValidationRule);
    return regExp.hasMatch(value);
  }

  static bool isValid(String value, String regex) {
    if (value.isNotEmpty) {
      //print("regex $regex");
      RegExp regExp = RegExp(regex);
      return regExp.hasMatch(value);
    } else {
      return false;
    }
  }
}
