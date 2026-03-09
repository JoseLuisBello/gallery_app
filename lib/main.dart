import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../services/service_pokemon.dart';

import 'models/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 125, 183, 58))),
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
  final PageController _pageController = PageController();

  Future<Pokemon>? _futurePokemon;
  int _currentImage = 0;

  void _buscarPokemon() {
    setState(() {
      _futurePokemon = _servicePokemon.fetchPokemon(_controller.text);
      _currentImage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria de pokemones", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),),),
      body: SafeArea(
        child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                labelText: "Nombre de pokemon",
                prefixIcon: Icon(Icons.catching_pokemon),
                filled: true,
                fillColor: Colors.white,
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.green, width: 2)
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.greenAccent, width: 3)
              ),
            ),
          ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _buscarPokemon,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                elevation: 8,
              ),
              child: Icon(Icons.search, size: 40, color: Colors.white)
            ),

            SizedBox(height: 20),
            Text("Datos de pokemon", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
            SizedBox(height: 20),
            Expanded(
              child: _futurePokemon == null
                  ? Center(
                      child: Text("Ingresar un nombre", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                    )
                  : FutureBuilder(
                        future: _futurePokemon,
                        builder: (context, datos) {
                          if (datos.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (datos.hasError) {
                            return Center(
                              child: Text(
                                "Pokemon no existe o un error en la API",
                              ),
                            );
                          }

                          final pokemon = datos.data!;

                          return LayoutBuilder(
                            builder: (context, constraints) {

                              bool horizontal = MediaQuery.of(context).orientation == Orientation.landscape;
                              bool puedeIrAtras = _currentImage > 0;
                              bool puedeIrAdelante = _currentImage < pokemon.images.length - 1;

                              Widget galeria = SizedBox(
                                width: horizontal ? 300 : MediaQuery.of(context).size.width * 0.6,
                                height: horizontal ? 300 : MediaQuery.of(context).size.width * 0.6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentImage = index;
                                      });
                                    },
                                    itemCount: pokemon.images.length,
                                    itemBuilder: (context, index) {
                                      final image = pokemon.images[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: image.endsWith('.svg')
                                            ? SvgPicture.network(image, fit: BoxFit.contain)
                                            : Image.network(image, fit: BoxFit.contain),
                                      );
                                    },
                                  ),
                                ),
                              );

                              Widget info = Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    pokemon.name.toUpperCase(),
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${_currentImage + 1} / ${pokemon.images.length}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back_ios_new, color: puedeIrAtras ? Colors.green : Colors.grey),
                                        onPressed: puedeIrAtras 
                                          ? () {
                                            _pageController.previousPage(
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                        }
                                          : null,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward_ios, color: puedeIrAdelante ? Colors.green : Colors.grey),
                                        onPressed: puedeIrAdelante ? 
                                          () {
                                            _pageController.nextPage(
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                        }
                                          : null,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Habilidades:",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: pokemon.abilities
                                            .map((ability) => 
                                            Chip(
                                              avatar: Icon(Icons.flash_on, color: Colors.white, size: 18),
                                              label: Text(ability,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),),
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              elevation: 4,
                                            ))
                                            .toList(),
                                      ),
                                    
                                  ),
                                ],
                              );

                              if (horizontal) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Center(child: galeria),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      flex: 6,
                                      child: SingleChildScrollView(
                                        child: info,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      galeria,
                                      SizedBox(height: 20),
                                      info,
                                    ],
                                  ),
                                );

                              }
                            },
                          );
                          //return CircularProgressIndicator();
                        },
                      ),
            ),   
          ],
        ),
      ),
      ),
      ),
    );
  }
}
