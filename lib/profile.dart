import 'package:flutter/material.dart';
import 'devices.dart';

class Profile extends StatelessWidget {
  final TextEditingController wifiSSIDController = TextEditingController();
  final TextEditingController wifiPasswordController = TextEditingController();

  void _sendCredentials(BuildContext context) {
    final ssid = wifiSSIDController.text;
    final password = wifiPasswordController.text;

    // Send the SSID and password over Bluetooth to the ESP32 device
    // Use the BluetoothSerial.write method or any other suitable method
    // Make sure the ESP32 code is set up to receive and process these values.

    // Example of showing a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Credentials Sent'),
          content: Text('SSID: $ssid\nPassword: $password'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: wifiSSIDController,
              decoration: InputDecoration(
                labelText: 'WIFI SSID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: wifiPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'WIFI Password',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendCredentials(context),
              child: Text('Send Credentials'),
            ),
          ],
        ),
      ),
    );
  }
}
