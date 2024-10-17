import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/widgets/station_card.dart';

class StationList extends StatelessWidget {
  final List<Station> stations;
  final Function(Station) onStationTapped;

  const StationList(
      {required this.stations, super.key, required this.onStationTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      // List of stations with a card for each station
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, right: 5, left: 5),
            child: StationCard(
                station: stations[index],
                onStationTapped: () => onStationTapped(stations[index])),
          );
        },
      ),
    );
  }
}
