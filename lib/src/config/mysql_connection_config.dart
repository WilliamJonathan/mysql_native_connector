/// Credenciais e endpoint MySQL lidos de `geral.ini` (nunca hardcode no binário).
class MysqlConnectionConfig {
  const MysqlConnectionConfig({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.database,
    this.maxConnections = 5,
  });

  final String host;
  final int port;
  final String user;
  final String password;
  final String database;
  final int maxConnections;

  /// URL no formato aceito pelo sqlx/MySQL.
  String get connectionUrl {
    final encodedUser = Uri.encodeComponent(user);
    final encodedPassword = Uri.encodeComponent(password);
    final encodedDb = Uri.encodeComponent(database);
    return 'mysql://$encodedUser:$encodedPassword@$host:$port/$encodedDb';
  }

  MysqlConnectionConfig copyWith({
    String? host,
    int? port,
    String? user,
    String? password,
    String? database,
    int? maxConnections,
  }) {
    return MysqlConnectionConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      user: user ?? this.user,
      password: password ?? this.password,
      database: database ?? this.database,
      maxConnections: maxConnections ?? this.maxConnections,
    );
  }

  Map<String, String> toSafeMap() => {
        'host': host,
        'port': '$port',
        'user': user,
        'database': database,
        'maxConnections': '$maxConnections',
      };

  @override
  String toString() =>
      'MysqlConnectionConfig(host: $host, port: $port, user: $user, database: $database)';
}
