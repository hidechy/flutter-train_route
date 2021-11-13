import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../models/station.dart';

class TrainRouteScreen extends StatefulWidget {
  final String train_name;
  final String train_number;

  TrainRouteScreen({required this.train_name, required this.train_number});

  @override
  _TrainRouteScreenState createState() => _TrainRouteScreenState();
}

class _TrainRouteScreenState extends State<TrainRouteScreen> {
  late LatLng _latLng;

  Map<String, String> headers = {'content-type': 'application/json'};

  List<Eki> _stationListData = [];

  Set<Marker> _markerSets = {};

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    ///////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getTrainStation";
    String body = json.encode({"train_number": widget.train_number});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    final station = stationFromJson(response.body);
    _stationListData = station.data;
    ///////////////////////////////////

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    _latLng = LatLng(35.7102009, 139.9490672);

    CameraPosition _initialCameraPosition =
        CameraPosition(target: _latLng, zoom: 11);

    for (var i = 0; i < _stationListData.length; i++) {
      _markerSets.add(
        Marker(
          markerId: MarkerId('id-${i}'),
          position: LatLng(
            double.parse(_stationListData[i].lat),
            double.parse(_stationListData[i].lng),
          ),
          infoWindow: InfoWindow(
            title: _stationListData[i].stationName,
            snippet: _stationListData[i].address,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.train_name,
          style: TextStyle(fontSize: 12),
        ),

        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _markerSets,
            ),
          ),
        ],
      ),
    );
  }
}
