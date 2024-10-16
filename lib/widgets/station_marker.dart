import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';

class StationMarker extends StatelessWidget {
  final Station station;
  final bool isSelected;
  final VoidCallback onTap;

  const StationMarker({
    super.key,
    required this.station,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        Icons.directions_bike,
        color: station.connectionState == "CONNECTÉ"
            ? primaryColor
            : secondaryColor,
        size: isSelected ? 40 : 30, // Increase size when selected
      ),
    );
  }
}
