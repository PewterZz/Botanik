import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Devices extends StatefulWidget {
  final BluetoothDevice? device;

  Devices({this.device});

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  String? _characteristic;

  double soilMoisture = 0.0;
  double temperature = 0.0;
  double humidity = 0.0;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    if (widget.device == null) {
      print("Device is null. Please connect to a device first.");
      return;
    }

    try {
      await widget.device!.connect();
      List<BluetoothService> services = await widget.device!.discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "19b10000-e8f2-537e-4f6c-d104768a1214") {
            setState(() {
              _characteristic = characteristic.uuid.toString();
            });

            await characteristic.setNotifyValue(true);
            characteristic.onValueReceived.listen((value) {
              final receivedData = utf8.decode(value);
              print("Received data: $receivedData");
              _updateSensorData(receivedData);
            });

            return;
          }
        }
      }

      if (_characteristic == null) {
        print("Custom characteristic not found. Check if the device has the required services and characteristics.");
      }
    } catch (e) {
      print("Error initializing Bluetooth: $e");
    }
  }

  void _updateSensorData(String receivedData) {
    final dataLines = receivedData.split('\n'); // Splitting by line breaks

    for (String line in dataLines) {
      final keyValue = line.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim();
        final value = double.tryParse(keyValue[1].trim()) ?? 0.0;

        if (key == 'Soil Moisture') {
          setState(() {
            soilMoisture = value;
          });
        } else if (key == 'Temperature') {
          setState(() {
            temperature = value;
          });
        } else if (key == 'Humidity') {
          setState(() {
            humidity = value;
          });
        }
      }
    }
  }

  Future<BluetoothCharacteristic?> _findCharacteristicByUuid(String uuid) async {
    List<BluetoothService> services = await widget.device!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          return characteristic;
        }
      }
    }
    return null;
  }

  void sendCommandToESP32(String command) async {
    if (_characteristic == null) {
      print("Characteristic UUID not set. Please initialize Bluetooth connection first.");
      return;
    }

    try {
      BluetoothCharacteristic? characteristic = await _findCharacteristicByUuid(_characteristic!);
      if (characteristic == null) {
        print("Characteristic with UUID $_characteristic not found.");
        return;
      }

      final commandBytes = Uint8List.fromList(utf8.encode(command));
      await characteristic.write(commandBytes);
      print("Command sent successfully: $command");
    } catch (e) {
      print("Error sending command: $e");
    }
  }

  @override
  void dispose() {
    widget.device?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Moisture Sensor',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(soilMoisture.toStringAsFixed(2), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text(
              'Temperature',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(temperature.toStringAsFixed(2), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text(
              'Humidity',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(humidity.toStringAsFixed(2), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text(
              'Pump Control',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () => sendCommandToESP32("TURN_ON_PUMP"),
                  icon: const Icon(Icons.water_drop),
                ),
                IconButton(
                  onPressed: () => sendCommandToESP32("TURN_OFF_PUMP"),
                  icon: const Icon(Icons.water_drop_outlined),
                ),
              ],
            ),
            const Text(
              'Light Control',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () => sendCommandToESP32("TURN_ON_LIGHT"),
                  icon: const Icon(Icons.lightbulb),
                ),
                IconButton(
                  onPressed: () => sendCommandToESP32("TURN_OFF_LIGHT"),
                  icon: const Icon(Icons.lightbulb_outline),
                ),
              ],
            ),
            const Text(
              'Bridge Control',
              style: TextStyle(fontSize: 20),
            ),
            IconButton(
              onPressed: () => sendCommandToESP32("TURN_BRIDGE_OFF"),
              icon: const Icon(Icons.power_off),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
