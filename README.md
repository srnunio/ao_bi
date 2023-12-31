# [ao_bi](https://pub.dev/packages/ao_bi)

Validate Angolan Identity Card

## Installation

```yaml
dependencies:
  ao_bi: ^0.0.1

  or

  ao_bi:
    git:
      url: https://github.com/srnunio/ao_bi
```

# Usage

```dart
void main() {
  BI.verify(string);
}
```
**BIData** is the type of return

```json
{
    "id": "105000733BA101",
    "name": "NOME COMPLETO",
    "province": "LUANDA",
    "gender": "MASCULINO",
    "state": null,
    "birthday": "1992-08-12T00:00:00.000",
    "data_of_issue": "2020-01-01T00:00:00.000",
    "expiration_date": "2030-01-01T00:00:00.000"
}
```

## Preview
<br>
<img title="" src="https://github.com/srnunio/ao_bi/blob/master/preview.gif" alt="" width="400">
</br>

## License

bi_ao is available under the MIT license.

# Support

You liked this package? then give it a star. If you want to help then:

* Start this repository
* Send a Pull Request with new features
* Share this package
* Create issues if you find a Bug or want to suggest something
