import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Device GUID Retrieval")),
        body: DeviceGuidWidget(),
      ),
    );
  }
}

class DeviceGuidWidget extends StatefulWidget {
  @override
  _DeviceGuidWidgetState createState() => _DeviceGuidWidgetState();
}

class _DeviceGuidWidgetState extends State<DeviceGuidWidget> {
  static const platform = MethodChannel('com.example.flutter_ios_guid_app');
  String _deviceGuid = 'Unknown';

  Future<void> _getDeviceGuid() async {
    try {
      final String deviceGuid = await platform.invokeMethod('getDeviceGuid');
      setState(() {
        _deviceGuid = deviceGuid;
      });
    } on PlatformException catch (e) {
      print("Failed to get device GUID: ${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getDeviceGuid();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Device GUID: $_deviceGuid'),
    );
  }
}

void main() {
  runApp(MyApp());
}
