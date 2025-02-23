import 'package:ao_bi/src/ao_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var mockData =
      '''SR NÚNIO 987654321LA009 LUANDA 31/12/1894 MASCULINO CASADO 10/10/2023 10/10/2033 LUANDA V01''';
  test('validateBIUtil', () {
    var data = BIUtil.check(mockData);

    expect(data != null, true);

    expect(data!.isExpired(), false);

    data.toMap().forEach((key, value) {
      print("${key.toUpperCase()}: $value");
    });
  });

  test('check if ID is valid', () {
    var result = BIUtil.isValidID('987654321LA009');
    expect(result, true);
  });

  test('check if ID is not valid', () {
    var result = BIUtil.isValidID('L987654321LA009');
    expect(result, false);
  });
}
