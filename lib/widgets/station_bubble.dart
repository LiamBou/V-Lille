import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/utils/station_database_interface.dart';

class StationBubble extends StatefulWidget {
  final Station station;

  const StationBubble({
    super.key,
    required this.station,
  });

  @override
  State<StationBubble> createState() => _StationBubbleState();
}

class _StationBubbleState extends State<StationBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Station name and connection state (red for disconnected, green for connected)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.station.name,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                  widget.station.connectionState == "CONNECTÉ"
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: widget.station.connectionState == "CONNECTÉ"
                      ? greenColor
                      : secondaryColor)
            ],
          ),
          const SizedBox(height: 5),
          // Station address
          Row(
            children: [
              const Icon(Icons.location_on, color: primaryColor),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.station.address.toUpperCase(),
                  style: const TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Number of bikes present / number of bikes possible (available slots + available bikes)
          Row(
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
          const SizedBox(height: 5),
          // Station type (always "Avec tpe" if the station is connected)
          Row(
            children: [
              const Icon(Icons.credit_score, color: primaryColor),
              const SizedBox(width: 5),
              Text(widget.station.type,
                  style: const TextStyle(color: primaryColor)),
            ],
          ),
          const SizedBox(height: 5),
          // Last update date
          Row(
            children: [
              const Icon(Icons.update, color: primaryColor),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.station.lastUpdate,
                  style: const TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      widget.station.toggleFavorite();
                    });
                    await StationDatabaseInterface.instance
                        .insertStation(widget.station);
                  },
                  // Check if the station is a favorite to display the right icon
                  icon: Icon(
                      widget.station.isFavoriteStation()
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: secondaryColor))
            ],
          )
        ],
      ),
    );
  }
}
