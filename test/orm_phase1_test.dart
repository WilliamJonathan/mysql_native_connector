import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';

void main() {
  const schema = MysqlTableSchema(
    name: 'clientes',
    primaryKey: 'cli_codigo',
    columns: [
      'cli_codigo',
      'cli_nome',
      'cli_fantasia',
      'cli_cgc',
      'cli_endereco',
    ],
  );

  test('MysqlTableSchema monta SELECT com order/limit', () {
    final sql = schema.selectSql(
      orderBy: '`cli_nome` ASC',
      limit: 10,
    );
    expect(sql, contains('SELECT'));
    expect(sql, contains('FROM `clientes`'));
    expect(sql, contains('ORDER BY `cli_nome` ASC'));
    expect(sql, contains('LIMIT 10'));
  });

  test('MysqlTableSchema INSERT/UPDATE/DELETE', () {
    final values = {
      'cli_codigo': '1',
      'cli_nome': "O'Brien",
      'cli_fantasia': null,
    };
    expect(schema.insertSql(values), contains("O\\'Brien"));
    expect(schema.updateSql(values, '1'), contains('WHERE `cli_codigo` = \'1\''));
    expect(schema.deleteSql('1'), contains('DELETE FROM `clientes`'));
  });

  test('Mysql.bind exige sessão conectada', () {
    Mysql.unbind();
    expect(() => Mysql.session, throwsStateError);
  });
}
