import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';

// Marker for a station
class StationMarker extends Marker {
  final Station station;
  final VoidCallback? onTap;

  StationMarker({required this.station, this.onTap})
      : super(
          alignment: Alignment.center,
          point: LatLng(station.y, station.x),
          child: GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.directions_bike_outlined,
              size: 30,
              color: primaryColor,
            ),
          ),
        );
}
