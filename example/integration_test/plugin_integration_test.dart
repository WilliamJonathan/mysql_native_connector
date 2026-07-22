import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('GeralIni + sessão demo no fluxo básico', (tester) async {
    const raw = '''
[mysql]
host=127.0.0.1
port=3306
user=root
password=
database=erp_demo
''';
    final config = GeralIni.parse(raw).toMysqlConfig();
    final session = MysqlSession.demo();
    await session.connect(config);
    final result = await session.query('SELECT 1');
    expect(result.rowCount, greaterThan(0));
    await session.close();
  });
}
