# Sessão 2026-07-23 — encerrado

## Feito hoje

### ORM API (opção 4 / analogia ObjectBox)
- `Mysql.of<T>().index/show/query/destroy` — box tipado
- `model.store()` / `update()` / `destroy()` na instância (`MysqlModel<T>`)
- Model limpo: sem statics `ClienteModel.index()` etc.
- `ClienteModel.box` registra no `Mysql.of` (AppDatabase chama no boot)

### Anotações + codegen
- `@MysqlTable` / `@MysqlColumn` / `@MysqlPrimaryKey` / `@LeftJoin`
- `MysqlPrimaryKey` e `MysqlNotNull` são classes **próprias** (não estendem `MysqlColumn`) — senão o analyzer não avalia a constante e o generator não vê a PK
- Generator gera `*.mysql.g.dart` + `Mysql.register` + LEFT JOIN com alias `campo__coluna`
- Join: só colunas anotadas; `store/update` persistem só a tabela raiz

### Example — LeftJoin real
- `EnderecoCliModel` → tabela `cliente_enderecos`
- `ClienteModel.enderecoCli` com `@LeftJoin(localKey: cli_codigo, foreignKey: end_cli_codigo)`
- UI em `clientes_page` mostra `cliente.enderecoCli?.resumo`
- Removido `endereco_model.dart` demo antigo

### build_runner — como usar (pasta `example/`)
```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
# se “27 skipped” e precisa forçar:
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Armadilhas resolvidas
1. `source_gen 3.1` + `analyzer 8.4` → erro `getInvocation`  
   → `dependency_overrides: analyzer: 8.2.0` no example + pin no generator
2. PK “não encontrada” → `@MysqlPrimaryKey` não pode estender `MysqlColumn` com `super`
3. Join gerava `String?`/`int?` em campos non-null → generator usa nullability do model relacionado

## Ainda não feito
- Binds `?` no Rust (`mysqlLiteral` no search continua)
- Cascata de escrita no join / HasMany
- Empacote `.exe` único (Enigma) para VB6

## Arquivos-chave
- `lib/src/orm/` — Mysql, MysqlBox, MysqlModel, anotações, schema
- `mysql_native_connector_generator/`
- `example/lib/app/pages/clientes/models/cliente_model.dart`
- `example/lib/app/pages/clientes/models/endere_cli_model.dart`
- `example/pubspec.yaml` (`dependency_overrides.analyzer`)
