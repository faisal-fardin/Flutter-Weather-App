import 'package:flutter/material.dart';
import 'package:flutter_weather_app/model/new_api_model.dart';
import 'package:flutter_weather_app/providers/weather_provider.dart';
import 'package:flutter_weather_app/ui/settings.dart';
import 'package:flutter_weather_app/utlis/const.dart';
import 'package:flutter_weather_app/utlis/helper_functions.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:provider/provider.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({
    super.key,
  });

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  @override
  void didChangeDependencies() {
    Provider.of<WeatherProvider>(context, listen: false).getData();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            return provider.hasDataLoaded
                ? Column(
                    children: [
                      Stack(
                        children: [
                          _currentWeatherSection(provider, context),
                        ],
                      ),
                      _forecastWeatherSection(provider, context),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  Widget _currentWeatherSection(
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

  Widget _forecastWeatherSection(
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
}
