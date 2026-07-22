import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/models/app_log_entry.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';

class LogPanel extends StatelessWidget {
  const LogPanel({super.key, required this.entries, required this.onClear});

  final List<AppLogEntry> entries;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                const Text(
                  'Log',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: entries.isEmpty ? null : onClear,
                  child: const Text('Limpar'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: entries.isEmpty
                ? const Center(
                    child: Text(
                      'Sem eventos ainda.',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[entries.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SelectableText(
                          entry.formatted,
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 12,
                            color: entry.isError
                                ? AppTheme.danger
                                : AppTheme.textMuted,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
