// Flutter imports:
import 'package:flutter/material.dart';

class ActionAppBar extends StatefulWidget with PreferredSizeWidget {
  const ActionAppBar({
    required this.title,
    required this.isActive,
    required this.onStartPressed,
    required this.onStopPressed,
    Key? key,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            size: 30.0,
            progress: _controller,
          ),
          onPressed: () {
            isStartActionActive
                ? widget.onStartPressed()
                : widget.onStopPressed();

            toggleAnimation();
          },
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
