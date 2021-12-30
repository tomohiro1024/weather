import 'dart:convert';

import 'package:http/http.dart';

class ZipCode {
  static Future<Map<String, String>?> searchAddressFromZipCode(
      String zipCode) async {
    String url = 'https://zip-cloud.appspot.com/api/search?zipcode=$zipCode';
    try {
      // urlの取得
      var result = await get(Uri.parse(url));
      // json型をMap型に変換し、かつjsonのbodyを取得
      Map<String, dynamic> date = jsonDecode(result.body);
      Map<String, String> response = {};

      // jsonを取得してエラーが出た場合(7桁以外の数字が入力された場合)
      if (date['message'] != null) {
        response['message'] = '7桁の郵便番号を入力して下さい';
      } else {
        // 存在しない郵便番号等を入力した場合
        if (date['results'] == null) {
          response['message'] = '正しい郵便番号を入力して下さい';
        } else {
          // 正しい郵便番号が入力された場合
          response['address'] = date['results'][0]['address2'];
        }
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
