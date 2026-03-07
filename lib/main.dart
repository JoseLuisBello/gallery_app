import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_app/models/pokemon.dart';
import 'package:gallery_app/services/service_pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  final ServicePokemon _servicePokemon = ServicePokemon();
  Future<Pokemon>? _futurePokemon;

  void _buscarPokemon() {
    setState(() {
       _futurePokemon = _servicePokemon.fetchPokemon(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria Pokemon")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nombre de Pokemon ",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarPokemon,
              child: Text("Buscar el pokemon"),
            ),

            SizedBox(height: 20),
            Text("Datos de Pokemón"),
            SizedBox(height: 20),
            _futurePokemon == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Ingresar un nombre"),
                  )
                : Column(
                    children: [
                      FutureBuilder(
                        future: _futurePokemon,
                        builder: (context, datos) {
                          if (datos.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (datos.hasError) {
                            return Center(
                              child: Text(
                                "Pokemon no existe o es un error en la api",
                              ),
                            );
                          }

                          final Pokemon = datos.data!;

                          return SingleChildScrollView(
                            child: Column(
                              children: [Text(Pokemon.name.toLowerCase()),
                              SizedBox(height: 20,),
                              // Image.network(Pokemon.imageURL)
                              SvgPicture.network(Pokemon.imageURL)
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
