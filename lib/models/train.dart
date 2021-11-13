// To parse this JSON data, do
//
//     final train = trainFromJson(jsonString);

import 'dart:convert';

Train trainFromJson(String str) => Train.fromJson(json.decode(str));

String trainToJson(Train data) => json.encode(data.toJson());

class Train {
  Train({
    required this.data,
  });

  List<Railways> data;

  factory Train.fromJson(Map<String, dynamic> json) => Train(
        data:
            List<Railways>.from(json["data"].map((x) => Railways.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Railways {
  Railways({
    required this.trainNumber,
    required this.trainName,
  });

  String trainNumber;
  String trainName;

  factory Railways.fromJson(Map<String, dynamic> json) => Railways(
        trainNumber: json["train_number"],
        trainName: json["train_name"],
      );

  Map<String, dynamic> toJson() => {
        "train_number": trainNumber,
        "train_name": trainName,
      };
}
