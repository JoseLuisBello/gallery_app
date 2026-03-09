import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ServicePokemon {
  Future<Pokemon> fetchPokemon(String name) async {
    // se define la URL
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}',
    );

    // se obtiene el recurso asíncrono
    final resp = await http.get(url);

    // regresa la respuesta
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return Pokemon.fromJSON(data);
    } else {
      throw Exception("No se encontró");
    }
  }
}
