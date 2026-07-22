import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    required this.connected,
    required this.demoMode,
    required this.detail,
  });

  final bool connected;
  final bool demoMode;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: AppTheme.panelAlt,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          Icon(
            connected ? Icons.circle : Icons.circle_outlined,
            size: 10,
            color: connected ? AppTheme.accent : AppTheme.textMuted,
          ),
          const SizedBox(width: 8),
          Text(
            connected
                ? (demoMode ? 'Sessão demo ativa' : 'Sessão nativa')
                : 'Offline',
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              detail,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ),
          const Text(
            'Windows · ERP VB6 bridge',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
