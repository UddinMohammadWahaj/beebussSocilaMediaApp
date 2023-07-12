class StringHelper {
  String maskString(String review) {
    int length = review.length;
    String maskedString = '';
    for (int i = 0; i < length / 3; i++) {
      maskedString += review[i];
    }
    print('masked StringLength=${maskedString.length}');
    return maskedString;
  }
}
