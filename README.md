# [ao_bi](https://pub.dev/packages/ao_bi)

Validate Angolan Identity Card

## Installation

```yaml
dependencies: 
  ao_bi: ^0.2.0 
  
  or

  ao_bi:
    git:
      url: https://github.com/srnunio/ao_bi
```

# Usage

Call the QR reader to scan the document and extract the data
```dart
void onScan() async {
  var result = await BIUtil.scan(
      title: "Scan my document", 
      context: context
  );
}
```

If you have your own QR reader and just want to process the data, simply call the ```check``` method.
```dart
void onScan() async {
  var result = await BIUtil.check("data");
}
```
To validate if a string corresponds to an Angolan ID number, simply call the ```isValid``` method.

```dart
void onCheckID() async {
  var result = BIUtil.isValidID('987654321LA009');
}
```

**BIData** is the type of return

```json
{
  "ID": "ID",
  "NAME": "NAME",
  "PROVINCE": "PROVINCE",
  "GENDER": "GENDER",
  "MARITAL_STATUS": "MARITAL_STATUS",
  "BIRTHDAY": "BIRTHDAY",
  "DATE_OF_ISSUE": "DATE_OF_ISSUE",
  "EXPIRATION_DATE": "EXPIRATION_DATE"
}
```

**NOTE:** This package uses the ```qr_code_scanner``` library, so make sure to configure the necessary permissions to grant camera access

## iOS Integration
***
In order to use this plugin, add the following to your Info.plist file:

```
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>
```

## Preview
<br>
<img title="" src="https://github.com/srnunio/bi_ao/blob/master/preview.gif" alt="" width="400">
</br>

## License

bi_ao is available under the MIT license.

# Support

You liked this package? then give it a star. If you want to help then:

* Start this repository
* Send a Pull Request with new features
* Share this package
* Create issues if you find a Bug or want to suggest something
