import 'dart:ffi';

import 'package:clima_app/weather_model.dart';
import 'package:clima_app/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key, this.title});

  final String? title;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('444ba8cafa3b35713fd11b2a69d89806');
  Weather? _weather;
  TimeOfDay now = TimeOfDay.now();

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    List valores = await _weatherService.getLatLong();

    try {
      final weather = await _weatherService.getWeather(valores[0], valores[1]);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //Animaciones
  String getWeatherAnimaiton(String? mainCoindition) {
    if (mainCoindition == null) return 'assets/Loading.json';
    switch (mainCoindition.toLowerCase()) {
      case 'mist':
        return 'assets/Mist.json';
      case 'clouds':
        return 'assets/Cloud.json';
      case 'smoke':
      case 'storm':
        return 'assets/Storm.json';
      case 'fog':
      case 'rain':
        return 'assets/Rainny_Day.json';
      case 'clear':
        if (now.hour >= 18) {
          return 'assets/Moon.json';
        } else {
          return 'assets/Sunny.json';
        }
      default:
        return '';
    }
  }

  String getWelcome() {
    if (now.hour < 12) {
      return "BUENOS DIAS";
    } else if (now.hour < 18) {
      return "BUENAS TARDES";
    } else {
      return "BUENAS NOCHES :)";
    }
  }

  LinearGradient getTimeColor() {
    if (now.hour > 5 && now.hour < 12) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(160, 21, 180, 219),
          Color.fromARGB(160, 125, 229, 255),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (now.hour < 18) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(159, 255, 155, 15),
          Color.fromARGB(160, 255, 206, 85),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(160, 18, 21, 88),
          Color.fromARGB(160, 37, 42, 166),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 70),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: now.hour < 18
                  ? const AssetImage("images/tl-1.png")
                  : const AssetImage("images/tl.png"),
              fit: BoxFit.none),
          gradient: getTimeColor(),
        ),
        child: Center(
          child: _weather?.cityName == null
              ? Lottie.asset('assets/Loading.json')
              : Column(
                  children: [
                    Text(
                      "${getWelcome()}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  children: [
                                    Text(
                                      '${_weather?.temperature.round() ?? 0}°C',
                                      style: const TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const Padding(padding: EdgeInsets.all(4)),
                                    Text(
                                      "${_weather?.mainCondition}",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    const Padding(padding: EdgeInsets.all(4)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${_weather?.cityName}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.all(1)),
                                        const Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.all(4)),
                                    const Text(
                                      "Sensacion termica",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              145, 255, 255, 255)),
                                    ),
                                    Text(
                                      "${_weather?.feels}°C",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              145, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Lottie.asset(getWeatherAnimaiton(
                                    _weather?.mainCondition)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    gradient: getTimeColor(),
                                    borderRadius: BorderRadius.circular(
                                        20.0) // Ajusta el radio según sea necesario
                                    ),
                                padding: const EdgeInsets.all(20.0),
                                clipBehavior: Clip.antiAlias,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/sunrise.png",
                                            width: 30,
                                            color: Colors.white,
                                          ),
                                          const Text(
                                            "Amanecer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            _weather?.sunrise == null
                                                ? ""
                                                : "${DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(_weather!.sunrise * 1000))} AM",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/sunset.png",
                                            width: 30,
                                            color: Colors.white,
                                          ),
                                          const Text(
                                            "Atardecer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            _weather?.sunset == null
                                                ? ""
                                                : "${DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(_weather!.sunset * 1000))} PM",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    gradient: getTimeColor(),
                                    borderRadius: BorderRadius.circular(
                                        20.0) // Ajusta el radio según sea necesario
                                    ),
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/icons/drop.png",
                                        width: 25,
                                        color: Colors.white,
                                      ),
                                      const Text(
                                        "Humedad",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${_weather?.humidity}%",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    gradient: getTimeColor(),
                                    borderRadius: BorderRadius.circular(
                                        20.0) // Ajusta el radio según sea necesario
                                    ),
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/icons/wind.png",
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                      const Text(
                                        "Viento",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${_weather?.windSpeed} km/h",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    gradient: getTimeColor(),
                                    borderRadius: BorderRadius.circular(
                                        20.0) // Ajusta el radio según sea necesario
                                    ),
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      //The APi doesnt give the UV lol
                                      Image.asset(
                                        "assets/icons/sunny.png",
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                      const Text(
                                        "Indice UV",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        "Bajo",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
