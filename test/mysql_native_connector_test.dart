import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector/mysql_native_connector_platform_interface.dart';
import 'package:mysql_native_connector/mysql_native_connector_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMysqlNativeConnectorPlatform
    with MockPlatformInterfaceMixin
    implements MysqlNativeConnectorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MysqlNativeConnectorPlatform initialPlatform = MysqlNativeConnectorPlatform.instance;

  test('$MethodChannelMysqlNativeConnector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMysqlNativeConnector>());
  });

  test('getPlatformVersion', () async {
    MysqlNativeConnector mysqlNativeConnectorPlugin = MysqlNativeConnector();
    MockMysqlNativeConnectorPlatform fakePlatform = MockMysqlNativeConnectorPlatform();
    MysqlNativeConnectorPlatform.instance = fakePlatform;

    expect(await mysqlNativeConnectorPlugin.getPlatformVersion(), '42');
  });
}
