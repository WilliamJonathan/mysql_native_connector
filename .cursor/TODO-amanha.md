# ORM Eloquent — status

## Feito (2026-07-23)

- API opção 4: `Mysql.of<T>().index/show/...` + `model.store/update/destroy()`
- Analogia ObjectBox: `ClienteModel.box` registra e espelha o handle tipado
- `@MysqlTable` / `@MysqlColumn` / `@LeftJoin` + generator no example
- SELECT só com colunas anotadas; joins com alias `campo__coluna`
- Service + Store com `result.fold` mantidos

## Próximo (opcional)

1. Binds `?` no Rust (tirar `mysqlLiteral`)
2. Cascata de escrita no join
3. HasMany

## Comandos

```bash
cd example
flutter run -d windows
dart run build_runner build --delete-conflicting-outputs
```

## Arquivos-chave

- `lib/src/orm/` — Mysql, MysqlBox, MysqlModel, schema, anotações
- `example/lib/app/pages/clientes/models/cliente_model.dart`
- `example/lib/app/pages/clientes/models/endereco_model.dart` (exemplo LeftJoin)
- `mysql_native_connector_generator/`
