# AGENTS.md — mysql_native_connector

Contexto permanente para agentes Cursor neste repositório.

## Objetivo do produto

Plugin Flutter Windows que conecta **direto** ao MySQL (TCP), sem API HTTP, para modernizar módulos de ERP **VB6**. Modelo mental: Delphi/ADO no desktop.

Fluxo alvo:

```text
VB6 ShellExecute → Flutter .exe → Dart API → Rust (sqlx) → MySQL
Credenciais: geral.ini (nunca hardcoded no binário)
```

## Escopo atual

- **Feito:** GUI example, `geral.ini`, `MysqlSession`, engine Rust, ORM `Mysql.of` + codegen/`@LeftJoin`.
- **Não feito ainda:** `.exe` virtualizado / empacote portátil para VB6; binds `?` no Rust.

Não reinventar method channels para MySQL — o caminho oficial é **flutter_rust_bridge**.

## Regras de ouro

1. Sem senha/IP/user hardcoded em Dart ou Rust.
2. Rust: sem `panic!` / `unwrap` / `expect` em rotas de DB → `Result<T, String>`.
3. Colunas anuláveis SQL → `Option<T>` no Rust → `T?` no Dart.
4. Sempre expor `close` / drop do pool explicitamente.
5. Windows-first; não expandir Android/iOS sem pedido explícito.
6. Não editar à mão `lib/src/rust/**` gerado pelo bridge.

## Mapa do código

| Path | Papel |
|------|--------|
| `lib/mysql_native_connector.dart` | Exports públicos |
| `lib/src/config/` | `GeralIni`, `MysqlConnectionConfig` |
| `lib/src/mysql_session.dart` | API de sessão (demo + stub nativo) |
| `lib/src/models/` | `MysqlQueryResult` / `MysqlRow` |
| `rust/` | Engine nativa (a implementar) |
| `example/lib/` | GUI console desktop |
| `example/geral.ini` | INI de desenvolvimento |

## Como trabalhar com IA neste repo

1. **AGENTS.md** = visão e travas (este arquivo).
2. **Rules** (`.cursor/rules/*.mdc`) = restrições curtas por área.
3. **Skills** (`.cursor/skills/.../SKILL.md`) = receitas passo a passo (engine, codegen, GUI).
4. Pedidos grandes: skill relevante primeiro; não colar blueprints gigantes no chat.
5. Preferir mudanças pequenas e verificáveis (`flutter analyze`, `flutter run -d windows`).

## API pública desejada (alvo)

```dart
final config = (await GeralIni.loadFile(path)).toMysqlConfig();
await Mysql.boot(config: config);
ClienteModel.box; // register

final clientes = await Mysql.of<ClienteModel>().index();
await cliente.store();
await Mysql.disconnect();
```

OO sem `fromJson`: mapeie `MysqlRow` para classes do domínio:

```dart
class Cliente {
  Cliente({required this.codigo, required this.nome});
  final String codigo;
  final String nome;

  factory Cliente.fromRow(MysqlRow row) => Cliente(
        codigo: row.string('cli_codigo'),
        nome: row.string('cli_nome'),
      );
}
```

