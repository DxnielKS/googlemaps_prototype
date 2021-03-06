import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:googlemaps_prototype/services/auth.dart';
import 'package:tfl_api_client/tfl_api_client.dart' as tflApi;
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String googleApikey = "AIzaSyAlb2y4PT8shplcLijTaObFr7VwY59U1wo";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(51.5072178, -0.1275862);
  String location = "Search Location";
  Set<Marker> bikeLocations = Set<Marker>();

  Future<void> main1() async {
    final client = tflApi.clientViaAppKey("99446f25adc0404db3f1b7050199442a");

    final api = tflApi.TflApiClient(client: client);
    List<String> bikes = [];
    final response = await api.bikePoints.getAll();
    for (var line in response) {
       // tflApi.BikePointOccupancy? bike_occupancy;
       // var occupancy = await api.occupancies.getBikePointsOccupanciesByPathIds([line.id!]).then((value) {
       //   bike_occupancy = value.first;
       // });
       bikeLocations.add(
           Marker(
             infoWindow: InfoWindow(
                 title: "${line.commonName}",
                 snippet: "${line.additionalProperties![6].value} Bikes Free - "
                     "${line.additionalProperties![7].value} Empty Docks - "
                     "${line.additionalProperties![8].value} Total Docks"
             ),
             markerId: MarkerId('${line.id}'),
             position: LatLng(line.lat!,line.lon!),
             icon: BitmapDescriptor.defaultMarker,
           )
       );
      }
    }
  @override
  void initState()  {
    super.initState();
    main1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Masala Hire'),
            backgroundColor: Colors.blue,
            actions: [
              TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  style: TextButton.styleFrom(primary: Colors.black),
                  icon: Icon(Icons.person),
                  label: Text("Log Out")),
            ]),
        body: Stack(children: [FutureBuilder(future: main1(),
            builder: (context, snapshot) {
          print(bikeLocations.length);
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("there is no connection");

                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: new CircularProgressIndicator());

                case ConnectionState.done:
                  return Text("FINISHED");
              }
            }),
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true,
            //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 10.0, //initial zoom level
            ),
            mapType: MapType.normal,
            markers: bikeLocations,
            //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona;
            },
            onCameraIdle: () async {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude);
              setState(() {
                location = placemarks.first.administrativeArea.toString() +
                    ", " +
                    placemarks.first.street.toString();
              });
            },
          ),

          Center(
            //picker image on google map
            child: Image.asset(
              "assets/picker.png",
              width: 40,
            ),
          ),

          //search autoconplete input
          Positioned(
              //search input bar
              top: 10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'uk')],
                        //google_map_webservice package
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      setState(() {
                        location = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);

                      //move map camera to selected place with animation
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 16)));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  )))
        ]));
  }
}
