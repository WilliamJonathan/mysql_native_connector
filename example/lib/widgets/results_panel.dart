import 'package:flutter/material.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';

class ResultsPanel extends StatelessWidget {
  const ResultsPanel({
    super.key,
    required this.result,
    required this.lastMessage,
  });

  final MysqlQueryResult? result;
  final String? lastMessage;

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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Text(
                  'Resultados',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
                const Spacer(),
                if (result != null)
                  Text(
                    '${result!.rowCount} linha(s)'
                    '${result!.duration != null ? ' · ${result!.duration!.inMilliseconds} ms' : ''}',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (result == null) {
      return Center(
        child: Text(
          lastMessage ?? 'Execute um SELECT para ver a grade aqui.',
          style: const TextStyle(color: AppTheme.textMuted),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (result!.isEmpty) {
      return const Center(
        child: Text(
          'Consulta retornou 0 linhas.',
          style: TextStyle(color: AppTheme.textMuted),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              for (final column in result!.columns)
                DataColumn(label: Text(column)),
            ],
            rows: [
              for (final row in result!.rows)
                DataRow(
                  cells: [
                    for (var i = 0; i < result!.columns.length; i++)
                      DataCell(Text('${row.values[i] ?? ''}')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
