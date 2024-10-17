import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:v_lille/models/station.dart';
import 'package:v_lille/utils/colors.dart';
import 'package:v_lille/utils/station_search_delegate.dart';
import 'package:http/http.dart' as http;
import 'package:v_lille/views/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "V'Lille",
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(title: "V'Lille by Liam"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Station>> futureStation;
  MapScreenState? mapScreenState;

  @override
  void initState() {
    super.initState();
    futureStation = fetchStations();
  }

  Future<List<Station>> fetchStations() async {
    // Fetch the station data from the API
    // https://data.lillemetropole.fr/data/ogcapi/collections/vlille_temps_reel/items?f=geojson&limit=-1
    var uri = Uri.https(
        'data.lillemetropole.fr',
        '/data/ogcapi/collections/vlille_temps_reel/items',
        {'f': 'json', 'limit': '-1'});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // Decode the response to avoid any encoding issues
      final jsonResponse =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      // The records are the stations
      final records = jsonResponse['records'];
      if (records.isNotEmpty) {
        return List<Station>.from(records
            .map((record) => Station.fromJson(record as Map<String, dynamic>)));
      } else {
        throw Exception('No records found');
      }
    } else {
      throw Exception('Failed to load station');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          // Search button
          FutureBuilder(
            future: futureStation,
            builder: (builder, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      List<Station> stations = snapshot.data as List<Station>;
                      // Show the search delegate
                      showSearch(
                        context: context,
                        delegate: StationSearchDelegate(
                          stations: stations,
                          onStationTapped: (station) {
                            // Trigger the map to zoom into the selected station
                            if (mapScreenState != null) {
                              mapScreenState!.onMarkerTapped(station);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      );
                    });
              } else {
                // Show a dialog if the data is not loaded yet; shouldn't happen if the API is up and the user has an internet connection
                return IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            child: Text('Data not loaded yet'),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      // Show the map screen with the stations once the data is loaded
      body: FutureBuilder(
        future: futureStation,
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            return MapScreen(
              stations: snapshot.data as List<Station>,
              onMapCreated: (state) {
                mapScreenState = state; // Assign the map screen state
              },
            );
          } else {
            // Show a loading indicator while the data is being fetched
            return const Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          }
        },
      ),
    );
  }
}
