import 'package:flutter/material.dart';

/// Exibe uma notificação estilo snackbar diretamente no overlay raiz,
/// garantindo que apareça acima de qualquer dialog ou modal aberto.
///
/// Uso:
///   OverlayNotification.show(context, 'Mensagem');
///   OverlayNotification.show(context, 'Erro!', backgroundColor: Colors.red);
class OverlayNotification {
  OverlayNotification._();

  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (_) => _OverlayNotificationWidget(
            message: message,
            backgroundColor: backgroundColor,
            onDismiss: () {
              if (entry.mounted) entry.remove();
            },
          ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _OverlayNotificationWidget extends StatefulWidget {
  const _OverlayNotificationWidget({
    required this.message,
    required this.backgroundColor,
    required this.onDismiss,
  });

  final String message;
  final Color backgroundColor;
  final VoidCallback onDismiss;

  @override
  State<_OverlayNotificationWidget> createState() => _OverlayNotificationWidgetState();
}

class _OverlayNotificationWidgetState extends State<_OverlayNotificationWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 24,
      left: 24,
      right: 24,
      child: FadeTransition(
        opacity: _opacity,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          color: widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
