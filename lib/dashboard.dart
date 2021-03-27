import 'package:flutter/material.dart';

import 'drawer.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      drawer: DrawerWidget(),
    );
  }
}
