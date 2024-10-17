import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';

class StationBubble extends StatelessWidget {
  final Station station;

  const StationBubble({super.key, required this.station});

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
                  station.name,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.wifi,
                color: station.connectionState == "CONNECTÉ"
                    ? greenColor
                    : secondaryColor,
              ),
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
                  station.address.toUpperCase(),
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
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Station type (always "Avec tpe" if the station is connected)
          Row(
            children: [
              const Icon(Icons.credit_score, color: primaryColor),
              const SizedBox(width: 5),
              Text(station.type, style: const TextStyle(color: primaryColor)),
            ],
          ),
          const SizedBox(height: 5),
          // Last update date
          Row(
            children: [
              const Icon(Icons.update, color: primaryColor),
              const SizedBox(width: 5),
              Text(
                station.lastUpdate,
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
