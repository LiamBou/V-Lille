import 'dart:convert';

import 'package:v_lille/models/station.dart';
import 'package:http/http.dart' as http;
import 'package:v_lille/utils/station_database_interface.dart';

class StationApiInterface {
  static final StationApiInterface instance = StationApiInterface._internal();

  StationApiInterface._internal();

  Future<List<Station>> fetchStations() async {
    final response = await http.get(Uri.parse(
        'https://data.lillemetropole.fr/data/ogcapi/collections/vlille_temps_reel/items?f=json&limit=-1'));
    if (response.statusCode == 200) {
      final jsonResponse =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final stations = jsonResponse['records'];
      if (stations.isNotEmpty) {
        // Fetch the stations from the API
        List<Station> fetchedStations = List<Station>.from(stations.map(
            (station) => Station.fromJson(station as Map<String, dynamic>)));

        // Save the fetched stations to the database
        await StationDatabaseInterface.instance.insertStations(fetchedStations);

        return fetchedStations;
      } else {
        throw Exception('Failed to load stations');
      }
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<void> refreshStations() async {
    List<Station> fetchedStations = await fetchStations();
    List<Station> existingStations =
        await StationDatabaseInterface.instance.stations;

    // Update or insert the existing stations with the fetched stations without changing the favorite status
    for (Station fetchedStation in fetchedStations) {
      Station existingStation = existingStations.firstWhere(
        (station) => station.id == fetchedStation.id,
        orElse: () => fetchedStation,
      );
      if (existingStation.isFavorite == 1) {
        fetchedStation.isFavorite = 1;
        if (!existingStation.equals(fetchedStation)) {
          await StationDatabaseInterface.instance.updateStation(fetchedStation);
        }
      }
    }
  }
}
