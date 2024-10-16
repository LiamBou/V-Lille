class Station {
  /* EXAMPLE JSON:
  {
  "type": "Feature",
  "@typeName": "vlille_temps_reel",
  "@id": "1",
  "geometry": {
  "type": "Point",
  "@name": "geom",
  "@srs": "EPSG:4326",
  "coordinates": [3.075992, 50.641926]
  },
  "properties": {
  "nom": "METROPOLE EUROPEENNE DE LILLE",
  "adresse": "MEL RUE DU BALLON",
  "code_insee": null,
  "commune": "LILLE",
  "etat": "RÉFORMÉ",
  "type": "AVEC TPE",
  "nb_places_dispo": 0,
  "nb_velos_dispo": 0,
  "etat_connexion": "DÉCONNECTÉ",
  "x": 3.075992,
  "y": 50.641926,
  "date_modification": "2022-11-29T10:47:16.181+00:00"
  }
  },*/

  // I only selected the fields that I need

  final String id;
  final String name;
  final String address;
  final String state;
  final String type;
  final int availableSlots;
  final int availableBikes;
  final String connectionState;
  final double x;
  final double y;
  final String lastUpdate;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.state,
    required this.type,
    required this.availableSlots,
    required this.availableBikes,
    required this.connectionState,
    required this.x,
    required this.y,
    required this.lastUpdate,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '@id': String id,
        'nom': String name,
        'adresse': String address,
        'etat': String state,
        'type': String type,
        'nb_places_dispo': int availableSlots,
        'nb_velos_dispo': int availableBikes,
        'etat_connexion': String connectionState,
        'x': double x,
        'y': double y,
        'date_modification': String lastUpdate,
      } =>
        Station(
          id: id,
          name: name,
          address: address,
          state: state,
          type: type,
          availableSlots: availableSlots,
          availableBikes: availableBikes,
          connectionState: connectionState,
          x: x,
          y: y,
          lastUpdate: lastUpdate,
        ),
      _ => throw const FormatException('Failed to load Station'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      '@id': id,
      'nom': name,
      'adresse': address,
      'etat': state,
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
    return 'Station{id: $id, name: $name, address: $address, state: $state, type: $type, availableSlots: $availableSlots, availableBikes: $availableBikes, connectionState: $connectionState, x: $x, y: $y, lastUpdate: $lastUpdate}';
  }
}
