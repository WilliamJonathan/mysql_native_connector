import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';

class _Item extends MysqlModel<_Item> {
  _Item(this.id, this.nome);
  final String id;
  final String nome;
}

void main() {
  tearDown(() {
    Mysql.clearRegistry();
    Mysql.unbind();
  });

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
    expect(sql, isNot(contains('LEFT JOIN')));
  });

  test('MysqlTableSchema com LeftJoin só seleciona colunas anotadas', () {
    const joined = MysqlTableSchema(
      name: 'clientes',
      primaryKey: 'cli_codigo',
      columns: ['cli_codigo', 'cli_nome'],
      joins: [
        MysqlJoinSpec(
          table: 'enderecos',
          localKey: 'cli_codigo',
          foreignKey: 'end_cliente',
          alias: 'endereco',
          columns: ['end_codigo', 'end_logradouro'],
        ),
      ],
    );

    final sql = joined.selectSql(limit: 5);
    expect(sql, contains('LEFT JOIN `enderecos` AS `endereco`'));
    expect(sql, contains('`clientes` AS `clientes`'));
    expect(sql, contains('`endereco`.`end_logradouro` AS `endereco__end_logradouro`'));
    expect(sql, contains('`clientes`.`cli_nome` AS `cli_nome`'));
    expect(sql, isNot(contains('cli_fantasia')));
    expect(sql, contains('ON `clientes`.`cli_codigo` = `endereco`.`end_cliente`'));
  });

  test('MysqlTableSchema INSERT/UPDATE/DELETE ignoram join', () {
    const joined = MysqlTableSchema(
      name: 'clientes',
      primaryKey: 'cli_codigo',
      columns: ['cli_codigo', 'cli_nome'],
      joins: [
        MysqlJoinSpec(
          table: 'enderecos',
          localKey: 'cli_codigo',
          foreignKey: 'end_cliente',
          alias: 'endereco',
          columns: ['end_codigo'],
        ),
      ],
    );
    final values = {'cli_codigo': '1', 'cli_nome': "O'Brien"};
    expect(joined.insertSql(values), startsWith('INSERT INTO `clientes`'));
    expect(joined.insertSql(values), isNot(contains('enderecos')));
    expect(joined.updateSql(values, '1'), startsWith('UPDATE `clientes`'));
    expect(joined.deleteSql('1'), startsWith('DELETE FROM `clientes`'));
  });

  test('Mysql.register / Mysql.of tipado', () {
    final repo = MysqlRepository<_Item>(
      schema: const MysqlTableSchema(
        name: 'itens',
        primaryKey: 'id',
        columns: ['id', 'nome'],
      ),
      fromRow: (row) => _Item(row.string('id'), row.string('nome')),
      toColumns: (m) => {'id': m.id, 'nome': m.nome},
      idOf: (m) => m.id,
    );
    Mysql.register<_Item>(repo, defaultOrderBy: '`nome` ASC');
    expect(Mysql.isRegistered<_Item>(), isTrue);
    expect(Mysql.of<_Item>().schema.name, 'itens');
    expect(Mysql.of<_Item>().defaultOrderBy, '`nome` ASC');
  });

  test('Mysql.of sem registro lança', () {
    expect(() => Mysql.of<_Item>(), throwsStateError);
  });

  test('Mysql.bind exige sessão conectada', () {
    Mysql.unbind();
    expect(() => Mysql.session, throwsStateError);
  });
}
