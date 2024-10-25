import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/utils/station_database_interface.dart';

class StationCard extends StatefulWidget {
  final Station station;
  final VoidCallback onStationTapped;

  const StationCard({
    super.key,
    required this.station,
    required this.onStationTapped,
  });

  @override
  State<StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        splashColor: primaryColor.withOpacity(0.5),
        onTap: widget.onStationTapped,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 5),
          child: Column(
            children: [
              // Station name and connection state (red for disconnected, green for connected)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      widget.station.name,
                      style: const TextStyle(
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Icon(
                        widget.station.connectionState == "CONNECTÉ"
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: widget.station.connectionState == "CONNECTÉ"
                            ? greenColor
                            : secondaryColor),
                  )
                ],
              ),
              const SizedBox(height: 10),
              // Station address
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 230),
                      child: Text(
                        widget.station.address.toUpperCase(),
                        style: const TextStyle(color: primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Number of bikes present / number of bikes possible (available slots + available bikes)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 55),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_bike_outlined,
                            color: (widget.station.availableSlots +
                                        widget.station.availableBikes) ==
                                    0
                                ? secondaryColor
                                : greenColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.station.availableBikes} / ${(widget.station.availableSlots + widget.station.availableBikes)}",
                            style: TextStyle(
                              color: (widget.station.availableSlots +
                                          widget.station.availableBikes) ==
                                      0
                                  ? secondaryColor
                                  : greenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.station.toggleFavorite();
                        StationDatabaseInterface.instance
                            .updateStation(widget.station);
                      });
                    },
                    icon: Icon(
                      widget.station.isFavoriteStation()
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: secondaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
