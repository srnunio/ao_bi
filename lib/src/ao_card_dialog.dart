import 'dart:io';

import 'package:ao_bi/src/ao_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'models.dart';

class BIQrView extends StatefulWidget {
  /// [title] title on appbar
  final String title;

  final double? cutOutSize;

  /// [barStyle] Modify the style of the Bar app
  final BIQrStyle barStyle;

  final Function() onClose;

  BIQrView({
    required this.title,
    required this.barStyle,
    required this.cutOutSize,
    required this.onClose,
  });

  @override
  _BIQrViewState createState() => _BIQrViewState();
}

class _BIQrViewState extends State<BIQrView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  /// [_controller] QR controller
  QRViewController? _controller;

  /// [_getCutOutSize] size border qr camera
  double _getCutOutSize() {
    var size = MediaQuery.of(context).size;
    return (size.width < 400 || size.height < 400) ? 280.0 : 350.0;
  }

  /// [_onRead] process data
  void _onRead(String code) async {
    _controller?.stopCamera();
    var data = BIUtil.check(code);
    Navigator.of(context, rootNavigator: true).pop(data);
    widget.onClose();
  }

  /// [_onClose] close page
  void _onClose() {
    Navigator.of(context, rootNavigator: true).pop();
    widget.onClose();
  }

  /// [_onQRViewCreated] init qr controller
  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((sd) {
      if (sd.code != null) {
        controller.pauseCamera();
        _onRead(sd.code!);
      }
    });
  }

  /// [_buildQrView] Qr code view
  Widget _buildQrView() {
    final barStyle = widget.barStyle;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: const [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        overlayColor: barStyle.overlayColor,
        borderColor: barStyle.borderColor,
        borderRadius: 10,
        borderLength: 10 * 3,
        borderWidth: 10,
        cutOutSize: widget.cutOutSize ?? _getCutOutSize(),
      ),
      onPermissionSet: (ctrl, p) {},
    );
  }

  /// [_bodyDefault] layout
  Widget _bodyDefault() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 5, child: _buildQrView()),
      ],
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final barStyle = widget.barStyle;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
        ),
        title: Text(
          widget.title,
          style: barStyle.labelStyle,
        ),
        backgroundColor: barStyle.appBarBackgroundColor,
        leading: CloseButton(
          color: barStyle.accentColor,
          onPressed: _onClose,
        ),
        elevation: 0.0,
      ),
      body: _bodyDefault(),
      backgroundColor: Colors.transparent,
    );
  }
}
