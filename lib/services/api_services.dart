import 'dart:convert';

import "package:http/http.dart"as http;


import '../consts/strings.dart';
import '../models/current_weather_model.dart';
import '../models/days_forcast_model.dart';

// var link ="https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
// var daysForcastLink="https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

 getCurrentWeather(lat,long) async{
  var link="https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var res=await http.get(Uri.parse(link));


  if (res.statusCode==200){
    // var data=jsonDecode(res.body.toString());
    var data = currentWeatherDataFromJson(res.body.toString());
    print("Data is recived");

    return data;
  }
}

getDaysWeather(lat ,long)async{
  var daysForcastLink="https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var res1=await http.get(Uri.parse(daysForcastLink));

  if(res1.statusCode==200){
    var daysData=hourlyWeatherDataFromJson(res1.body.toString());
    return daysData;
  }
}