#include "include/mysql_native_connector/mysql_native_connector_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "mysql_native_connector_plugin.h"

void MysqlNativeConnectorPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  mysql_native_connector::MysqlNativeConnectorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
