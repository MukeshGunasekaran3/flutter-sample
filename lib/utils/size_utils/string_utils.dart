bool validateMobile(String value) {
  String patttern = r'^[0-9]{10}$';
  print(value);
  // String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(patttern);
  if (isStringEmpty(value)) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    // if (value.length == 10) return true;
    return false;
  }
  return true;
}

bool isStringEmpty(String string) {
  return string == null || string.trim().isEmpty ? true : false;
}
