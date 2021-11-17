import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../models/train.dart';

import '../screens/train_route_screen.dart';

import '../utility/utility.dart';

class TrainListScreen extends StatefulWidget {
  const TrainListScreen({Key? key}) : super(key: key);

  @override
  _TrainListScreenState createState() => _TrainListScreenState();
}

class _TrainListScreenState extends State<TrainListScreen> {
  Map<String, String> headers = {'content-type': 'application/json'};

  List<Railways> _trainListData = [];

  bool _isLoading = false;

  final Utility _utility = Utility();

  final List<String> _selectedList = [];

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
              const SizedBox(
                height: 40,
              ),
              _trainList(context, _trainListData),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goTrainRouteScreen(),
                  child: const Text('google map'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent.withOpacity(0.8),
                  ),
                ),
              ),
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
                    color: _getSelectedBgColor(
                        trainNumber: _trainListData[index].trainNumber),
                    child: ListTile(
                      title: DefaultTextStyle(
                        style: const TextStyle(fontSize: 12),
                        child: Text(_trainListData[index].trainName),
                      ),
                      onTap: () => _addSelectedAry(
                          trainNumber: _trainListData[index].trainNumber),
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

  ///
  void _addSelectedAry({trainNumber}) {
    if (_selectedList.contains(trainNumber)) {
      _selectedList.remove(trainNumber);
    } else {
      _selectedList.add(trainNumber);
    }

    setState(() {});
  }

  ///
  Color _getSelectedBgColor({trainNumber}) {
    if (_selectedList.contains(trainNumber)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.3);
    }
  }

  ////////////////////////

  ///
  void _goTrainRouteScreen() {
    if (_selectedList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainRouteScreen(
            trainNumberList: _selectedList,
          ),
        ),
      );
    }
  }
}
