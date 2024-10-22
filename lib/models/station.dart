class Station {
  int? id;
  final String name;
  final String address;
  final String type;
  final int availableSlots;
  final int availableBikes;
  final String connectionState;
  final double x;
  final double y;
  final String lastUpdate;
  bool? isFavorite;

  Station({
    this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.availableSlots,
    required this.availableBikes,
    required this.connectionState,
    required this.x,
    required this.y,
    required this.lastUpdate,
    this.isFavorite,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['nom'] as String,
      address: json['adresse'] as String,
      type: json['type'] as String,
      availableSlots: json['nb_places_dispo'] as int,
      availableBikes: json['nb_velos_dispo'] as int,
      connectionState: json['etat_connexion'] as String,
      x: json['x'] as double,
      y: json['y'] as double,
      lastUpdate: json['date_modification'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '@id': id,
      'nom': name,
      'adresse': address,
      'type': type,
      'nb_places_dispo': availableSlots,
      'nb_velos_dispo': availableBikes,
      'etat_connexion': connectionState,
      'x': x,
      'y': y,
      'date_modification': lastUpdate,
    };
  }

  @override
  String toString() {
    return 'Station{id: $id, name: $name, address: $address, type: $type, availableSlots: $availableSlots, availableBikes: $availableBikes, connectionState: $connectionState, x: $x, y: $y, lastUpdate: $lastUpdate}';
  }
}
