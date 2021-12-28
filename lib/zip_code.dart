import 'dart:convert';

import 'package:http/http.dart';

class ZipCode {
  static Future<List<String>?> searchAddressFromZipCode(String zipCode) async {
    String url = 'https://zip-cloud.appspot.com/api/search?zipcode=$zipCode';
    try {
      // urlの取得
      var result = await get(Uri.parse(url));
      // json型をMap型に変換
      Map<String, dynamic> date = jsonDecode(result.body);

      List<String> address = [
        date['results'][0]['address2'],
        date['results'][0]['address3']
      ];
      return address;
      // String address = date['results'][0]['address2'];
      // return address;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
