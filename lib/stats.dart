import 'package:flutter/material.dart';
import 'chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsScreen extends StatefulWidget {
  StatsScreen({Key key}) : super(key: key);

  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Estadísticas",
              style: TextStyle(color: Colors.black87, fontFamily: "Raleway")),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white10,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text("Temperatura",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontFamily: "Raleway")),
            Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: double.infinity,
                child: GridlineDashPattern(createSampleData())),
            SizedBox(height: 100),
            Text("Humedad",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontFamily: "Raleway")),
            Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: double.infinity,
                child: GridlineDashPattern(createSampleData())),
          ],
        )));
  }

  getDataCharts() async {
    String url = 'http://192.168.1.74/WSArduino/raspino.php?type=graphs';

    final response = await http.get(url);
    final data = json.decode(response.body).cast<Map<dynamic, dynamic>>();
  }

  static List<charts.Series<MyRow, DateTime>> createSampleData() {
    final data = [
      new MyRow(new DateTime(2017, 9, 25), 6),
      new MyRow(new DateTime(2017, 9, 26), 8),
      new MyRow(new DateTime(2017, 9, 27), 6),
      new MyRow(new DateTime(2017, 9, 28), 9),
      new MyRow(new DateTime(2017, 9, 29), 11),
      new MyRow(new DateTime(2017, 9, 30), 15),
      new MyRow(new DateTime(2017, 10, 01), 25),
      new MyRow(new DateTime(2017, 10, 02), 33),
      new MyRow(new DateTime(2017, 10, 03), 27),
      new MyRow(new DateTime(2017, 10, 04), 31),
      new MyRow(new DateTime(2017, 10, 05), 23),
    ];

    return [
      new charts.Series<MyRow, DateTime>(
        id: 'Cost',
        domainFn: (MyRow row, _) => row.timeStamp,
        measureFn: (MyRow row, _) => row.cost,
        data: data,
      )
    ];
  }

}

class PinoData {
  final DateTime time;
  final int data;

  PinoData(this.time, this.data);
}

class Pino {
  String humedad;
  String temperatura;
  String fecha_info;

  Pino({this.humedad, this.temperatura, this.fecha_info});

  Map toJson() {
    var data = new Map<String, dynamic>();
    data["humedad"] = humedad;
    data["temperatura"] = temperatura;
    data["fecha_info"] = fecha_info;
    return data;
  }

  factory Pino.fromJson(Map<String, dynamic> json) {
    return Pino(
      humedad: json['humedad'],
      temperatura: json['temperatura'],
      fecha_info: json['fecha_info'],
    );
  }
}
