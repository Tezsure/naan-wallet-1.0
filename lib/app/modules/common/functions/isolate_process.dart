import 'dart:isolate';

class CommonIsolate {
  bool _running = false;

  Isolate _isolate;
  ReceivePort _receivePort;
  var _callback;
  List<Isolate> _isolates = [];

  get running => _running;

  init(process, receiverCallback, {arguments, debugName}) async {
    stop();
    _callback = receiverCallback;
    _running = true;
    _receivePort = ReceivePort();
    Isolate.spawn(
            process,
            arguments == null
                ? [_receivePort.sendPort]
                : [_receivePort.sendPort, ...arguments],
            debugName: debugName ?? "isolate")
        .then((value) {
      _isolate = value;
      _isolates.add(_isolate);
      try {
        _receivePort.asBroadcastStream().listen(_handleMessage);
      } catch (e) {}
    });
  }

  void _handleMessage(dynamic data) {
    _callback(data);
  }

  void stop() {
    if (_isolates.isNotEmpty) {
      _running = false;
      _receivePort.close();
      _isolates.forEach((element) {
        element.kill(priority: Isolate.immediate);
      });
      _isolates = <Isolate>[];
      // _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
