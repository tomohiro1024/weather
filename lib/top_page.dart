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
  Weather currentWeather =
      Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 12), 10);

  String? address = 'ー';

  String? errorMessage;

  List<Weather> hourlyWeather = [
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 10), 10),
    Weather(16, 20, 10, '曇り', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 11), 20),
    Weather(17, 20, 10, '雨', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 12), 30),
    Weather(18, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 13), 40),
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 10), 10),
    Weather(16, 20, 10, '曇り', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 11), 20),
    Weather(17, 20, 10, '雨', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 12), 30),
    Weather(18, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 13), 40),
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 10), 10),
    Weather(16, 20, 10, '曇り', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 11), 20),
    Weather(17, 20, 10, '雨', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 12), 30),
    Weather(18, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2020, 10, 2, 13), 40),
  ];

  // 日毎の天気を表示させるためのリスト
  List<Weather> dailyWeather = [
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 1), 10),
    Weather(15, 21, 11, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 2), 10),
    Weather(15, 22, 12, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 3), 10),
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 1), 10),
    Weather(15, 21, 11, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 2), 10),
    Weather(15, 22, 12, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 3), 10),
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 1), 10),
    Weather(15, 21, 11, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 2), 10),
    Weather(15, 22, 12, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 3), 10),
    Weather(15, 20, 10, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 1), 10),
    Weather(15, 21, 11, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 2), 10),
    Weather(15, 22, 12, '晴れ', 1.0, 1.0, '晴れ', DateTime(2021, 10, 3), 10),
  ];

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
                    await Weather.getCurrentWeather(value);
                    // responseの'message'というキーに値が入ってきた(エラーが出た)場合に入ってくる変数
                    errorMessage = response['message'];
                    // responseの'address'というキーが含んでいた場合、変数addressに'address'の値を入れる
                    if (response.containsKey('address')) {
                      address = response['address'];
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
            SizedBox(height: 25),
            Text(
              address!,
              style: TextStyle(fontSize: 23),
            ),
            Text(currentWeather.description),
            Text(
              '${currentWeather.temp}°',
              style: TextStyle(fontSize: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('最高:${currentWeather.tempMax}°'),
                ),
                Text('最低:${currentWeather.tempMin}°'),
              ],
            ),
            SizedBox(height: 25),
            Divider(height: 0),
            SingleChildScrollView(
              // 横にリストをスワイプさせる
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hourlyWeather.map(
                  (weather) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Column(
                        children: [
                          Text('${DateFormat('H').format(weather.time)}時'),
                          Text('${weather.rainyPercent}%',
                              style: TextStyle(color: Colors.blueAccent)),
                          Icon(Icons.wb_sunny),
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
            Expanded(
              // 縦にスクロールさせる
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: dailyWeather.map((weather) {
                      return Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 50,
                                child: Text(
                                    '${weekDay[weather.time.weekday - 1]}曜日')),
                            Row(
                              children: [
                                Icon(Icons.wb_sunny),
                                Text('${weather.rainyPercent}%',
                                    style: TextStyle(color: Colors.blueAccent)),
                              ],
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
                                      color: Colors.black.withOpacity(0.5),
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
