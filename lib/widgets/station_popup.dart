import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';

class StationPopup extends StatelessWidget {
  const StationPopup({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              station.name,
              style: const TextStyle(
                color: primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Icon(Icons.wifi,
                color: station.connectionState == "CONNECTÉ"
                    ? greenColor
                    : secondaryColor),
          )
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: primaryColor,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(station.address.toUpperCase(),
                    style: const TextStyle(color: primaryColor)),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.directions_bike_outlined,
                color: (station.availableSlots + station.availableBikes) == 0
                    ? secondaryColor
                    : greenColor,
              ),
              const SizedBox(width: 5),
              Text(
                "${station.availableBikes} / ${(station.availableSlots + station.availableBikes)}",
                style: TextStyle(
                  color: (station.availableSlots + station.availableBikes) == 0
                      ? secondaryColor
                      : greenColor,
                ),
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.payment_outlined, color: primaryColor),
              const SizedBox(width: 5),
              Text(station.type, style: const TextStyle(color: primaryColor)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.update, color: primaryColor),
              const SizedBox(width: 5),
              Text(station.lastUpdate,
                  style: const TextStyle(color: primaryColor)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close", style: TextStyle(color: primaryColor)),
        ),
      ],
    );
  }
}

/**/
