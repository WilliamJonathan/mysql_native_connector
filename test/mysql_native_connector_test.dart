import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';

void main() {
  test('GeralIni parse e aliases PT', () {
    const raw = '''
[mysql]
servidor=10.0.0.5
porta=3307
usuario=erp
senha=segredo
banco=loja
max_connections=8
''';
    final config = GeralIni.parse(raw).toMysqlConfig();
    expect(config.host, '10.0.0.5');
    expect(config.port, 3307);
    expect(config.user, 'erp');
    expect(config.password, 'segredo');
    expect(config.database, 'loja');
    expect(config.maxConnections, 8);
    expect(config.connectionUrl, contains('10.0.0.5:3307'));
  });

  test('GeralIni aceita BOM e seção [banco]', () {
    const raw = '\uFEFF[banco]\nhost=192.168.0.10\nusuario=jw\nsenha=\ndatabase=erp\n';
    final config = GeralIni.parse(raw).toMysqlConfig();
    expect(config.host, '192.168.0.10');
    expect(config.user, 'jw');
    expect(config.password, '');
    expect(config.database, 'erp');
  });

  test('MysqlSession.demo query/execute', () async {
    final session = MysqlSession.demo();
    await session.connect(
      const MysqlConnectionConfig(
        host: '127.0.0.1',
        port: 3306,
        user: 'root',
        password: '',
        database: 'erp_demo',
      ),
    );

    final result = await session.query('SELECT * FROM clientes');
    expect(result.rowCount, greaterThan(0));
    expect(result.rows.first['codigo'], 'CLI-001');

    final affected = await session.execute(
      "UPDATE clientes SET ativo = 1 WHERE id = 1",
    );
    expect(affected, 1);

    await session.close();
    expect(session.isConnected, isFalse);
  });
}
