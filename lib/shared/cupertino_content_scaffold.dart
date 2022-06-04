// Flutter imports:
import 'package:flutter/cupertino.dart';

class CupertinoContentScaffold extends StatelessWidget {
  const CupertinoContentScaffold({
    required this.child,
    this.largeTitle,
    this.navBarTrailingWidget,
    this.customHeader,
    super.key,
  });

  final Widget? largeTitle;
  final Widget? navBarTrailingWidget;
  final Widget? customHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          customHeader ??
              CupertinoSliverNavigationBar(
                stretch: true,
                border: null,
                largeTitle: largeTitle,
                trailing: navBarTrailingWidget,
              ),
          SliverToBoxAdapter(child: child),
        ],
      ),
    );
  }
}
