import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../Model/exam.dart';
import '../auth.dart';
import 'navigation_page.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final User? user = Auth().currentUser;

  LatLng? destLocation = LatLng(42.1323, 21.7257);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _address;

  //final Completer<GoogleMapController> _controller = Completer();

  List<Exam> exams = [];
  late DatabaseReference dbRef;
  List<Marker> _markers = <Marker>[];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.1323, 21.7257),
    zoom: 15,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    dbRef = FirebaseDatabase.instance.ref().child('Exams');
    fetchData();
  }

  void fetchData() {
    dbRef.onChildAdded.listen((data) async {
      ExamData examData = ExamData.fromJson(data.snapshot.value as Map);
      Exam exam = Exam(key: data.snapshot.key, examData: examData);
      if (exam.examData!.userId == user!.uid) {
        exams.add(exam);
        List<Marker> examMarkers = await mapExams(exams);
        _markers.addAll(examMarkers);
      }
      setState(() {});
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: GoogleMap(
  //         initialCameraPosition: _kGooglePlex,
  //         mapType: MapType.normal,
  //         zoomControlsEnabled: true,
  //         zoomGesturesEnabled: true,
  //         myLocationButtonEnabled: true,
  //         myLocationEnabled: true,
  //         trafficEnabled: false,
  //         rotateGesturesEnabled: true,
  //         buildingsEnabled: true,
  //         markers: Set<Marker>.of(_markers),
  //         onMapCreated: (GoogleMapController controller) {
  //           _controller.complete(controller);
  //         },
  //       ),
  //     ),
  //   );
  // }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter uber'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => NavigationPage(
                      destLocation!.latitude, destLocation!.longitude),
                ),
                (route) => false);
          }),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onCameraMove: (CameraPosition? position) {
              if (destLocation != position!.target) {
                setState(() {
                  destLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              print('camera idle');
             getAddressFromLatLng();
            },
            onTap: (latLng) {
              print(latLng);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            buildingsEnabled: true,
            markers: Set<Marker>.of(_markers)
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Image.asset(
                'images/pick.png',
                height: 45,
                width: 45,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: Text(_address ?? 'Pick your destination address',
                  overflow: TextOverflow.visible, softWrap: true),
            ),
          ),
        ],
      ),
    );
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: destLocation!.latitude,
          longitude: destLocation!.longitude,
          googleMapApiKey: "AIzaSyDj0-GUvL7OekPB0FIgUIdgAGCPj8eB1es");
      setState(() {
        _address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  getCurrentLocation() async {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  final GoogleMapController? controller = await _controller.future;

  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  if (_permissionGranted == loc.PermissionStatus.granted) {
    location.changeSettings(accuracy: loc.LocationAccuracy.high);

    _currentPosition = await location.getLocation();
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
      zoom: 16,
    )));
    setState(() {
      destLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    });
  }
}

}

Future<List<Marker>> mapExams(List<Exam> exams) async {
  List<Marker> markers = <Marker>[];

  for (Exam exam in exams) {
    String markerId = exam.key!;
    String title = exam.examData!.predmet!;
    LatLng latLng = await getLatLngFromAddress(exam.examData!.address!);

    markers.add(Marker(
        markerId: MarkerId(markerId),
        position: latLng,
        infoWindow: InfoWindow(title: title + " Exam")));
  }

  return markers;
}

Future<LatLng> getLatLngFromAddress(String address) async {
  //final addresses = await Geocoder.local.findAddressesFromQuery(address);
  final addresses = await Geocoder2.getDataFromAddress(
      address: address,
      googleMapApiKey: "AIzaSyDj0-GUvL7OekPB0FIgUIdgAGCPj8eB1es");

  return LatLng(addresses.latitude, addresses.longitude);
}

