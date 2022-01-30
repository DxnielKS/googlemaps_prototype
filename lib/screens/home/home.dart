
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaps_prototype/services/auth.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(51.509865,-0.118092);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Masala Hire'),
          backgroundColor: Colors.blue,
            actions: [
            TextButton.icon(
            onPressed: () async{
      await _auth.signOut();
      },
          style: TextButton.styleFrom(
              primary: Colors.black
          ),
          icon: Icon(Icons.person),
          label: Text("Log Out")),]
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}