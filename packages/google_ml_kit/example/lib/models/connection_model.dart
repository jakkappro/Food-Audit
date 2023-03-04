import 'package:event/event.dart';

class ConnectionModel {
  static final ConnectionModel _instance = ConnectionModel._internal();
  factory ConnectionModel() => _instance;
  ConnectionModel._internal();
  static ConnectionModel get instance {
    return _instance;
  }

  Event<Value<String>> connectionChanged = Event<Value<String>>();
  bool isConnected = false;
  bool isWifi = false;

  void updateConnection(bool isConnected, bool isWifi) {
    this.isConnected = isConnected;
    this.isWifi = isWifi;
    connectionChanged.broadcast(Value<String>(isConnected.toString()));
  }
}
