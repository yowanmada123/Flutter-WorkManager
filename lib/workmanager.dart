import 'package:backgroundfetch2/geolocator.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerFunction {
  static sendData() {
    // print("HIII THERE");
    GeolocatorFunction.getGeoLocationPosition();
  }

  static const task = 'firstTask';

  static void callBackDispatcher() {
    Workmanager().executeTask((taskName, inputData) {
      switch (taskName) {
        case 'firstTask':
          sendData();

          break;

        default:
      }
      return Future.value(true);
    });
  }
}
