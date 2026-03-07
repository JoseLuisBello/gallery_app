class Pokemon {
  final String name;
  final List<String> abilities;
  final String imageURL;

  Pokemon({
    required this.name,
    required this.abilities,
    required this.imageURL
  });

  factory Pokemon.fromJSON(Map<String, dynamic> json){
    final abilitiesList = (json['abilities'] as List)
      .map((item) => item['ability']['name'] as String)
      .toList();

    final image = json['sprites']['other']['dream_world']['front_default'];

    return Pokemon(name: json['name'], abilities: abilitiesList, imageURL: image);

  }

}