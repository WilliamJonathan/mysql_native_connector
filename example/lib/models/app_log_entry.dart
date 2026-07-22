class AppLogEntry {
  AppLogEntry(this.message, {DateTime? at, this.isError = false})
      : at = at ?? DateTime.now();

  final DateTime at;
  final String message;
  final bool isError;

  String get formatted {
    final h = at.hour.toString().padLeft(2, '0');
    final m = at.minute.toString().padLeft(2, '0');
    final s = at.second.toString().padLeft(2, '0');
    return '[$h:$m:$s] $message';
  }
}
