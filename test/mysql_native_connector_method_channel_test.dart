import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';

void main() {
  test('MysqlRow acesso por nome e toMap', () {
    const columns = ['id', 'nome'];
    final row = MysqlRow([7, 'Alpha'], columns: columns);
    expect(row['id'], 7);
    expect(row['nome'], 'Alpha');
    expect(row.toMap(), {'id': 7, 'nome': 'Alpha'});
  });

  test('MysqlSession.native ainda não implementado', () async {
    final session = MysqlSession.native();
    expect(
      () => session.connect(
        const MysqlConnectionConfig(
          host: '127.0.0.1',
          port: 3306,
          user: 'root',
          password: '',
          database: 'x',
        ),
      ),
      throwsA(isA<UnimplementedError>()),
    );
  });
}
