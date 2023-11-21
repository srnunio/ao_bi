import 'dart:io';

import 'package:ao_bi/bi.dart';
import 'package:example/bi_data_view.dart';
import 'package:example/bottom_sheet_container.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.white,
            modalBackgroundColor: Colors.white,
            surfaceTintColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  BIData? _biData;
  QRViewController? controller;

  void onRead(String code) async {
    if (_biData != null) return;

    _biData = BI.verify(code);

    if (_biData == null) return;

    await showModalBottomSheet<dynamic>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useRootNavigator: true,
        barrierColor: Colors.black.withOpacity(0.2),
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (ctx) => SheetContainer(
              height: MediaQuery.of(context).size.height * (3 / 4.5),
              child: BIDataView(_biData!),
            ));
    _biData = null;
    controller!.resumeCamera();
  }

  void onScanner() async {}

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.pauseCamera();
        onRead(scanData.code!);
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }



  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 280.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: const [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 10 * 3,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _buildQrView(context),
            ),
          ],
        ),
      ),
    );
  }
}
