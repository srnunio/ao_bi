import 'dart:io';

import 'package:ao_bi/src/ao_bi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'models.dart';

class BIQrView extends StatefulWidget {
  /// [title] title on appbar
  final String title;

  /// [cutOutSize]
  final double? cutOutSize;

  /// [style] Modify the style of the Bar app
  final BIQrStyle style;

  final Function() onDispose;

  BIQrView({
    required this.title,
    required this.style,
    required this.cutOutSize,
    required this.onDispose,
  });

  @override
  _BIQrViewState createState() => _BIQrViewState();
}

class _BIQrViewState extends State<BIQrView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  /// [_isDetectedData] it's is true if data is detected and stop verification
  bool _isDetectedData = false;

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
    _onClose(data);
  }

  /// [_onClose] close page
  void _onClose([dynamic data]) {
    if (mounted) Navigator.pop(context, data);
  }

  /// [_onQRViewCreated] init qr controller
  void _onQRViewCreated(QRViewController controller) {
    setState(() => _controller = controller);
    _controller?.scannedDataStream.listen((sd) {
      var data = (sd.code ?? '').trim();
      if (mounted && data.isNotEmpty && !_isDetectedData) {
        _controller?.pauseCamera();
        _isDetectedData = true;
        _onRead(sd.code!);
      }
    });
  }

  /// [_buildQrView] Qr code view
  Widget _buildQrView() {
    final style = widget.style;
    return Opacity(
      opacity: (_controller != null) ? 1 : 0,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        formatsAllowed: const [BarcodeFormat.qrcode],
        overlay: QrScannerOverlayShape(
          overlayColor: style.overlayColor,
          borderColor: style.borderColor,
          borderRadius: 10,
          borderLength: 10 * 3,
          borderWidth: 10,
          cutOutSize: widget.cutOutSize ?? _getCutOutSize(),
        ),
        onPermissionSet: (ctrl, state) {
          if (!state) _onClose();
        },
      ),
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
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
        ),
        title: Text(
          widget.title,
          style: style.labelStyle,
        ),
        backgroundColor: style.appBarBackgroundColor,
        leading: CloseButton(
          color: style.accentColor,
          onPressed: _onClose,
        ),
        elevation: 0.0,
      ),
      body: _bodyDefault(),
      backgroundColor: Colors.transparent,
    );
  }
}
