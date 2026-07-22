#ifndef FLUTTER_PLUGIN_MYSQL_NATIVE_CONNECTOR_PLUGIN_H_
#define FLUTTER_PLUGIN_MYSQL_NATIVE_CONNECTOR_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace mysql_native_connector {

class MysqlNativeConnectorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MysqlNativeConnectorPlugin();

  virtual ~MysqlNativeConnectorPlugin();

  // Disallow copy and assign.
  MysqlNativeConnectorPlugin(const MysqlNativeConnectorPlugin&) = delete;
  MysqlNativeConnectorPlugin& operator=(const MysqlNativeConnectorPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace mysql_native_connector

#endif  // FLUTTER_PLUGIN_MYSQL_NATIVE_CONNECTOR_PLUGIN_H_
