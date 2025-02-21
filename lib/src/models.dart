import 'package:flutter/material.dart';

class BIData {
  final String? id;
  final String? name;
  final String? province;
  final String? gender;
  final String? maritalStatus;
  final DateTime? birthdate;
  final DateTime? dateOfIssue;
  final DateTime? expirationDate;

  BIData._({
    required this.id,
    required this.name,
    required this.province,
    required this.birthdate,
    required this.gender,
    required this.maritalStatus,
    required this.dateOfIssue,
    required this.expirationDate,
  });

  factory BIData({
    String? id,
    String? name,
    String? province,
    DateTime? birthday,
    String? gender,
    String? maritalStatus,
    DateTime? dataOfIssue,
    DateTime? expirationDate,
  }) {
    return BIData._(
      id: id,
      name: name,
      province: province,
      birthdate: birthday,
      gender: gender,
      maritalStatus: maritalStatus,
      dateOfIssue: dataOfIssue,
      expirationDate: expirationDate,
    );
  }

  /// [isExpired] check if document is available
  /// return true or false
  bool isExpired() {
    if (dateOfIssue == null || expirationDate == null) return true;
    return DateTime.now().isAfter(expirationDate!);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "province": province,
      "gender": gender,
      "marital_status": maritalStatus,
      "birthday": birthdate?.toIso8601String(),
      "date_of_issue": dateOfIssue?.toIso8601String(),
      "expiration_date": expirationDate?.toIso8601String(),
    };
  }
}

class BIQrStyle {
  /// [appBarBackgroundColor] color the app bar
  final Color appBarBackgroundColor;

  /// [overlayColor] color the background overlay
  final Color overlayColor;

  /// [borderColor] color border Qr
  final Color borderColor;

  /// [accentColor] color accentColor
  final Color accentColor;

  /// [labelStyle] modify style of text in app bar
  final TextStyle? labelStyle;

  BIQrStyle({
    this.appBarBackgroundColor = Colors.white,
    this.overlayColor = Colors.black87,
    this.borderColor = Colors.red,
    this.accentColor = Colors.black,
    this.labelStyle,
  });

  BIQrStyle copyWith({
    TextStyle? labelStyle,
    Color? appBarBackgroundColor,
    Color? overlayColor,
    Color? borderColor,
    Color? accentColor,
  }) {
    return BIQrStyle(
      labelStyle: labelStyle ?? this.labelStyle,
      appBarBackgroundColor:
          appBarBackgroundColor ?? this.appBarBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      overlayColor: overlayColor ?? this.overlayColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
