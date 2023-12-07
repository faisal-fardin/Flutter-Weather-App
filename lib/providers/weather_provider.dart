
import 'package:flutter/foundation.dart';
import 'package:flutter_weather_app/model/current_weather.dart';
import 'package:flutter_weather_app/model/forecast_weather.dart';
import 'package:flutter_weather_app/utlis/const.dart';
import 'package:http/http.dart';

class  WeatherProvider extends ChangeNotifier{

  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;

  String unit = metric;
  double latitude = 23.7104;
  double longitude = 90.4074;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/';

  Future<void> _getCurrentData() async{

    final enUrl = 'weather?lat=$latitude&lon=$longitude&appid=$weatherApiKey%units=$unit';
    final url = Uri.parse('$baseUrl$enUrl');

    try{
      final Response response = await get(url,headers: {});
    } catch (e) {

    }


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