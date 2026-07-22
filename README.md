# mysql_native_connector

Plugin Flutter **Windows-first** para conexão **direta** a MySQL (estilo Delphi/ADO), pensado para modernizar telas de ERP **VB6** sem API HTTP obrigatória.

```text
Flutter UI  →  Dart API  →  Rust FFI (sqlx)  →  MySQL TCP
                 ↑
            geral.ini (credenciais)
```

## Status atual

| Camada | Estado |
|--------|--------|
| GUI example (console desktop) | Pronto |
| Leitura `geral.ini` | Pronto |
| API Dart (`MysqlSession`, `MysqlQueryResult`) | Pronto (demo + nativo) |
| Engine Rust (`sqlx` + pool) | Pronto (Windows FFI) |
| Empacote `.exe` único (Enigma etc.) | Depois |

## Uso rápido (app Flutter)

```yaml
dependencies:
  mysql_native_connector:
    path: ../mysql_native_connector   # ou git/path do seu monorepo
```

```dart
import 'package:mysql_native_connector/mysql_native_connector.dart';

final ini = await GeralIni.loadFile(r'C:\erp\geral.ini');
final config = ini.toMysqlConfig();

await MysqlSession.initNative(); // uma vez no main (Windows)
final session = MysqlSession.native(); // ou MysqlSession.demo() sem MySQL
await session.connect(config);

final result = await session.query('SELECT id, nome FROM clientes LIMIT 20');
for (final row in result.rows) {
  final id = row['id'];
  final nome = row['nome'];
}

await session.close();
```

Orientação a objetos sem `fromJson`: mapeie `MysqlRow` para classes do domínio:

```dart
class Cliente {
  Cliente({required this.id, required this.nome});
  final int id;
  final String nome;

  factory Cliente.fromRow(MysqlRow row) => Cliente(
        id: row['id'] as int,
        nome: '${row['nome']}',
      );
}
```

## `geral.ini`

Credenciais **não** vão no `.exe`. Formato:

```ini
[mysql]
host=127.0.0.1
port=3306
user=root
password=
database=erp_demo
max_connections=5
```

Aliases aceitos: `servidor`, `porta`, `usuario`, `senha`, `banco`.

O example procura, nesta ordem:

1. `geral.ini` no diretório de trabalho
2. `geral.ini` ao lado do executável (Windows)
3. asset embutido `assets/geral.ini.example`

## Example GUI

```bash
cd example
flutter run -d windows
```

Painéis: conexão (ini), console SQL, grade de resultados, log e status bar.  
Toggle **Modo demonstração** permite validar o fluxo completo sem MySQL real.

Args de linha de comando (VB6 `ShellExecute`) aparecem no log:

```bash
flutter run -d windows --dart-define=... # ou passe args nativos do Windows
# ex.: modulo.exe --cliente_id=10 --usuario=jw
```

## Arquitetura Cursor (IA)

| Arquivo | Função |
|---------|--------|
| [`AGENTS.md`](AGENTS.md) | Norte do projeto — o agente lê sempre |
| [`.cursor/rules/`](.cursor/rules/) | Travas curtas (Rust/Dart/segurança) |
| [`.cursor/skills/mysql-native-connector/`](.cursor/skills/mysql-native-connector/) | Workflows (engine, bridge, GUI) |

## Próximos passos

1. Empacotar release Windows em `.exe` portátil para o VB6
2. Models de domínio OO (`Cliente.fromRow`) nos módulos ERP
3. Virtualizar / proteger o binário se necessário (Enigma etc.)
