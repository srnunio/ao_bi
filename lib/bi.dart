class BI {
  BI._();

  /// [verify] Extracts and formats the data corresponding to the Angolan ID
  /// return Map<String, String>?
  static BIData? verify(String data) {
    try {
      List<String> infoList = _getArray(data.trim().noBreakLine);

      if (infoList.isEmpty) return null;

      var resultByName = _extractName(infoList);
      var resultByID = _extractID(resultByName.$1);
      var resultByBirthday = _extractDate(resultByID.$1);
      var resultByDataOfIssue = _extractDate(resultByBirthday.$1);
      var resultByExpirationDate = _extractDate(resultByDataOfIssue.$1);
      var resultByGender = _extractGender(resultByExpirationDate.$1);
      var resultByState = _extractState(resultByGender.$1);
      var province = _getProvince(resultByState.$1);

      return BIData(
        id: resultByID.$2,
        name: resultByName.$2,
        province: province.$2,
        gender: resultByGender.$2,
        state: resultByState.$2,
        birthday: _parseToDate(resultByBirthday.$2),
        dataOfIssue: _parseToDate(resultByDataOfIssue.$2),
        expirationDate: _parseToDate(resultByExpirationDate.$2),
      );
    } catch (error) {
      return null;
    }
  }

  /// [extractName] extract name
  static _ResultValidation _extractName(List<String> values) {
    var copyList = values.sublist(0).toList();
    var fullName = "";
    const separator = " ";

    _ResultValidation returnValue() {
      return fullName.isEmpty
          ? (copyList, null)
          : (copyList.withOut(fullName.trim()), fullName.trim());
    }

    while (true) {
      if (copyList.isEmpty) return returnValue();

      var value = copyList[0];

      if (value.contains(RegExp('[0-9]'))) {
        return returnValue();
      } else {
        copyList.removeAt(0);
      }

      fullName = fullName.trim() + separator + value.trim();
    }
  }

  /// [_extractGender] extract gender value
  static _ResultValidation _extractGender(List<String> values) {
    var index = values.indexWhere((element) => _genders.exist(element));
    if (index < 0) return (values, null);
    var value = values[index];
    return (values.withOut(value), value);
  }

  /// [_extractState] extract state value
  static _ResultValidation _extractState(List<String> values) {
    var index = values.indexWhere((element) => _marital_status.exist(element));
    if (index < 0) return (values, null);
    var value = values[index];
    return (values.withOut(value), value);
  }

  /// [_extractDate] extract date value
  static _ResultValidation _extractDate(List<String> values) {
    var index = values.indexWhere((elem) {
      return _parseToDate(elem.trim()) != null;
    });
    if (index < 0) return (values, null);
    var value = values[index];
    return (values.withOut(value), value);
  }

  /// [_extractID] extract id value
  static _ResultValidation _extractID(List<String> values) {
    var copyList = values.sublist(0).toList();

    if (copyList.isEmpty) return (copyList, null);

    /// [validLength] check that [value] size is 14
    bool validLength(String value) => value.trim().length == 14;

    /// [firstPeaceIsNumber] check if the first nine digits are number
    bool firstPeaceIsNumber(String value) {
      var first = value.substring(0, 9);
      return first.contains(RegExp(r'^[0-9]+$'));
    }

    /// [lastPeaceIsNumber] check if the last three digits are number and two digits are string
    bool lastPeaceIsNumber(String value) {
      var last = value.substring(9, value.length);
      var reverseLast = last.split('').reversed.toList().join();
      return (last.length == 5) &&
          (last.contains(RegExp(r'^[0-9]+$'), 2)) &&
          (reverseLast.contains(RegExp(r'[a-zA-Z]'), 3));
    }

    ///[condition] checks if all conditions are satisfactory
    bool condition(String value) =>
        validLength(value) &&
        firstPeaceIsNumber(value) &&
        lastPeaceIsNumber(value) &&
        !value.contains(RegExp(r'[^\w\s]+'));

    copyList.removeWhere((value) => !condition(value.trim().toUpperCase()));

    if (copyList.isEmpty || copyList.length > 1) return (copyList, null);

    var value = copyList[0].trim();

    return (values.withOut(value), value);
  }

  /// [_getArray] ordered array of infos
  static List<String> _getArray(String data) {
    var array = data.split(" ");
    array.removeWhere((element) => element.isEmpty);
    return array;
  }

  /// [_parseToDate] parse String to DateTime
  static DateTime? _parseToDate(String? value) {
    if (value == null) return null;
    var copyValue = value.replaceAll('-', '/');
    var split = copyValue.split('/').map((e) => e.trim()).toList();
    var valueFormatted = split.reversed.toList().join("-");
    return DateTime.tryParse(valueFormatted.trim());
  }

  /// [_getProvince] extract province
  static _ResultValidation _getProvince(List<String> values) {
    if (values.isEmpty) return (values, null);

    var index = values.indexWhere((element) => _provinces.exist(element));

    if (index < 0) return (values, null);

    var value = values[index].trim();
    return (values.withOut(value), value);
  }
}

class BIData {
  final String? id;
  final String? name;
  final String? province;
  final String? gender;
  final String? state;
  final DateTime? birthdate;
  final DateTime? dateOfIssue;
  final DateTime? expirationDate;

  BIData._(
      {required this.id,
      required this.name,
      required this.province,
      required this.birthdate,
      required this.gender,
      required this.state,
      required this.dateOfIssue,
      required this.expirationDate});

  factory BIData(
          {String? id,
          String? name,
          String? province,
          DateTime? birthday,
          String? gender,
          String? state,
          DateTime? dataOfIssue,
          DateTime? expirationDate}) =>
      BIData._(
          id: id,
          name: name,
          province: province,
          birthdate: birthday,
          gender: gender,
          state: state,
          dateOfIssue: dataOfIssue,
          expirationDate: expirationDate);

  /// [expired] check if document is available
  bool expired() {
    if (dateOfIssue == null || expirationDate == null) return true;
    return DateTime.now().isAfter(expirationDate!);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "province": province,
      "gender": gender,
      "state": state,
      "birthday": birthdate?.toIso8601String(),
      "date_of_issue": dateOfIssue?.toIso8601String(),
      "expiration_date": expirationDate?.toIso8601String(),
    };
  }
}

const _provinces = <String>[
  "Bengo",
  "Benguela",
  "Bié",
  "Cabinda",
  "Cuando Cubango",
  "Cuanza Norte",
  "Cuanza Sul",
  "Cunene",
  "Huambo",
  "Huíla",
  "Luanda",
  "Lunda Norte",
  "Lunda Sul",
  "Malanje",
  "Moxico",
  "Namibe",
  "Uíge",
  "Zaire",
];

const _marital_status = <String>[
  "CASADO",
  "CASADA",
  "SOLTEIRO",
  "SOLTEIRA",
  "VIÚVO",
  "VIÚVA"
];

const _genders = <String>["MASCULINO", "FEMENINO"];

typedef _ResultValidation = (List<String> list, String? value);

extension _StringExtension on String {
  String get noBreakLine => replaceAll(RegExp(r'\n'), " ");

  bool equals(String value) {
    return trim().toLowerCase() == value.trim().toLowerCase();
  }
}

extension _ListExtension on List<String> {
  List<String> withOut(String value) {
    removeWhere((e) => e.equals(value));
    removeWhere((e) => e.isEmpty);
    return sublist(0).toList();
  }

  bool exist(String value) {
    return indexWhere((element) => element.equals(value)) >= 0;
  }
}
