import 'package:aestethicweatherapp/models/weather_model.dart';
import 'package:aestethicweatherapp/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API Key
  final _weatherService = WeatherService('df9b5b0bd86d85db4237cf006393c631');
  Weather? _weather;

  //Fetch Weather
  _fetchWeather() async {
    // Pegar a cidade atual
    String cityName = await _weatherService.getCurrentCity();

    //Pegar o clima da cidade
    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Animações de clima
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'sunny':
      case 'mist':
      case 'smoke':
      case 'thunder':
      case 'haze':
      case 'night':
      case 'snow':
      case 'fog':
      //   return 'assets/rain.json';
      // case 'drizzle':
      // case 'thunderstorm':
      default:
        return 'assets/rain.json';
    }
  }

  // Estado inicial da aplicação
  @override
  void initState() {
    super.initState();

    //Puxar o clima ao iniciar a aplicação;
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        const Color.fromARGB(255, 45, 57, 66); // Cor de fundo padrão
    if (_weather != null) {
      // Defina as cores com base nas condições climáticas
      if (_weather!.mainCondition == 'sunny') {
        backgroundColor = Colors.lightBlue; // Cor para clima ensolarado
      } else if (_weather!.mainCondition == 'night') {
        backgroundColor = Colors.grey; // Cor para clima chuvoso
      }
    }

    return Scaffold(
      body: Container(
        color:
            backgroundColor, // Define a cor de fundo com base na condição climática
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nome da cidade
              Text(
                _weather?.cityName ?? "Procurando cidade...",
                style: const TextStyle(
                  fontSize: 24.0, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.white, // Cor do texto
                ),
              ),

              // Animações
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              // Temperatura
              Text(
                '${_weather?.temperature.round()}°C',
                style: const TextStyle(
                  fontSize: 36.0, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.white, // Cor do texto
                ),
              ),

              // Animação de acordo com o clima
              Text(
                _weather?.mainCondition ?? "",
                style: const TextStyle(
                  fontSize: 18.0, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.white, // Cor do texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
