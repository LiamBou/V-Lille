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

  @override
  void initState() {
    super.initState();

    futureStation = fetchStations();
  }

  Future<List<Station>> fetchStations() async {
    // https://data.lillemetropole.fr/data/ogcapi/collections/vlille_temps_reel/items?f=geojson&limit=-1
    var uri = Uri.https(
        'data.lillemetropole.fr',
        '/data/ogcapi/collections/vlille_temps_reel/items',
        {'f': 'json', 'limit': '-1'});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final records = jsonResponse['records'];
      if (records.isNotEmpty) {
        /*setState(() {
          stations = List<Station>.from(records.map(
              (record) => Station.fromJson(record as Map<String, dynamic>)));
        });*/
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
                  onPressed: () => showSearch(
                    context: context,
                    delegate: StationSearchDelegate(
                        stations: snapshot.data as List<Station>),
                  ),
                );
              } else {
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
      body: FutureBuilder(
        future: futureStation,
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            return MapScreen(stations: snapshot.data as List<Station>);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
