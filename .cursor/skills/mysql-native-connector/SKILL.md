---
name: mysql-native-connector
description: >-
  Workflows do plugin Flutter/Rust mysql_native_connector (MySQL direto, geral.ini,
  GUI example, flutter_rust_bridge). Use when implementing the Rust engine, regenerating
  FFI bindings, extending MysqlSession, editing the example desktop console, or packaging
  Windows modules for VB6 ERP.
---

# mysql_native_connector

## When to use

- Implementar ou ligar a engine MySQL em Rust
- Regenerar `flutter_rust_bridge`
- Estender `MysqlSession` / `GeralIni` / GUI do `example`
- Preparar módulo Windows para VB6

## Read first

1. [AGENTS.md](../../../AGENTS.md)
2. [README.md](../../../README.md)

## Architecture

```text
Page → Store (fold) → Service (ResultState) → Model/ORM → MysqlSession → Rust → MySQL
```

## Checklist: ligar engine Rust

```
Progress:
- [x] Cargo.toml: sqlx + tokio + chrono + once_cell
- [x] rust/src/models.rs + api (init/query/execute/close)
- [x] Sem unwrap/panic em rotas de DB
- [x] flutter_rust_bridge_codegen generate
- [x] MysqlSession.native() chama FFI
- [x] example: SQL clientes real; demo opcional
- [ ] flutter analyze + flutter test (verificar após mudanças)
```

## Checklist: mudar API Dart pública

- Atualizar exports em `lib/mysql_native_connector.dart`
- Ajustar example GUI se a UX mudar
- Cobrir parser/sessão em `test/`
- Documentar em README se for breaking

## geral.ini contract

```ini
[mysql]
host=...
port=3306
user=...
password=...
database=...
max_connections=5
```

Aliases: `servidor`, `porta`, `usuario`, `senha`, `banco`.

## OO sem fromJson

```dart
ClienteModel.box; // register
final rows = await Mysql.of<ClienteModel>().index();
await Mysql.of<ClienteModel>().query().orderBy('cli_nome').limit(50).get();
await cliente.store();
```

Codegen: `@MysqlTable` / `@MysqlColumn` / `@LeftJoin` → `*.mysql.g.dart` + `Mysql.register`.

## Commands

```bash
flutter pub get
flutter test
cd example && flutter run -d windows
```

Codegen (quando a engine existir):

```bash
flutter_rust_bridge_codegen generate
```

## Do not

- Hardcode credenciais
- Editar `lib/src/rust/**` à mão
- Introduzir HTTP/API como dependência do conector
- Expandir para mobile sem pedido explícito
