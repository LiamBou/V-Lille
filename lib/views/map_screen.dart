import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/widgets/station_bubble.dart';
import 'package:v_lille/widgets/station_marker.dart';

class MapScreen extends StatefulWidget {
  final List<Station> stations;
  final Function(MapScreenState) onMapCreated;

  const MapScreen(
      {super.key, required this.stations, required this.onMapCreated});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final List<Marker>
      _markers; // List of markers to display on the map, used in the PopupMarkerLayer
  late final MapController _mapController;
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _markers = widget.stations
        .map(
          (station) => StationMarker(
            station: station,
            onTap: () => onMarkerTapped(station),
          ),
        )
        .toList();

    // Notify the parent when the map is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMapCreated(this);
    });
  }

  // Method to zoom and center the map when a marker is tapped
  void onMarkerTapped(Station station) {
    final LatLng position = LatLng(station.y, station.x);
    // Find the marker corresponding to the tapped station
    final Marker tappedMarker = _markers.firstWhere(
      (marker) => marker is StationMarker && marker.station == station,
    );
    // Hide all popups except the one corresponding to the tapped marker and move the map to its position
    _popupLayerController.hidePopupsWhere((marker) => marker != tappedMarker);
    _popupLayerController.togglePopup(tappedMarker);
    _animatedMapMove(position, 15);
  }

  // Method to animate the map movement smoothly
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens  to split the transition between our current map center and the destination
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween =
        Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.linearToEaseOut);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      // The map options are used to set the initial center of the map to the center of Lille
      options: MapOptions(
        initialCenter: const LatLng(50.62925, 3.057256),
        minZoom:
            11.0, // Restrict the zoom level to avoid seeing the whole world; 11 is a good value for Lille
        initialZoom: 13.0,
        onTap: (_, __) => _popupLayerController
            .hideAllPopups(), // Hide all popups when the map is tapped
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        // The PopupMarkerLayer is responsible for displaying the popups
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            popupController: _popupLayerController,
            markers: _markers,
            popupDisplayOptions: PopupDisplayOptions(
              builder: (_, Marker marker) {
                if (marker is StationMarker) {
                  return StationBubble(
                    station: marker.station,
                  );
                }
                return const Card(child: Text('Not a station'));
              },
              // Fade the popup in and out when it is opened and closed
              animation: const PopupAnimation.fade(
                duration: Duration(milliseconds: 400),
              ),
            ),
            // Increase the size of the selected marker
            selectedMarkerBuilder: (context, marker) => const Icon(
              Icons.directions_bike_outlined,
              size: 40,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
