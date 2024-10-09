import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';
  bool? serviceRunning;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Location Service'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              locationData('Latitude: $latitude'),
              locationData('Longitude: $longitude'),
              locationData('Altitude: $altitude'),
              locationData('Accuracy: $accuracy'),
              locationData('Bearing: $bearing'),
              locationData('Speed: $speed'),
              locationData('Time: $time'),
              locationData('IsServiceRunning: $serviceRunning'),
              ElevatedButton(
                  onPressed: () async {
                    await BackgroundLocation.setAndroidNotification(
                      title: 'Background service is running',
                      message: 'Background location in progress',
                      icon: '@mipmap/ic_launcher',
                    );
                    //await BackgroundLocation.setAndroidConfiguration(1000);
                    await BackgroundLocation.startLocationService(
                        distanceFilter: 20);
                    BackgroundLocation.getLocationUpdates((location) {
                      setState(() {
                        latitude = location.latitude.toString();
                        longitude = location.longitude.toString();
                        accuracy = location.accuracy.toString();
                        altitude = location.altitude.toString();
                        bearing = location.bearing.toString();
                        speed = location.speed.toString();
                        time = DateTime.fromMillisecondsSinceEpoch(
                                location.time!.toInt())
                            .toString();
                      });
                    });
                  },
                  child: const Text('Start Location Service')),
              ElevatedButton(
                  onPressed: () {
                    BackgroundLocation.stopLocationService();
                  },
                  child: const Text('Stop Location Service')),
              ElevatedButton(
                  onPressed: () {
                    BackgroundLocation.isServiceRunning().then((value) {
                      setState(() {
                        serviceRunning = value;
                      });
                    });
                  },
                  child: const Text('Check service')),
              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: const Text('Get Current Location')),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {});
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
