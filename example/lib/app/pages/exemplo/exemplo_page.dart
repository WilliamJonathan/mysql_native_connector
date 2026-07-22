import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/app/pages/exemplo/stores/exemplo_page_store.dart';
import 'package:mysql_native_connector_example/utils/generic_states.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ExemploPage extends StatefulWidget {
  const ExemploPage({super.key});

  @override
  State<ExemploPage> createState() => _ExemploPageState();
}

class _ExemploPageState extends State<ExemploPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Inicializar o store e buscar os dados aqui,
      // para evitar que a busca seja feita antes do build,
      // o que pode causar erros de contexto.
      Provider.of<ExemploPageStore>(context, listen: false).index();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo Page')),
      body: Consumer<ExemploPageStore>(
        builder: (context, store, child) {
          if (store.state is LoadingGenericState) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Container(width: 200, height: 20, color: Colors.grey),
              ),
            );
          } else if (store.state is ErrorGenericState) {
            final message = (store.state as ErrorGenericState).message;
            return Center(child: Text('Erro: $message'));
          } else if (store.state is SuccessGenericState) {
            final data = (store.state as SuccessGenericState).data;
            return Center(child: Text('Dados: $data'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
