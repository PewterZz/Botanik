import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Devices extends StatefulWidget {
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Devices> {
  bool isMoisture = false;
  bool isHumidity = false;
  bool isLightOn = false;
  bool isRelayOn = false;

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
            Text(isMoisture.toString(), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text(
              'Humidity',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(isHumidity.toString(), style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text(
              'Light',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            ToggleButtons(
              children: [
                IconButton(
                    onPressed: () => {
                          setState(() {
                            isLightOn = true;
                          })
                        },
                    icon: const Text("On")),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            isLightOn = false;
                          })
                        },
                    icon: const Text("Off"))
              ],
              isSelected: [true, false],
            ),
            const SizedBox(height: 20),
            const Text(
              'Time',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 20),
            const Text(
              'Relay',
              style: TextStyle(fontSize: 20),
            ),
            ToggleButtons(
              children: [
                IconButton(
                    onPressed: () => {
                          setState(() {
                            isRelayOn = true;
                          })
                        },
                    icon: const Text("On")),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            isRelayOn = false;
                          })
                        },
                    icon: const Text("Off"))
              ],
              isSelected: [true, false],
            ),
            // const ToggleButtons(children: children, isSelected: isSelected),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
