import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';

class SqlEditorPanel extends StatelessWidget {
  const SqlEditorPanel({
    super.key,
    required this.controller,
    required this.enabled,
    required this.isBusy,
    required this.onQuery,
    required this.onExecute,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool isBusy;
  final VoidCallback onQuery;
  final VoidCallback onExecute;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Console SQL',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text,
                ),
              ),
              OutlinedButton(
                onPressed: !enabled || isBusy
                    ? null
                    : () {
                        controller.text =
                            'SELECT id, codigo, nome, ativo, criado_em FROM clientes LIMIT 50';
                      },
                child: const Text('SELECT exemplo'),
              ),
              FilledButton.icon(
                onPressed: !enabled || isBusy ? null : onQuery,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Query'),
              ),
              FilledButton.tonalIcon(
                onPressed: !enabled || isBusy ? null : onExecute,
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Execute'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'Consolas',
                fontSize: 13,
                height: 1.45,
              ),
              decoration: const InputDecoration(
                hintText: 'Digite o SQL aqui…',
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
