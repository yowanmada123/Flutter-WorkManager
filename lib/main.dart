import 'package:backgroundfetch2/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import './workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    WorkManagerFunction.callBackDispatcher,
    isInDebugMode: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String location = 'Belum Mendapatkan Lat dan long, Silahkan tekan button';
  String address = 'Mencari lokasi...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Work Manager & Geolocator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: TextButton(
                  onPressed: () {
                    var uniqueId = DateTime.now().second.toString();
                    // await Workmanager().registerOneOffTask(
                    //   uniqueId, task,
                    //   initialDelay: const Duration(seconds: 10),
                    //   constraints: Constraints(networkType: NetworkType.connected),
                    // );
                    Workmanager().registerPeriodicTask(uniqueId, WorkManagerFunction.task, frequency: const Duration(minutes: 15), constraints: Constraints(networkType: NetworkType.connected));
                  },
                  child: const Text(
                    "Schedule Task",
                    style: TextStyle(fontSize: 20),
                  ))),
          ElevatedButton(
            child: const Text("Cancel All"),
            onPressed: () async {
              await Workmanager().cancelAll();
              print('Cancel all tasks completed');
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Koordinat Point',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Center(child: Text('${address}')),
                ElevatedButton(
                  onPressed: () async {
                    Position position = await GeolocatorFunction.getGeoLocationPosition();
                    Placemark place = await GeolocatorFunction.getAddressFromLongLat(position);
                    setState(() {
                      location = '${position.latitude}, ${position.longitude}';
                      address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                    });
                  },
                  child: const Text('Get Koordinat'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
