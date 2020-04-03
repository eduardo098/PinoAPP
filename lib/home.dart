import 'package:flutter/material.dart';
import 'stats.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String temp = '';
  String hum = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
    const duration = const Duration(seconds: 5);
    // _fetchData() is your function to fetch data
    new Timer.periodic(duration, (Timer t) => getData());
  }

  @override
  Widget build(BuildContext context) {

    /*
    const duration = const Duration(seconds: 5);
    // _fetchData() is your function to fetch data
    new Timer.periodic(duration, (Timer t) => getData());*/

    return Scaffold(
        appBar: AppBar(
          title: Text("PINO",
              style: TextStyle(color: Colors.black87, fontFamily: "Raleway")),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white10,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: new Center(
          child: new Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomPaint(
                child: Column(
                  children: <Widget>[
                    Text((temp == '') ? 'Error' : temp + "° C",
                        style: TextStyle(fontFamily: "RaleWay", fontSize: 60)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Temperatura",
                        style: TextStyle(fontFamily: "Raleway", fontSize: 20)),
                  ],
                ),
                painter: ShapesPainter(color: Colors.lightGreen[100]),
              ),
              SizedBox(
                height: 200,
              ),
              CustomPaint(
                child: Column(
                  children: <Widget>[
                    Text((hum == '') ? 'Error' : hum + " %",
                        style: TextStyle(fontFamily: "RaleWay", fontSize: 60)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Humedad",
                        style: TextStyle(fontFamily: "Raleway", fontSize: 20)),
                  ],
                ),
                painter: ShapesPainter(color: Colors.lightBlue[100]),
              ),
              SizedBox(
                height: 100,
              ),
              ButtonTheme(
                height: 50,
                minWidth: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.lightGreen[200],
                  child: const Text(
                    "Ver estadísticas",
                    style: TextStyle(color: Colors.black54, fontFamily: "Raleway"),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatsScreen()),
                    );
                  },
                ),
              ),
            ],
          )),
        ));
  }

  Future<List> getData() {
  String url = 'http://192.168.1.74/WSArduino/raspino.php?type=stats';

  return http.get(url).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception ("Error obteniendo los datos");
    } else {
      List l = json.decode(response.body);

      String newHum = l[0]["humedad"].toString();
      String newTemp = l[0]["temperatura"].toString();

      setState(() {
        hum = newHum;
        temp = newTemp;    
      });
    }
  });
  
  }
  
}


class ShapesPainter extends CustomPainter {
  Color color;

  ShapesPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = color;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(center, 120.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
