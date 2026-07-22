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
example GUI → MysqlSession (Dart)
                ├─ demo()     # UI/dev sem MySQL
                └─ native()   # Rust FFI (sqlx) — alvo
geral.ini → GeralIni → MysqlConnectionConfig → connect()
```

## Checklist: ligar engine Rust

```
Progress:
- [ ] Cargo.toml: sqlx + tokio + chrono + once_cell
- [ ] rust/src/models.rs + api (init/query/execute/close)
- [ ] Sem unwrap/panic em rotas de DB
- [ ] flutter_rust_bridge_codegen generate
- [ ] MysqlSession.native() chama FFI
- [ ] example: desligar demo e testar contra MySQL real
- [ ] flutter analyze + flutter test
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
factory Pedido.fromRow(MysqlRow row) => Pedido(
  id: row['id'] as int,
  total: row['total'] as double?,
);
```

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
