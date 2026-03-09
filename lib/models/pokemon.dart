class Pokemon {
  final String name;
  final List<String> abilities;
  final List<String> images;

  Pokemon({
    required this.name,
    required this.abilities,
    required this.images,
  });

  factory Pokemon.fromJSON(Map<String, dynamic> json) {
    final abilitiesList = (json['abilities'] as List)
        .map((item) => item['ability']['name'] as String)
        .toList();

    List<String> images = [];
    final sprites = json['sprites'];

    if (sprites['other']['dream_world']['front_default'] != null) {
      images.add(sprites['other']['dream_world']['front_default']);
    }
    if (sprites['other']['official-artwork']['front_default'] != null) {
      images.add(sprites['other']['official-artwork']['front_default']);
    }
    if (sprites['other']['home']['front_default'] != null) {
      images.add(sprites['other']['home']['front_default']);
    }
    if (sprites['other']['home']['front_shiny'] != null) {
      images.add(sprites['other']['home']['front_shiny']);
    }
    if (sprites['front_default'] != null) {
      images.add(sprites['front_default']);
    }
    if (sprites['back_default'] != null) {
      images.add(sprites['back_default']);
    }
    if (sprites['front_shiny'] != null) {
      images.add(sprites['front_shiny']);
    }
    if (sprites['back_shiny'] != null) {
      images.add(sprites['back_shiny']);
    }
    //final image = json['sprites']['other']['dream_world']['front_default'];

    return Pokemon(
      name: json['name'],
      abilities: abilitiesList,
      images: images,
    );
  }
}


/*
{
  'name': "pikachu"
  'abilities': [
    {
      'ability' : {
          'name': 'fire'
        }
    }

  ],

  'sprites': {
    'other': 
      'dreamWorld': {'front_default': url}

  }

}

* */




