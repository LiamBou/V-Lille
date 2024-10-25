import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/widgets/station_card.dart';

// StationList is a widget that displays a list of stations
class StationList extends StatefulWidget {
  final List<Station> stations;
  final Function(Station) onStationTapped;

  const StationList({
    required this.stations,
    super.key,
    required this.onStationTapped,
  });

  @override
  State<StationList> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Station> favoriteStations = widget.stations
        .where((station) => station.isFavoriteStation())
        .toList();
    return Container(
      color: primaryColor,
      // List of stations with a card for each station
      child: Column(
        children: [
          // List of favorite stations
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Favorite stations",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // List of favorite stations
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: favoriteStations.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, right: 5, left: 5),
                      child: StationCard(
                          station: favoriteStations[index],
                          onStationTapped: () =>
                              widget.onStationTapped(favoriteStations[index])),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Other stations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // List of stations
          Expanded(
            child: ListView.builder(
              itemCount: widget.stations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, right: 5, left: 5),
                  child: StationCard(
                      station: widget.stations[index],
                      onStationTapped: () =>
                          widget.onStationTapped(widget.stations[index])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
