import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mysql_native_connector_platform_interface.dart';

/// An implementation of [MysqlNativeConnectorPlatform] that uses method channels.
class MethodChannelMysqlNativeConnector extends MysqlNativeConnectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mysql_native_connector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
