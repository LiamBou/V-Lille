import 'package:flutter/cupertino.dart';
import 'package:v_lille/models/station.dart';

class StationModel extends ChangeNotifier {
  static List<Station> stations = <Station>[];
  static List<Station> favoriteStations = <Station>[];

  void addFavorite(Station station) {
    favoriteStations.add(station);
    notifyListeners();
    print(favoriteStations);
  }

  void removeFavorite(Station station) {
    favoriteStations.remove(station);
    notifyListeners();
  }

  bool isFavorite(Station station) {
    return favoriteStations.contains(station);
  }

  void toggleFavorite(Station station) {
    if (isFavorite(station)) {
      removeFavorite(station);
    } else {
      addFavorite(station);
    }
  }
}
