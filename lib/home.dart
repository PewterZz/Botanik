import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'devices.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.location,
  ].request();

  print(statuses[Permission.bluetooth]);
  print(statuses[Permission.location]);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ScanResult> devices = [];

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  void _scanForDevices() async {
    await requestPermissions();
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    FlutterBluePlus.startScan(timeout: Duration(seconds: 30));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results.where((result) {
          return result.device.advName != null && result.device.advName.startsWith("Botanik");
        }).toList();
      });
    });
  }

  void _connectToDevice(ScanResult device) {
    FlutterBluePlus.stopScan();
    device.device.connect().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Devices(device: device.device), // Pass the selected device
        ),
      );
    }).catchError((error) {
      // Handle any connection errors here
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Available Devices',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(devices[index].device.advName ?? 'Unknown device'),
                    subtitle: Text('Signal strength: ${devices[index].rssi}'),
                    onTap: () => _connectToDevice(devices[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _scanForDevices,
              child: Text('Rescan Devices'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Devices()), // Pass null to Devices constructor
                );
              },
              child: Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}
