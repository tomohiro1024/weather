import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather2/weather.dart';
import 'package:weather2/zip_code.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  // 現在の天気
  Weather? currentWeather;

  String? address = 'ー';

  String? errorMessage;

  List<Weather>? hourlyWeather;

  // 日毎の天気を表示させるためのリスト
  List<Weather>? dailyWeather;

  List<String> weekDay = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                width: 250,
                child: TextField(
                  onSubmitted: (value) async {
                    Map<String, String> response = {};
                    // 郵便番号から住所を検索
                    response = (await ZipCode.searchAddressFromZipCode(value))!;
                    // responseの'message'というキーに値が入ってきた(エラーが出た)場合に入ってくる変数
                    errorMessage = response['message'];
                    // responseの'address'というキーが含んでいた場合、変数addressに'address'の値を入れる
                    if (response.containsKey('address')) {
                      address = response['address'];
                      currentWeather = await Weather.getCurrentWeather(value);
                      Map<String, List<Weather>>? weatherForcast =
                          await Weather.getForecast(
                              currentWeather!.lon, currentWeather!.lat);
                      hourlyWeather = weatherForcast!['hourly'];
                      dailyWeather = weatherForcast!['daily'];
                    }

                    // addressの値が'ー'からvalueに入ってきた値になるため更新が必要
                    // setStateはビルドがもう一度実行される
                    setState(() {});
                  },
                  decoration: InputDecoration(hintText: '郵便番号を入力して下さい'),
                )),
            // errorMessageに値が入っていない(エラーじゃない)場合何も表示しない
            // errorMessageに値が入ってきた(エラー)場合、エラーメッセージを表示する
            Text(
              errorMessage == null ? '' : errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              address!,
              style: TextStyle(fontSize: 23),
            ),
            Text(currentWeather == null ? 'ー' : currentWeather!.description),
            Text(
              currentWeather == null ? 'ー' : '${currentWeather!.temp}°',
              style: TextStyle(fontSize: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(currentWeather == null
                      ? '最高気温:ー'
                      : '最高気温: ${currentWeather!.tempMax}°'),
                ),
                Text(currentWeather == null
                    ? '最低気温:ー'
                    : '最低気温: ${currentWeather!.tempMin}°'),
              ],
            ),
            SizedBox(height: 20),
            Divider(height: 0),
            SingleChildScrollView(
              // 横にリストをスワイプさせる
              scrollDirection: Axis.horizontal,
              child: hourlyWeather == null
                  ? Container()
                  : Row(
                      children: hourlyWeather!.map(
                        (weather) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Column(
                              children: [
                                Text(
                                    '${DateFormat('H').format(weather.time)}時'),
                                Image.network(
                                  'https://openweathermap.org/img/wn/${weather.icon}.png',
                                  width: 29,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('${weather.temp}°',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
            ),
            Divider(height: 0),
            dailyWeather == null
                ? Container()
                : Expanded(
                    // 縦にスクロールさせる
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: dailyWeather!.map((weather) {
                            return Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 50,
                                      child: Text(
                                          '${weekDay[weather.time.weekday - 1]}曜日')),
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${weather.icon}.png',
                                    width: 29,
                                  ),
                                  Container(
                                    width: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${weather.tempMax}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          '${weather.tempMin}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
