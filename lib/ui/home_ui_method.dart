import 'package:flutter/material.dart';

import '../providers/weather_provider.dart';
import '../utlis/const.dart';
import '../utlis/helper_functions.dart';

Widget currentWeatherSection(
    WeatherProvider provider, BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        height: 355,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '${provider.currentWeather!.name}, ${provider.currentWeather!.sys!.country}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getFormattedDateTime(provider.currentWeather!.dt!),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white10,
                      ),
                      child: Image.network(
                        '$iconUrlPrefix${provider.currentWeather!.weather![0].icon}$iconUrlSuffix',
                        width: 70,
                        height: 70,
                        color: Colors.amber,
                      )),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${provider.currentWeather!.main!.temp!.toStringAsFixed(0)}$degree${provider.unitSymbol}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 80,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        provider.currentWeather!.weather![0].description!,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Feels Like',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${provider.currentWeather!.main!.feelsLike!.toStringAsFixed(0)}$degree',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Wind',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${provider.currentWeather!.wind!.speed!} km/h',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Humidity',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${provider.currentWeather!.main!.humidity!}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Visibility',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${provider.currentWeather!.visibility}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Weather by Hours',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
    ],
  );
}

Widget forecastWeatherSection(
    WeatherProvider provider, BuildContext context) {
  final forecastItemList = provider.forecastWeather!.list!;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
        itemCount: forecastItemList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = forecastItemList[index];
          return Card(
            color: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      getFormattedDateTime(item.dt!, patten: 'EE HH:mm'),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Image.network(
                      '$iconUrlPrefix${item.weather![0].icon}$iconUrlSuffix',
                      width: 70,
                      height: 70,
                      color: Colors.amber,
                    ),
                    Text(
                      '${item.main!.tempMax!.toStringAsFixed(1)}'
                          '/ ${item.main!.tempMin!.toStringAsFixed(0)}$degree${provider.unitSymbol} ',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.weather![0].description!,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
