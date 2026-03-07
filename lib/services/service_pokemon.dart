import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import 'dart:convert';

class ServicePokemon {
    Future <Pokemon> fetchPokemon( String name) async {
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}');

        final resp = await http.get(url);

        if (resp.statusCode == 200){
            final data = json.decode(resp.body);
            return Pokemon.fromJSON(data);
        }else{
            throw Exception("NO se encontro");
        }
    }
}