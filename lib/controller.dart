import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import "package:get/get.dart";
import 'package:pak_weather/services/api_services.dart';

class MainController extends GetxController{

  @override

  void onInit()async{
    await getUserLocation();
    currentWeatherData=getCurrentWeather(latitude.value,longitude.value);
    daysWeatherData=getDaysWeather(latitude.value,longitude.value);

    super.onInit();
  }

  var isDark=false.obs;
  var currentWeatherData;
  var daysWeatherData;

  var latitude=0.0.obs;
  var longitude=0.0.obs;

  var isLoaded=false.obs;
  //initiating function for toggle effect

  changeTheme(){
    isDark.value=!isDark.value;
    Get.changeThemeMode(isDark.value? ThemeMode.dark:ThemeMode.light);
  }

  getUserLocation()async{

    bool isLocationEnabled;
    LocationPermission userPermission;
    isLocationEnabled=await Geolocator.isLocationServiceEnabled();
    if(!isLocationEnabled){
      return Future.error("Location is not enabled");

    }
    userPermission=await Geolocator.checkPermission();
    if (userPermission==LocationPermission.deniedForever){
      return Future.error("Permission is denied forever");}
      else if (userPermission==LocationPermission.denied){
        userPermission= await Geolocator.requestPermission();
        if (userPermission==LocationPermission.denied){
          return Future.error("Permission denied");

        }
      }
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value){
        latitude.value=value.latitude;
        longitude.value=value.longitude;
        isLoaded.value=true;
      });
    }
  }

