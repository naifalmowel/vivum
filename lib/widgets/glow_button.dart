import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { amber, teal, outline }

class VivumButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final ButtonVariant variant;
  final Widget? icon;

  const VivumButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = ButtonVariant.amber,
    this.icon,
  });

  @override
  State<VivumButton> createState() => _VivumButtonState();
}

class _VivumButtonState extends State<VivumButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isAmber = widget.variant == ButtonVariant.amber;
    final isTeal = widget.variant == ButtonVariant.teal;
    final isOutline = widget.variant == ButtonVariant.outline;

    final color = isAmber ? VivumColors.amber : isTeal ? VivumColors.teal : Colors.transparent;
    final shadowColor = isAmber ? VivumColors.amber : isTeal ? VivumColors.teal : theme.colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hovered = true);
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hovered = false);
          });
        }
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: 100.ms,
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: isOutline 
                  ? (_hovered ? VivumColors.teal.withValues(alpha: 0.1) : Colors.transparent) 
                  : (_hovered ? color.withValues(alpha: 0.85) : color),
              border: isOutline
                  ? Border.all(
                      color: _hovered 
                          ? VivumColors.teal 
                          : (theme.brightness == Brightness.dark 
                              ? theme.dividerColor 
                              : VivumColors.teal.withValues(alpha: 0.5)), 
                      width: 1.5)
                  : Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
              boxShadow: (isTeal || isAmber || (isOutline && _hovered)) && _hovered
                  ? [BoxShadow(
                      color: (isOutline ? VivumColors.teal : shadowColor).withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    )]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isOutline 
                        ? ( _hovered ? VivumColors.teal : theme.colorScheme.onSurface)
                        : Colors.white, 
                  ),
                ),
                if (widget.icon != null) ...[
                  const SizedBox(width: 8),
                  widget.icon!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
