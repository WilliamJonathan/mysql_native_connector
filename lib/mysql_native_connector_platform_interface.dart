import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mysql_native_connector_method_channel.dart';

abstract class MysqlNativeConnectorPlatform extends PlatformInterface {
  /// Constructs a MysqlNativeConnectorPlatform.
  MysqlNativeConnectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static MysqlNativeConnectorPlatform _instance =
      MethodChannelMysqlNativeConnector();

  /// The default instance of [MysqlNativeConnectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelMysqlNativeConnector].
  static MysqlNativeConnectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MysqlNativeConnectorPlatform] when
  /// they register themselves.
  static set instance(MysqlNativeConnectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
