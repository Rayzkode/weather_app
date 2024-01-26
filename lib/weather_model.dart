class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double feels;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final int pressure;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.feels,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      feels: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: json['wind']['speed'].toDouble(),
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      pressure: json['main']['pressure'],
    );
  }
}
