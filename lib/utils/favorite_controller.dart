import 'package:v_lille/models/station.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:v_lille/models/station_model.dart';

// Notifier for the favorite stations using get_storage to store the favorite stations's ids
class FavoriteController extends GetxController {
  final List<Station> favoriteStations = <Station>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final List<int> favoriteIds = storage.read('favorite_stations') ?? <int>[];
    favoriteStations.addAll(
      favoriteIds.map((id) =>
          StationModel.stations.firstWhere((station) => station.id == id)),
    );
    print(favoriteStations);
  }

  // Method to add a station to the favorite stations
  void addFavorite(Station station) {
    favoriteStations.add(station);
    storage.write('favorite_stations',
        favoriteStations.map((station) => station.id).toList());
  }

  // Method to remove a station from the favorite stations
  void removeFavorite(Station station) {
    favoriteStations.remove(station);
    storage.write('favorite_stations',
        favoriteStations.map((station) => station.id).toList());
  }

  // Method to check if a station is a favorite
  bool isFavorite(Station station) {
    return favoriteStations.contains(station);
  }

  void toggleFavorite(Station station) {
    if (isFavorite(station)) {
      removeFavorite(station);
    } else {
      addFavorite(station);
    }
    print("Favorite stations: $favoriteStations");
  }
}
