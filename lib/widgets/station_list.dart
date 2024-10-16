import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/widgets/station_card.dart';

class StationList extends StatelessWidget {
  final List<Station> stations;

  const StationList({required this.stations, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, right: 5, left: 5),
            child: StationCard(station: stations[index]),
          );
        },
      ),
    );
  }
}
