# mysql_native_connector_generator

Gera o motor Eloquent (`_$ModelMysql`, `Mysql.register`, `fromRow` com `@LeftJoin`)
a partir de `@MysqlTable` / `@MysqlColumn` / `@LeftJoin`.

```bash
cd example
dart run build_runner build --delete-conflicting-outputs
```

API de uso (não gerada como static no model):

```dart
await Mysql.of<ClienteModel>().index();
await cliente.store();
```
