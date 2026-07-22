import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_native_connector/mysql_native_connector_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMysqlNativeConnector platform = MethodChannelMysqlNativeConnector();
  const MethodChannel channel = MethodChannel('mysql_native_connector');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
