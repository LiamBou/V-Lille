import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/widgets/station_marker.dart';
import 'package:v_lille/widgets/station_popup.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.stations});

  final List<Station> stations;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  Station? _selectedStation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _centerMapOnStation(Station station) {
    setState(() {
      _selectedStation = station;
    });
    _mapController.move(LatLng(station.y, station.x), 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      // The map options are used to set the initial center of the map to the center of Lille
      options: const MapOptions(
        initialCenter: LatLng(50.62925, 3.057256),
        minZoom: 11.0,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: widget.stations
              .map(
                (station) => Marker(
                  rotate: true,
                  point: LatLng(station.y, station.x),
                  child: StationMarker(
                      station: station,
                      isSelected: _selectedStation == station,
                      onTap: () => {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StationPopup(station: station);
                                }),
                            _centerMapOnStation(station),
                          }),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
