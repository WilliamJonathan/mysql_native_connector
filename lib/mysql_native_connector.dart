import 'mysql_native_connector_platform_interface.dart';

class MysqlNativeConnector {
  Future<String?> getPlatformVersion() {
    return MysqlNativeConnectorPlatform.instance.getPlatformVersion();
  }
}
