import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const key='0cf3f441124f6cfd5a224cbc4bb21e74';
//final String url='https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={$key}';

void main() {
  runApp(
    const Weather()
  );
}

class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0x1F2049FF),
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title:const Center(child: Text("Today's Weather",style: TextStyle(fontSize: 28,color:Colors.white60),)),
        ),
        body: const SafeArea(
          child: HomePage(),
        ),
      )
    );
  }
}

dynamic latitude,longitude;
Future<void> getCurrentLocation() async {
  try {
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    print('lat=$latitude');
    print('lon=$longitude');
  } catch (e) {
    print(e);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cityName="";
  String temp="";
  Future<void> updateUI () async{
    print("Here");
    await getCurrentLocation();
    //var url=Uri.http('samples.openweathermap.org','/data/2.5/weather?q=London&mode=html&appid=b6907d289e10d714a6e88b30761fae22');
    var url=Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$key&units=metric');
    try{
      http.Response res=await http.get(url);
      print(res.statusCode);
      print(res.body);
      var jsonWeather=await jsonDecode(res.body);
      temp=jsonWeather['main']['temp'].toString();
      print("temp=$temp");
      cityName=jsonWeather['name'];
      print("city=$cityName");
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //textBaseline: TextBaseline.ideographic,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(45),
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.white12,),
          height: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.baseline,
            //textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(temp,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white70)),
              const Text('\u1d3c',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white70)),
              const Text('C',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white70)),
              ],
          ),
          ),
        Container(
          margin: const EdgeInsets.all(45),
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.white12,),
          height: 180,
          width: 90,
          child: Center(child:Text(cityName,style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white70))),
        ),
        TextButton(
          onPressed: () async{
            print("Location button pressed");
            //getCurrentLocation();
            await updateUI();
            setState((){
              temp;
              cityName;
            });
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0,20,0,0),
            color: Colors.green[300],
            child: const Center(child: Text("Set Location",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white70))),
            height: 70,
          ),
        )
      ],
    );
  }
}

