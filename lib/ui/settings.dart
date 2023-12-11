import 'package:flutter/material.dart';
import 'package:flutter_weather_app/providers/weather_provider.dart';
import 'package:flutter_weather_app/utlis/helper_functions.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool status  = false;

  @override
  void initState() {
    getTempUnitStatus().then((value){
      setState(() {
        status =value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show Temperature in Fahrenheit',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Default is Celsius',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            value: status,
            onChanged: (value) async{
              setState(() {
                status = value;
              });
              await setTempUnitStatus(status);
              Provider.of<WeatherProvider>(context ,listen: false).getData();
            },
          ),
        ],
      ),
    );
  }
}
