import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_arch/services/widgets/cards/data_card.dart';
import 'package:network_arch/services/widgets/platform_widget.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => Scaffold(),
      iosBuilder: (context) => CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  const CupertinoSliverNavigationBar(
                    stretch: true,
                    border: null,
                    largeTitle: Text(
                      'Settings',
                    ),
                  )
                ],
            body: ListView()),
      ),
    );
  }
}
