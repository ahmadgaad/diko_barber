import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

enum SnackBarType { error, success, info }

abstract final class AppSnackBar {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.error,
  }) {
    _current?.remove();
    _current = null;

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _SnackBarWidget(
        message: message,
        type: type,
        onDone: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    Overlay.of(context).insert(entry);
  }
}

class _SnackBarWidget extends StatefulWidget {
  const _SnackBarWidget({
    required this.message,
    required this.type,
    required this.onDone,
  });

  final String message;
  final SnackBarType type;
  final VoidCallback onDone;

  @override
  State<_SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<_SnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 260),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bottomOffset = mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom;

    final (bg, icon, fg) = switch (widget.type) {
      SnackBarType.error   => (colors.error50,   Icons.error_outline_rounded,            colors.error600),
      SnackBarType.success => (colors.success50, Icons.check_circle_outline_rounded,     colors.success600),
      SnackBarType.info    => (colors.info50,    Icons.info_outline_rounded,             colors.info600),
    };

    return Positioned(
      bottom: bottomOffset + 16.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! > 100) {
                _dismiss();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: fg.withValues(alpha: 0.25)),
                  boxShadow: [
                    BoxShadow(
                      color: fg.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: fg, size: 20.w),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: fg,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
