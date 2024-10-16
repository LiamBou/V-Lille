import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';

import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/widgets/station_popup.dart';

/// Station json example
/// "@id": "1",
//       "nom": "METROPOLE EUROPEENNE DE LILLE",
//       "adresse": "MEL RUE DU BALLON",
//       "code_insee": null,
//       "commune": "LILLE",
//       "etat": "RÉFORMÉ",
//       "type": "AVEC TPE",
//       "nb_places_dispo": 0,
//       "nb_velos_dispo": 0,
//       "etat_connexion": "DÉCONNECTÉ",
//       "x": 3.075992,
//       "y": 50.641926,
//       "date_modification": "2022-11-29T10:47:16.181+00:00"

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        splashColor: primaryColor.withOpacity(0.5),
        onTap: () {
          // Show a pop-up with the station details
          showDialog(
            context: context,
            builder: (context) {
              return StationPopup(station: station);
            },
          );
        },
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
              // Station name and color based on connection status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: primaryColor,
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
              const SizedBox(height: 10), // Spacing between elements
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
                        station.address.toUpperCase(),
                        style: const TextStyle(color: primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bike_outlined,
                    color:
                        (station.availableSlots + station.availableBikes) == 0
                            ? secondaryColor
                            : greenColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${station.availableBikes} / ${(station.availableSlots + station.availableBikes)}",
                    style: TextStyle(
                      color:
                          (station.availableSlots + station.availableBikes) == 0
                              ? secondaryColor
                              : greenColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
