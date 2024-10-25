# v_lille

A Flutter application that allows users to easily locate a place where they can obtain or return a bike in Lille using the open data portal of MEL, which provides data on V'Lille stations.

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- Android Studio: [Download Android Studio](https://developer.android.com/studio)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/LiamBou/v_lille.git
   cd v_lille
   ```
2. Install dependencies:
   ```sh
    flutter pub get
    ```
3. Run the application:
   ```sh
   flutter run
   ```

## Project Structure

- `lib/`: Contains the Dart source code of the application.
  - `main.dart`: The entry point of the application.
  - `models/`: Contains the data models of the application.
  - `utils/`: Contains utility classes and functions.
  - `widgets/`: Contains the custom widgets of the application.
  - `views/`: Contains the views of the application.

## Features

1. Fetching Real-Time Data: 
   - The application fetches real-time data of V'Lille stations using the MEL open data portal. This is done through the `StationApiInterface` class, which makes HTTP requests to retrieve station data.
2. Displaying Stations on a Map:
    - The application displays the fetched stations on a map. This is handled in the `MapScreen` widget, which uses the `flutter_map` package to render the map and markers for each station.
3. Search Functionality:
    - Users can search for specific stations using a search bar. The search functionality is implemented using the `StationSearchDelegate` class, which allows users to search and select stations.
4. Favorite Stations:
    - Users can mark stations as favorites. The favorite status is preserved even when the station data is refreshed. This is managed in the `refreshStations` method of the `StationApiInterface` class, which ensures that the favorite status is not lost during data updates.
5. Local Database Storage:
    - The application uses a local database to store station data. This is managed by the `StationDatabaseInterface` class, which handles inserting and updating station records in the database.

## Dependencies

- `http`: For making HTTP requests to fetch station data.
- `flutter_map`: For rendering the map and markers for stations.
- `latlong`: For handling latitude and longitude coordinates.
- `flutter_map_marker_popup`: For displaying popups when a station marker is tapped.
- `sqflite` and `path`: For managing the local database storage of station data.
- `get`: For managing state and dependency injection in the application.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.
