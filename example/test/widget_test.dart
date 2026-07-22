import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector_example/main.dart';

void main() {
  testWidgets('Workspace carrega título do console', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MysqlConnectorApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('MySQL Native Connector'), findsOneWidget);
    expect(find.text('Conexão MySQL'), findsOneWidget);
    expect(find.text('Console SQL'), findsOneWidget);
  });
}
