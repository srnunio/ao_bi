import 'package:ao_bi/bi.dart';
import 'package:example/bi_data_view.dart';
import 'package:example/bottom_sheet_container.dart';
import 'package:flutter/material.dart';

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

  void shoResult(BIData? data) {
    if (data == null) return;
    showModalBottomSheet<dynamic>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.2),
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (ctx) => SheetContainer(
        height: MediaQuery.of(context).size.height * (3 / 4.5),
        child: BIDataView(data),
      ),
    );
  }

  void onScanner() async {
    BIUtil.scan(title: "Scan my document", context: context).then(shoResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: MaterialButton(
                  onPressed: onScanner,
                  color: Colors.deepPurple,
                  elevation: 0.0,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Scan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
