import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector_example/main.dart';

void main() {
  testWidgets('Home mostra abas Clientes e SQL', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MysqlConnectorApp(
        bootError: 'sem banco no teste de widget',
      ),
    );
    await tester.pump();

    expect(find.text('Não foi possível abrir o MySQL'), findsOneWidget);
    expect(find.textContaining('sem banco'), findsOneWidget);
  });
}
