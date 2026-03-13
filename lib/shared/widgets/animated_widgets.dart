/// Animated widgets and transitions
library;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animated entrance transition
class FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.beginOffset = const Offset(0, 20),
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(duration: duration, child: child);
  }
}

/// Animated list tile with elevation on hover
class AnimatedListTile extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AnimatedListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.backgroundColor,
  });

  @override
  State<AnimatedListTile> createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<AnimatedListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: widget.backgroundColor ?? Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: widget.trailing,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated card with scale and fade
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Duration animationDuration;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Padding(
        padding: widget.padding,
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: widget.animationDuration,
          child: Card(color: widget.backgroundColor, child: widget.child),
        ),
      ),
    );
  }
}

/// Staggered list items animation
class StaggeredListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics? physics;
  final EdgeInsets padding;

  const StaggeredListView({
    super.key,
    required this.children,
    this.physics,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      padding: padding,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          duration: const Duration(milliseconds: 500),
          child: children[index],
        );
      },
    );
  }
}

/// Bottom sheet with smooth animation
class AnimatedBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          FadeInUp(duration: const Duration(milliseconds: 400), child: builder(context)),
    );
  }
}

/// Smooth page transition
class SmoothPageTransition extends StatelessWidget {
  final Widget child;
  final bool showAppBar;
  final String? title;
  final PreferredSizeWidget? appBar;

  const SmoothPageTransition({
    super.key,
    required this.child,
    this.showAppBar = true,
    this.title,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Scaffold(
        appBar: appBar ?? (showAppBar ? AppBar(title: Text(title ?? '')) : null),
        body: child,
      ),
    );
  }
}

/// Floating action button with animation
class AnimatedFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? backgroundColor;

  const AnimatedFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip = 'Action',
    this.backgroundColor,
  });

  @override
  State<AnimatedFloatingActionButton> createState() => _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 1,
        end: 0.9,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: FloatingActionButton(
        tooltip: widget.tooltip,
        backgroundColor: widget.backgroundColor,
        onPressed: _handlePress,
        child: Icon(widget.icon),
      ),
    );
  }
}

/// Top slide reveal animation
class SlideReveal extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const SlideReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(duration: duration, child: child);
  }
}

/// Custom dialog with animation
class AnimatedDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AnimatedDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: onCancel ?? () => Navigator.pop(context),
              child: Text(cancelText!),
            ),
          if (confirmText != null)
            ElevatedButton(
              onPressed: onConfirm ?? () => Navigator.pop(context),
              child: Text(confirmText!),
            ),
        ],
      ),
    );
  }
}

/// Animated progress bar
class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.primaryColor;
    final bgColor = backgroundColor ?? Colors.grey[300]!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation(progressColor),
      ),
    ).animate().slideX(begin: -1, end: 0, duration: const Duration(milliseconds: 800));
  }
}

/// Scaleup entrance animation wrapper
class ScaleUpEntrance extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ScaleUpEntrance({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.elasticOut,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomIn(duration: duration, curve: curve, child: child);
  }
}
