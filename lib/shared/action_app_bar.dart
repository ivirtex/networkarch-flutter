// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class ActionAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ActionAppBar({
    required this.title,
    required this.isActive,
    required this.onStartPressed,
    required this.onStopPressed,
    super.key,
  });

  final String title;
  final bool isActive;
  final VoidCallback onStartPressed;
  final VoidCallback onStopPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ActionAppBar> createState() => ActionAppBarState();
}

class ActionAppBarState extends State<ActionAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isAnimating = false;
  bool isStartActionActive = true;
  double? progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void setIndicatorProgress(double? progress) {
    setState(() {
      this.progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Constants.bodyPadding.right),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.isActive
                ? () {
                    isStartActionActive
                        ? widget.onStartPressed()
                        : widget.onStopPressed();

                    toggleAnimation();
                  }
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  value: progress,
                ),
                AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _controller,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void toggleAnimation() {
    isStartActionActive = !isStartActionActive;

    isAnimating = !isAnimating;
    isAnimating ? _controller.forward() : _controller.reverse();
  }
}
