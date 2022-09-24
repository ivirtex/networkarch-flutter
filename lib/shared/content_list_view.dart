// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class ContentListView extends StatelessWidget {
  const ContentListView({
    required this.children,
    this.scrollController,
    this.usePaddingOniOS = false,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? scrollController;
  final bool usePaddingOniOS;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return SingleChildScrollView(
          controller: scrollController,
          child: _buildBody(context),
        );
      },
      iosBuilder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: Theme.of(context).platform == TargetPlatform.iOS
          ? usePaddingOniOS
              ? Constants.iOSbodyPadding
              : EdgeInsets.zero
          : Constants.bodyPadding,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: children,
        ),
      ),
    );
  }
}
