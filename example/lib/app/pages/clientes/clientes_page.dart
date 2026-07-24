import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/stores/clientes_page_store.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';
import 'package:mysql_native_connector_example/utils/generic_states.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientesPageStore>().index();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () => context.read<ClientesPageStore>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              style: const TextStyle(color: AppTheme.text),
              decoration: InputDecoration(
                labelText: 'Buscar nome / fantasia / CGC',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      context.read<ClientesPageStore>().search(_search.text),
                ),
              ),
              onSubmitted: (value) =>
                  context.read<ClientesPageStore>().search(value),
            ),
          ),
          Expanded(
            child: Consumer<ClientesPageStore>(
              builder: (context, store, _) {
                final state = store.state;
                if (state is LoadingGenericState) {
                  return _ShimmerList();
                }
                if (state is ErrorGenericState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.danger),
                      ),
                    ),
                  );
                }
                if (state is EmptyGenericState) {
                  return const Center(
                    child: Text(
                      'Nenhum cliente encontrado.',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  );
                }
                if (state is SuccessGenericState<List<ClienteModel>>) {
                  final clientes = state.data;
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: clientes.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];
                      return _ClienteTile(cliente: cliente);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClienteTile extends StatelessWidget {
  const _ClienteTile({required this.cliente});

  final ClienteModel cliente;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.panel,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: Text(
          cliente.nomeExibicao,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            'Cód. ${cliente.codigo}',
            if (cliente.cgcFormatado.isNotEmpty) cliente.cgcFormatado,
            if (cliente.enderecoCli != null) cliente.enderecoCli!.resumo,
            if (cliente.enderecoCli == null &&
                (cliente.endereco ?? '').trim().isNotEmpty)
              cliente.endereco!,
          ].join(' · '),
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
        isThreeLine: cliente.enderecoCli != null ||
            (cliente.endereco ?? '').trim().isNotEmpty,
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Shimmer.fromColors(
            baseColor: AppTheme.panelAlt,
            highlightColor: AppTheme.border,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
