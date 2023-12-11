
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_weather_app/model/current_weather.dart';
import 'package:flutter_weather_app/model/forecast_weather.dart';
import 'package:flutter_weather_app/utlis/const.dart';
import 'package:flutter_weather_app/utlis/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart'as geo;
import 'package:geolocator/geolocator.dart';
import '../model/new_api_model.dart';


enum LocationConversionStatus {
  success, failed,
}


class  WeatherProvider extends ChangeNotifier{

  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;
  WeatherModel? weatherModel;

  String unit = metric;
  double latitude = 23.7104;
  double longitude = 90.4074;
  String unitSymbol = celsius;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/';

  bool shouldGetLocationFromCity = false;
  bool get hasDataLoaded => currentWeather != null && forecastWeather != null;


  Future<void> getData() async{
    if(!shouldGetLocationFromCity){
      final position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
    }
    await _getCurrentData();
    await _getForecastData();
  }

  Future<void> getTempUnitFromPref() async {
    final status = await getTempUnitStatus();
    unit = status ? imperial : metric;
    unitSymbol = status ? fahrenheit : celsius;
  }


  Future<void> _getCurrentData() async{
    await getTempUnitFromPref();
    final enUrl='weather?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=$unit';
    final url = Uri.parse('$baseUrl$enUrl');
    try{
      final http.Response response = await http.get(url);
      final json = jsonDecode(response.body);
      if(response.statusCode == 200){
        currentWeather = CurrentWeather.fromJson(json);
        notifyListeners();
      }else{
        print(json['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getForecastData() async{
    await getTempUnitFromPref();
    final enUrl = 'forecast?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=$unit';
    final url = Uri.parse('$baseUrl$enUrl');
    try{
      final http.Response response = await http.get(url);
      final json = jsonDecode(response.body);
      if(response.statusCode == 200){
        forecastWeather = ForecastWeather.fromJson(json);
        notifyListeners();
      }else{
        print(json['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future<LocationConversionStatus> convertCityToLatLog(String city) async {
    try {
      final locationList = await geo.locationFromAddress(city);
      if(locationList.isNotEmpty) {
        final location = locationList.first;
        latitude = location.latitude;
        longitude = location.longitude;
        shouldGetLocationFromCity = true;
        getData();
        return LocationConversionStatus.success;
      } else {
        return LocationConversionStatus.failed;
      }
    } catch (error) {
      print(error.toString());
      return LocationConversionStatus.failed;
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


}



//
// Future<NetworkResponse> getRequest(String url) async {
//   try {
//     Response response = await get(Uri.parse(url),headers: {
//       'token' : AuthUtility.userInfo.token.toString()
//     });
//     log(response.statusCode.toString());
//     log(response.body);
//     if (response.statusCode == 200) {
//       return NetworkResponse(
//           true, response.statusCode, jsonDecode(response.body));
//     } else if (response.statusCode == 401) {
//       _gotoLogin();
//     } else {
//       return NetworkResponse(false, response.statusCode, null);
//     }
//   } catch (e) {
//     log(e.toString());
//   }
//   return NetworkResponse(false, -1, null);
// }