import 'package:flutter/material.dart';
import 'ao_card_dialog.dart';
import 'models.dart';

Color get _kBackgroundColor => Colors.transparent;

class BIUtil {
  BIUtil._();

  static BuildContext? _buildContext;

  /// [closeDialog] close popup if is visible
  /// You can return a value just pass it through parameter [data]
  /// ```dart
  /// var result = await BIUtil.scan(title: "Scan my B.I");
  /// ```
  static void closeDialog() async {
    final noContext = _buildContext == null;
    assert(() {
      if (noContext || !(_buildContext?.mounted ?? false)) {
        throw FlutterError('No dialog instances found');
      }
      return true;
    }());
    Navigator.pop(_buildContext!);
    _buildContext = null;
  }

  /// [scan] popup to scanner angolan identity card
  ///
  /// [title] title in app bar
  ///
  /// [cutOutSize] custom size border Qr camera
  ///
  /// [barStyle] modify the style of the Bar app
  ///
  static Future<BIData?> scan({
    required String title,
    required BuildContext context,
    BIQrStyle? barStyle,
    bool useRootNavigator = false,
    double? cutOutSize,
    bool useSafeArea = false,
  }) async {
    assert(() {
      if (_buildContext != null) {
        throw FlutterError('No more than two instances are allowed');
      }
      return true;
    }());

    return await _view(
      title: title,
      context: context,
      barStyle: barStyle ?? BIQrStyle(),
      useRootNavigator: useRootNavigator,
      cutOutSize: cutOutSize,
      useSafeArea: useSafeArea,
    );
  }

  /// [title] title in app bar
  ///
  /// [cutOutSize] custom size border Qr camera
  ///
  /// [barStyle] modify the style of the Bar app
  ///
  /// [onContext] notify a new context
  ///
  static Future<BIData?> _view({
    required String title,
    required BuildContext context,
    required BIQrStyle barStyle,
    required bool useRootNavigator,
    required double? cutOutSize,
    required bool useSafeArea,
  }) async {
    return await showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      useSafeArea: useSafeArea,
      barrierColor: Colors.transparent,
      useRootNavigator: useRootNavigator,
      builder: (newContext) {
        _buildContext = newContext;
        return BIUtil._viewDialog(
          barStyle: barStyle,
          title: title,
          cutOutSize: cutOutSize,
        );
      },
    );
  }

  /// [title] title in app bar
  ///
  /// [cutOutSize] custom size border Qr camera
  ///
  /// [barStyle] modify the style of the Bar app
  ///
  /// [onContext] notify a new context
  ///
  static Dialog _viewDialog({
    required String title,
    required BIQrStyle barStyle,
    required double? cutOutSize,
  }) {
    return Dialog(
      backgroundColor: Colors.black12,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shadowColor: Colors.black12,
      insetPadding: const EdgeInsets.all(0.0),
      surfaceTintColor: Colors.black12,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: BIQrView(
        title: title,
        barStyle: barStyle,
        cutOutSize: cutOutSize,
        onClose: () => _buildContext = null,
      ),
    );
  }

  /// [check] Validate if the data constitutes an Angolan ID card.
  /// return [BIData] nullable or not
  static BIData? check(String contentText) {
    try {
      var content = contentText.replaceAll(RegExp(r'[\r\n]+'), ' ');
      if (content.isEmpty) return null;

      // Extract name
      var resultByName = _extractTheName(content);
      // Extract ID
      var resultByID = _extractTheID(resultByName.$2);
      // Extract the birthday
      var resultByBirthday = _extractTheDate(resultByID.$2);
      // Extract the gender
      var resultByGender = _extractTheFirstGender(resultByBirthday.$2);
      // Extract the state
      var resultByMaritalStatus =
          _extractTheFirstMartialStatus(resultByGender.$2);
      // Extract date of issue
      var resultByDataOfIssue = _extractTheDate(resultByMaritalStatus.$2);
      // Extract expiration date
      var resultByExpirationDate = _extractTheDate(resultByDataOfIssue.$2);

      var province =
          resultByExpirationDate.$2.toString().replaceAll(RegExp(r' +'), ' ');

      return BIData(
        id: resultByID.$1,
        name: resultByName.$1,
        province: province,
        gender: resultByGender.$1,
        maritalStatus: resultByMaritalStatus.$1,
        birthday: resultByBirthday.$1.toDate,
        dataOfIssue: resultByDataOfIssue.$1.toDate,
        expirationDate: resultByExpirationDate.$1.toDate,
      );
    } catch (error) {
      return null;
    }
  }
}

/// [_extractTheName] Extract the name and return a tuple
/// (String? valueFound, String content)
(String?, String) _extractTheName(String content) =>
    _extract(content: content, expName: "NAME", groupId: 1);

/// [_extractTheID] Extract the ID and return a tuple
/// (String? valueFound, String content)
(String?, String) _extractTheID(String content) =>
    _extract(content: content, expName: "ID", groupId: 0);

/// [_extractTheDate] Extract the date and return a tuple
/// (String? valueFound, String content)
(String?, String) _extractTheDate(String content) =>
    _extract(content: content, expName: "DATE", groupId: 0);

/// [_extractTheFirstContent] Extract any content before a whitespace and return a tuple.
/// (String? valueFound, String content)
(String?, String) _extractTheFirstContent(String content) =>
    _extract(content: content, expName: "WHITE_SPACE", groupId: 0);

/// [_extractTheFirstContent] Extract any content before a whitespace and return a tuple.
/// (String? valueFound, String content)
(String?, String) _extractTheFirstGender(String content) =>
    _extract(content: content, expName: "GENDER", groupId: 0);

/// [_extractTheFirstMartialStatus] Extract any content before a whitespace and return a tuple.
/// (String? valueFound, String content)
(String?, String) _extractTheFirstMartialStatus(String content) =>
    _extract(content: content, expName: "MARTIAL", groupId: 0);

/// [_extract] Extract a specific value from a [$content] according
/// to the given expression and group.
/// and return a tuple
(String?, String) _extract({
  required String content,
  required String expName,
  required int groupId,
}) {
  try {
    if (content.trim().isEmpty) return (null, content);
    // Get the RegExp
    var result = _codeRegex[expName]?.firstMatch(content);
    if (result == null) return (null, content);
    // Filter results
    return _filterContent((result.group(groupId) ?? '').trim(), content);
  } catch (error) {
    print('[$error]');
    return (null, content);
  }
}

/// [_filterContent] Remove the extracted value from the original content
/// and return a tuple (String?, String) => ([$value],[$content])
(String?, String) _filterContent(String value, String content) {
  return (value.trim(), content.replaceAll(value, '').trim());
}

/// [_codeRegex] Contains the expressions for obtaining the desired values.
Map<String, RegExp> get _codeRegex {
  return {
    // Capture everything before the first number.
    "NAME": RegExp(r'^(.*?)(?=\d)'),
    // Capture the first sequence that starts with a
    // number and contains only letters and numbers.
    "ID": RegExp(r'\b\d\w*'),
    // Capture the first sequence before the first space
    "WHITE_SPACE": RegExp(r'^\S+'),
    // Capture the first sequence before the first space
    "GENDER": RegExp(r'\b[MF]\S{7,8}\b'),
    // Capture the first sequence before the first space
    "MARTIAL": RegExp(r'\b[SVC]\S{4,7}\b'),
    // Capture dates in the formats dd/mm/yyyy, dd-mm-yyyy, or yyyy-mm-dd.
    "DATE": RegExp(r'\b\d{2}[/-]\d{2}[/-]\d{4}\b|\b\d{4}-\d{2}-\d{2}\b'),
  };
}

/// [_StringEx] Extension for non-null string.
extension _StringEx on String {
  /// [toDate] Convert a string into a date.
  DateTime? get toDate {
    if (isEmpty) return null;
    var copyValue = replaceAll('-', '/');
    var split = copyValue.split('/').map((e) => e.trim()).toList();
    var valueFormatted = split.reversed.toList().join("-");
    return DateTime.tryParse(valueFormatted.trim());
  }
}

/// [_StringNullableEx] Extension for null string.
extension _StringNullableEx on String? {
  DateTime? get toDate {
    return (this ?? '').toDate;
  }
}
