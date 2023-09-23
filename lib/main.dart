

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pak_weather/controller.dart';
import 'package:pak_weather/models/current_weather_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "../themes.dart";
import 'consts/colors.dart';
import 'consts/images.dart';
import 'consts/strings.dart';
import 'models/days_forcast_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pak-Weather-1.1',
      theme:customTheme.lightTheme,
      darkTheme:customTheme.darkTheme,
      themeMode:ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const PakWeather(),
    );
  }
}

class PakWeather extends StatefulWidget {
  const PakWeather({super.key});

  @override
  State<PakWeather> createState() => _PakWeatherState();
}

class _PakWeatherState extends State<PakWeather> {
  @override
  Widget build(BuildContext context) {
    var date=DateFormat("yyyy.MMM.dd hh:mmaaa").format(DateTime.now());
    var theme=Theme.of(context);
    
    var controller=Get.put(MainController());

    return Scaffold(
      appBar: AppBar(
        title:date.text.color(theme.primaryColor).semiBold.make(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(()=> IconButton(onPressed: (){controller.changeTheme();}, icon:Icon(controller.isDark.value? Icons.light_mode:Icons.dark_mode ),color:theme.iconTheme.color,)),
          IconButton(onPressed: (){}, icon:Icon(Icons.more_vert),color:theme.iconTheme.color,),
        ],
      ),
      body: Obx(()=>controller.isLoaded.value==true?
        Container(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder(
            future:controller.currentWeatherData,
            builder:(BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                PakCurrentWeatherData data = snapshot.data;
                
                
                return SingleChildScrollView (
              physics: BouncingScrollPhysics(),
              child: Container(
                padding:EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    "${data.name}".text.fontFamily("poppins_bold").size(32).color(theme.primaryColor).letterSpacing(3).make(),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/weather/${data.weather![0].icon}.png",
                        width:80,height:80,),
                    Flexible(
                      child: RichText(
                      
                          text:TextSpan(
                            children:[
                            TextSpan(text:"${data.main!.temp}$degree",style:TextStyle(color:theme.primaryColor,fontSize:58
                            ,fontFamily:"poppins",),),
                            TextSpan(text:"C",style:TextStyle(color:theme.primaryColor,fontSize:55,fontFamily:"poppins",),),
                            TextSpan(text:"${data.weather![0].main}",style:TextStyle(color:theme.primaryColor,fontSize:18,fontFamily:"poppins_light",letterSpacing:3,),),
                            ],),),
                    ),]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            TextButton.icon(onPressed: null, icon: Icon(Icons.expand_less_rounded,color:Vx.gray400),
                            label:"${data.main!.tempMax}$degree C".text.color(theme.primaryColor).make(),),
                            TextButton.icon(onPressed: null,icon:Icon(Icons.expand_more_rounded,color:Vx.gray400),
                            label:"${data.main!.tempMin}$degree C".text.color(theme.primaryColor).make(),),
                          ],),
                          10.heightBox,
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceAround,
                            children:
                              List.generate(3, (index){
                              var iconsList=[clouds,humidity,windspeed];
                              var values=["${data.clouds!.all}%","${data.main!.humidity}%","${data.wind!.speed}km/hr"];
                              
                              return Column(
                                children:[
                                  Image.asset(iconsList[index],
                                  width:60,height:60,).box.gray200.padding(EdgeInsets.all(8)).roundedSM.make(),
                                  10.heightBox,
                                  values[index].text.color(theme.primaryColor).make(),
                                  ]
                              );}
                              )
                            ),
                            10.heightBox,
                            const Divider(),
                            10.heightBox,
                            //for daysForcast
                            FutureBuilder(
                              future:controller.daysWeatherData,
                              builder: (BuildContext context,AsyncSnapshot snapshot){
                                if(snapshot.hasData){
                                  DaysForcastData hourlydata=snapshot.data;
                                  return SizedBox(
                              height: 150,
                              child:ListView.builder(
                                shrinkWrap:true,
                                scrollDirection:Axis.horizontal,
                                physics:const BouncingScrollPhysics(),
                                itemCount:hourlydata.list!.length>6?6:hourlydata.list!.length,
                                itemBuilder: (BuildContext context, int index){
                                  var time=DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlydata.list![index].dt!.toInt()*1000));
                                 return Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(color:cardColor,borderRadius:BorderRadius.circular(12)),
                                  child:Column(children: [
                                    time.text.gray200.make(),
                                    
                                    
                                    Image.asset("assets/weather/${hourlydata.list![index].weather![0].icon}.png",width:80,),
                                    "${hourlydata.list![index].main!.temp} C".text.white.make(),
                                  ]) 
                                  ,
                                 );
                                 }) ,
                                 );
                                }
                                return(Center(child: CircularProgressIndicator(),));}),
                                10.heightBox,
                                 const Divider(),
                                 10.heightBox,
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    "Next 5 Days".text.semiBold.size(16).color(theme.primaryColor).make(),
                                    TextButton(onPressed: null,child:"View All".text.color(theme.primaryColor).make(),),
                                  ],
                                 ),
                                 ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  itemBuilder: (BuildContext context,int index){
                                    var day=DateFormat("EEEE").format(DateTime.now().add(Duration(days:index+1)));
                                    return Card(
                                      color:theme.cardColor,
                                      child:Container(
                                        // height: 54,
                                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                          Expanded(child: day.text.color(theme.primaryColor).semiBold.make()),
                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: null,
                                              icon: Image.asset("assets/weather/50n.png",width:40),
                                              label: "26 $degree C".text.color(theme.primaryColor).maxFontSize(12).make(),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:"37 $degree C/",
                                                  style:TextStyle(
                                                    color: theme.primaryColor,
                                                    fontFamily: "poppins",
                                                    fontSize: 12,
                                                  )
                                                ),
                                                TextSpan(
                                                  text: "25 $degree C",
                                                  style: TextStyle(
                                                    color:theme.primaryColor,
                                                    fontFamily: "poppins",
                                                    fontSize:12, 
                                                   ),
                                                )
                                              ]
          
                                            ) 
                                            )
                                        ]),
                                      ));
                                  },)
              ])),
                          );
            
              }else {
                          return const Center(
                            child: CircularProgressIndicator());
            }
           
          }
        ),
          ):Center(child: CircularProgressIndicator(),),
      ));
                  }
}