import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../services/service_pokemon.dart';
import '../models/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéGallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent.shade700),
        cardTheme: CardThemeData(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
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
    final name = _controller.text.trim().toLowerCase();
    if (name.isEmpty) return;

    setState(() {
      _futurePokemon = _servicePokemon.fetchPokemon(name);
      _currentImage = 0;
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.red.shade100, Colors.white],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Icon(Icons.catching_pokemon, size: 38, color: Colors.redAccent.shade700),
                    const SizedBox(width: 12),
                    const Text(
                      "Galeria de pokemones",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB71C1C), // rojo oscuro
                      ),
                    ),
                  ],
                ),
              ),

              // Buscador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _buscarPokemon(),
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Busca un Pokémon (ej: pikachu)",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.search, color: Colors.redAccent.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red.shade200, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.redAccent.shade400, width: 2.5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: _futurePokemon == null
                    ? _buildEmptyState()
                    : FutureBuilder<Pokemon>(
                        future: _futurePokemon,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return _buildErrorState();
                          }

                          final pokemon = snapshot.data!;
                          return isLandscape
                              ? _buildLandscape(pokemon)
                              : _buildPortrait(pokemon);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.catching_pokemon_outlined, size: 140, color: Colors.red.shade200),
          const SizedBox(height: 24),
          const Text(
            "¡Encuentra tu Pokémon!",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFFB71C1C)),
          ),
          const SizedBox(height: 12),
          Text(
            "Escribe su nombre arriba",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 90, color: Colors.red.shade300),
          const SizedBox(height: 20),
          const Text(
            "No encontramos ese Pokémon",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text("Revisa el nombre o intenta otro", style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildPortrait(Pokemon pokemon) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGallerySection(pokemon),
          const SizedBox(height: 28),
          _buildInfoSection(pokemon),
        ],
      ),
    );
  }

  Widget _buildLandscape(Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _buildGallerySection(pokemon)),
          const SizedBox(width: 40),
          Expanded(flex: 7, child: SingleChildScrollView(child: _buildInfoSection(pokemon))),
        ],
      ),
    );
  }

  Widget _buildGallerySection(Pokemon pokemon) {
    final puedeAtras = _currentImage > 0;
    final puedeAdelante = _currentImage < pokemon.images.length - 1;

    return Card(
      elevation: 10,
      shadowColor: Colors.red.shade200.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 340,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentImage = i),
                itemCount: pokemon.images.length,
                itemBuilder: (_, i) {
                  final url = pokemon.images[i];
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: 1.0,
                    child: url.endsWith('.svg')
                        ? SvgPicture.network(url, fit: BoxFit.contain)
                        : Image.network(url, fit: BoxFit.contain),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navButton(Icons.chevron_left, puedeAtras, true),
                const SizedBox(width: 40),
                Text(
                  "${_currentImage + 1}  /  ${pokemon.images.length}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 40),
                _navButton(Icons.chevron_right, puedeAdelante, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, bool enabled, bool isBack) {
    return IconButton.filledTonal(
      icon: Icon(icon, size: 36),
      style: IconButton.styleFrom(
        backgroundColor: enabled ? Colors.redAccent.shade100 : Colors.grey.shade300,
        foregroundColor: enabled ? Colors.red.shade900 : Colors.grey.shade600,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: enabled
          ? () {
              if (isBack) {
                _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
              } else {
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
              }
            }
          : null,
    );
  }

  Widget _buildInfoSection(Pokemon pokemon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: Color(0xFFB71C1C),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        const SizedBox(height: 32),

        const Text(
          "Habilidades",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: WrapAlignment.center,
          children: pokemon.abilities.map((ability) {
            return Card(
              elevation: 4,
              shadowColor: Colors.red.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  ability.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              color: Colors.redAccent.shade400,
            );
          }).toList(),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }
}