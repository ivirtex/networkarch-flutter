// Flutter imports:
import 'package:flutter/material.dart';

class LanScannerView extends StatelessWidget {
  const LanScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LAN Scanner",
        ),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
      ),
      body: Container(),
    );
  }
}
