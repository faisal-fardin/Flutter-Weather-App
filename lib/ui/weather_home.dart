import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_weather_app/providers/weather_provider.dart';
import 'package:flutter_weather_app/ui/settings.dart';
import 'package:flutter_weather_app/utlis/const.dart';
import 'package:provider/provider.dart';

import '../utlis/helper_functions.dart';
import 'home_ui_method.dart';

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
          IconButton(
              onPressed: () async{
                final result = await showSearch(context: context, delegate: _citySearchDelegate()) as String ;
                if(result.isNotEmpty){
                  EasyLoading.show(status: 'Please wait');
                  if(mounted){
                    await Provider.of<WeatherProvider>(context, listen: false).convertCityToLatLog(result);
                  }
                  if(mounted){
                    final status = await Provider.of<WeatherProvider>(context, listen: false)
                        .convertCityToLatLog(result);
                    EasyLoading.dismiss();
                    if (status == LocationConversionStatus.failed) {
                      showMsg(context, 'Could not find data');
                    }
                  }
                }
              }, icon: const Icon(Icons.search)),
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
                          currentWeatherSection(provider, context),
                        ],
                      ),
                      forecastWeatherSection(provider, context),
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
}

class _citySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      title: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty
        ? cities
        : cities
        .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = filteredList[index];
          close(context, query);
        },
        title: Text(filteredList[index]),
      ),
    );
  }
}
