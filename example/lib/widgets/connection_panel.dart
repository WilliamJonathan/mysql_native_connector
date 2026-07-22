import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';

class ConnectionPanel extends StatelessWidget {
  const ConnectionPanel({
    super.key,
    required this.hostController,
    required this.portController,
    required this.userController,
    required this.passwordController,
    required this.databaseController,
    required this.iniLabel,
    required this.isConnected,
    required this.isBusy,
    required this.useDemoSession,
    required this.onUseDemoChanged,
    required this.onReloadIni,
    required this.onConnect,
    required this.onDisconnect,
  });

  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final TextEditingController databaseController;
  final String iniLabel;
  final bool isConnected;
  final bool isBusy;
  final bool useDemoSession;
  final ValueChanged<bool> onUseDemoChanged;
  final VoidCallback onReloadIni;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Conexão MySQL',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Fonte: $iniLabel',
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: hostController,
                  enabled: !isConnected,
                  style: const TextStyle(color: AppTheme.text),
                  decoration: const InputDecoration(labelText: 'Host'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: portController,
                  enabled: !isConnected,
                  style: const TextStyle(color: AppTheme.text),
                  decoration: const InputDecoration(labelText: 'Porta'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: userController,
                  enabled: !isConnected,
                  style: const TextStyle(color: AppTheme.text),
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: passwordController,
                  enabled: !isConnected,
                  obscureText: true,
                  style: const TextStyle(color: AppTheme.text),
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: databaseController,
            enabled: !isConnected,
            style: const TextStyle(color: AppTheme.text),
            decoration: const InputDecoration(labelText: 'Database'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Modo demonstração',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: const Text(
              'Simula query/execute até a engine Rust ficar pronta',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
            value: useDemoSession,
            onChanged: isConnected ? null : onUseDemoChanged,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: isBusy ? null : onReloadIni,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Recarregar geral.ini'),
              ),
              if (isConnected)
                FilledButton.tonalIcon(
                  onPressed: isBusy ? null : onDisconnect,
                  icon: const Icon(Icons.link_off, size: 18),
                  label: const Text('Desconectar'),
                )
              else
                FilledButton.icon(
                  onPressed: isBusy ? null : onConnect,
                  icon: isBusy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.link, size: 18),
                  label: const Text('Conectar'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _StatusChip(connected: isConnected, demo: useDemoSession),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.connected, required this.demo});

  final bool connected;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppTheme.accent : AppTheme.warning;
    final label = connected
        ? (demo ? 'Conectado (demo)' : 'Conectado')
        : 'Desconectado';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
