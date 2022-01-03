import 'dart:convert';

import 'package:http/http.dart';

class Weather {
  int temp;
  int tempMax;
  int tempMin;
  String description;
  double lon;
  double lat;
  String icon;
  DateTime time;
  int rainyPercent;
  int humidity;

  Weather(this.temp, this.tempMax, this.tempMin, this.description, this.lon,
      this.lat, this.icon, this.time, this.rainyPercent, this.humidity);

  static String publicParameter =
      '&appid=20dabda8e9b77ce7502ea5882318bea2&lang=ja&units=metric';
  // 現在の天気情報を取得するクラス
  static Future<Weather?> getCurrentWeather(String zipCode) async {
    String _zipCode;
    // 郵便番号にハイフンが含まれている場合は正常に処理する
    if (zipCode.contains('-')) {
      _zipCode = zipCode;
    } else {
      // 郵便番号にハイフンが含まれていない場合は間にハイフンを入れる
      _zipCode = zipCode.substring(0, 3) + '-' + zipCode.substring(3);
    }

    String url =
        'https://api.openweathermap.org/data/2.5/weather?zip=$_zipCode,JP&appid=20dabda8e9b77ce7502ea5882318bea2&lang=ja&units=metric';
    try {
      // urlの取得
      var result = await get(Uri.parse(url));
      Map<String, dynamic> date = jsonDecode(result.body);

      Weather currentWeather = Weather(
          date['main']['temp'].toInt(),
          date['main']['temp_max'].toInt(),
          date['main']['temp_min'].toInt(),
          date['weather'][0]['description'],
          date['coord']['lon'],
          date['coord']['lat'],
          '晴れ',
          DateTime(2020, 10, 2, 12),
          10,
          date['main']['humidity']);
      return currentWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, List<Weather>>?> getForecast(
      double lon, double lat) async {
    Map<String, List<Weather>> response = {};
    String url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=20dabda8e9b77ce7502ea5882318bea2&lang=ja&units=metric';
    try {
      // urlの取得
      var result = await get(Uri.parse(url));
      Map<String, dynamic> date = jsonDecode(result.body);
      List<dynamic> hourlyWeatherDate = date['hourly'];
      List<dynamic> dailyWeatherDate = date['daily'];

      // hourlyWeatherDateに入っている1時間ごとのデータをList<Weather>に格納
      List<Weather> hourlyWeather = hourlyWeatherDate.map((weather) {
        return Weather(
            weather['temp'].toInt(),
            10,
            5,
            'sunny',
            1.0,
            1.0,
            weather['weather'][0]['icon'],
            DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
            1,
            1);
      }).toList();
      List<Weather> dailyWeather = dailyWeatherDate.map((weather) {
        return Weather(
            10,
            weather['temp']['max'].toInt(),
            weather['temp']['min'].toInt(),
            'sunny',
            1.0,
            1.0,
            weather['weather'][0]['icon'],
            DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
            1,
            1);
      }).toList();
      print(dailyWeather[0].time);
      print(dailyWeather[0].icon);
      print(dailyWeather[0].tempMax);
      print(dailyWeather[0].tempMin);
      response['hourly'] = hourlyWeather;
      response['daily'] = dailyWeather;
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
