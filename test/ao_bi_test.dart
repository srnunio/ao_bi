import 'package:ao_bi/bi.dart';
import 'package:test/test.dart';

void main() {
  var mockData = '''EDIVALDO NÚNIO BAPTISTA MARTINS 005897844LA042 05-02-1994 MASCULINO CASADO 25/03/2023 24/03/2033 LUANDA V01 ''';

  test('validateBI', () {
    var data = BI.verify(mockData);

    expect(data != null, true);

    expect(data!.expired(), false);

    data!.toMap().forEach((key, value) {
      print("${key.toUpperCase()}: $value");
    });
  });
}
