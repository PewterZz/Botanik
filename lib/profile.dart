import 'package:flutter/material.dart';
import 'devices.dart';

class Profile extends StatelessWidget {
  final TextEditingController wifiSSIDController = TextEditingController();
  final TextEditingController wifiPasswordController = TextEditingController();
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
          ],
        ),
      ),
    );
  }
}
