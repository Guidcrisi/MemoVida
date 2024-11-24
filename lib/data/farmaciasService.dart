import 'dart:convert';
import 'package:http/http.dart' as http;

class FarmaciasService {
  static getFarmacias() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Guidcrisi/memovida-data-json/refs/heads/main/farmacias.json'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar JSON');
    }
  }
}
