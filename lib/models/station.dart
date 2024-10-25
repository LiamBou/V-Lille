class Station {
  final int id;
  final String name;
  final String address;
  final String type;
  final int availableSlots;
  final int availableBikes;
  final String connectionState;
  final double x;
  final double y;
  final String lastUpdate;
  int isFavorite;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.availableSlots,
    required this.availableBikes,
    required this.connectionState,
    required this.x,
    required this.y,
    required this.lastUpdate,
    required this.isFavorite,
  });

  // Factory method to create a Station object from a JSON object
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: int.parse(json['@id'] as String),
      name: json['nom'] as String,
      address: json['adresse'] as String,
      type: json['type'] as String,
      availableSlots: json['nb_places_dispo'] as int,
      availableBikes: json['nb_velos_dispo'] as int,
      connectionState: json['etat_connexion'] as String,
      x: json['x'] as double,
      y: json['y'] as double,
      lastUpdate: json['date_modification'] as String,
      isFavorite: 0,
    );
  }

  // Method to convert a Station object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type,
      'availableSlots': availableSlots,
      'availableBikes': availableBikes,
      'connectionState': connectionState,
      'x': x,
      'y': y,
      'lastUpdate': lastUpdate,
      'isFavorite': isFavorite,
    };
  }

  // Factory method to create a Station object from a Map object
  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      type: map['type'],
      availableSlots: map['availableSlots'],
      availableBikes: map['availableBikes'],
      connectionState: map['connectionState'],
      x: map['x'],
      y: map['y'],
      lastUpdate: map['lastUpdate'],
      isFavorite: map['isFavorite'],
    );
  }

  // Method to display the Station object as a String
  @override
  String toString() {
    return 'Station{id: $id, name: $name, address: $address, type: $type, availableSlots: $availableSlots, availableBikes: $availableBikes, connectionState: $connectionState, x: $x, y: $y, lastUpdate: $lastUpdate, isFavorite: $isFavorite}';
  }

  // Method to check if the Station object is a favorite station
  bool isFavoriteStation() {
    return isFavorite == 1;
  }

  // Method to toggle the favorite status of the Station object
  void toggleFavorite() {
    isFavorite = isFavorite == 0 ? 1 : 0;
  }

  // Method to check if two Station objects are equal
  bool equals(Station other) {
    return id == other.id &&
        name == other.name &&
        address == other.address &&
        type == other.type &&
        availableSlots == other.availableSlots &&
        availableBikes == other.availableBikes &&
        connectionState == other.connectionState &&
        x == other.x &&
        y == other.y &&
        lastUpdate == other.lastUpdate &&
        isFavorite == other.isFavorite;
  }
}
