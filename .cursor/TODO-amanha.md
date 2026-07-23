# Continuar amanhã — ORM Eloquent

## Onde paramos (2026-07-23)

- Model limpo com `@MysqlTable` / `@MysqlColumn` + facades Laravel:
  - `ClienteModel.index()` / `.show()` / `.store()` / `.update()` / `.destroy()`
- Motor em `cliente_model.mysql.g.dart` (formato do codegen)
- Sessão global: `Mysql.boot` / `AppDatabase.open()`
- **Service + Store com `result.fold` mantidos** (não remover)

## Próximo passo (amanhã)

1. Ligar de vez o `mysql_native_connector_generator` no `example` (`build_runner`)
2. Fazer o generator **escrever também as facades** `index/show/store/...` (hoje ainda há one-liners no model)
3. Meta: model só com anotações + domínio; zero boilerplate de API
4. (Opcional) binds `?` no Rust para tirar `mysqlLiteral` do search

## Comandos úteis

```bash
cd example
flutter run -d windows
# quando generator estiver no pubspec:
dart run build_runner build --delete-conflicting-outputs
```

## Arquivos-chave

- `example/lib/app/pages/clientes/models/cliente_model.dart`
- `example/lib/app/pages/clientes/models/cliente_model.mysql.g.dart`
- `mysql_native_connector_generator/`
- `lib/src/orm/`
