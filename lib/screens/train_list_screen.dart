import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../models/train.dart';

import '../screens/train_route_screen.dart';

import '../utility/utility.dart';

class TrainListScreen extends StatefulWidget {
  @override
  _TrainListScreenState createState() => _TrainListScreenState();
}

class _TrainListScreenState extends State<TrainListScreen> {
  Map<String, String> headers = {'content-type': 'application/json'};

  List<Railways> _trainListData = [];

  bool _isLoading = false;

  Utility _utility = Utility();

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    ///////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getTrain";
    Response response = await post(Uri.parse(url), headers: headers);
    final train = trainFromJson(response.body);
    _trainListData = train.data;
    ///////////////////////////////////

    setState(() {
      _isLoading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          Column(
            children: [
              SizedBox(
                height: 40,
              ),
              _trainList(context, _trainListData),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _trainList(context, _trainDataList) {
    return Expanded(
      child: (_isLoading)
          ? MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.black.withOpacity(0.3),
                    child: ListTile(
                      title: DefaultTextStyle(
                        style: TextStyle(fontSize: 12),
                        child: Text(_trainListData[index].trainName),
                      ),
                      onTap: () => _goTrainRouteScreen(
                        train_name: _trainListData[index].trainName,
                        train_number: _trainListData[index].trainNumber,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 0.2),
                itemCount: _trainListData.length,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  ////////////////////////

  ///
  void _goTrainRouteScreen(
      {required String train_name, required String train_number}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainRouteScreen(
          train_name: train_name,
          train_number: train_number,
        ),
      ),
    );
  }
}
