import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Devices extends StatelessWidget {
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
              'First Page',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () async {
                // check if bluetooth is supported by your hardware
// Note: The platform is initialized on the first call to any FlutterBluePlus method.
                if (await FlutterBluePlus.isSupported == false) {
                  print("Bluetooth not supported by this device");
                  return;
                }

// handle bluetooth on & off
// note: for iOS the initial state is typically BluetoothAdapterState.unknown
// note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
                FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
                  print(state);
                  if (state == BluetoothAdapterState.on) {
                    // usually start scanning, connecting, etc
                    var subscription = FlutterBluePlus.scanResults.listen((results) {
                      if (results.isNotEmpty) {
                        ScanResult r = results.last; // the most recently found device
                        print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
                      }
                    },
                        // onError(e) => print(e);
                  );

// Start scanning
                  await FlutterBluePlus.startScan();

// Stop scanning
                  await FlutterBluePlus.stopScan();
                  } else {
                    // show an error to the user, etc
                  }
                });

              },
              child: Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}
