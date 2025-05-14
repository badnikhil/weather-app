  import 'dart:convert';
import 'dart:ui';


import 'package:intl/intl.dart';

import 'private.dart';
import 'package:flutter/material.dart';
import 'package:weather/add_info_card.dart';
import 'package:weather/hourly_card.dart';
import 'package:http/http.dart' as http;
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  


  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  

 
    late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getweather () async{ 
      String cityName='London';

    try {
        final res=await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$api'));
         final data=jsonDecode(res.body);
        if(data['cod']!='200'){
         throw "An Unexpected Error Occured" ;}
    return data;
    
}
catch (e) {
    throw e.toString();
}
    }
  @override
  Widget build(BuildContext context) {

    return  Scaffold( 
      appBar: AppBar(
        title: const Text("Weather App",style:TextStyle(fontWeight: FontWeight.bold),), centerTitle: true,
        actions:  [
           IconButton(onPressed: () {setState(() {
             weather=getweather();
           });
           }, icon: const Icon(Icons.refresh_rounded))
        ],
      ),
    body:     FutureBuilder(
      future: getweather(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        else if (snapshot.hasError){
          return Text(snapshot.error.toString());}
          final data=snapshot.data!;
          double temp= data ['list'][0]['main']['temp']; 
          String weather=data ['list'][0]['weather'][0]['main'];
          String humidity=data ['list'][0]['main']['humidity'].toString(); 
          String windSpeed=data ['list'][0]['wind']['speed'].toString();
          String pressure=data ['list'][0]['main']['pressure'].toString();

        return Padding( 
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // main card
              SizedBox(width: double.infinity,
                child: Card(elevation: 10,
                shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                
                   child: ClipRRect(borderRadius: BorderRadius.circular(16),
                     child: Padding(
                       padding: const  EdgeInsets.all(16.0),
                       child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                         child:  Column( 
                          children: [
                           
                             Text('${temp.toString()} K',style: const TextStyle(fontSize: 32,fontWeight:FontWeight.bold ),),
                               const SizedBox(height: 10,),
                           Icon(weather=='Rain' ||weather=='Clouds'? Icons.cloud:Icons.sunny,size: 64,),
                           const SizedBox(height: 10,),
                            Text(weather,style: const TextStyle(fontSize: 20),),
                              
                          ],
                         ),
                       ),
                     ),
                   ),
                ),
              ),
               const  SizedBox(height: 20,),
              const Text("Weather Forecast",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
              const  SizedBox(height: 10,), 
             
                  SizedBox( height: 120,
                    child: ListView.builder(scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      
                      itemBuilder: (context, index){
                        final currtime=DateTime.parse( data['list'][index+1]['dt_txt'].toString());
                        String currTemp=data ['list'][index+1]['main']['temp'].toString();
                        String currweather=data ['list'][index+1]['weather'][0]['main'];
                        return  HourlyCard(icon: currweather=='Rain' ||currweather=='Cloud'? Icons.cloud:Icons.sunny,
                         time:DateFormat.j().format(currtime), temp: currTemp);
                      }),
                  )

              ,const SizedBox(height: 11)
        ,          const Text("Additional Information",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
               const SizedBox(height: 10,),
               Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AddInfoCard(icon: Icons.water_drop, label: 'Humidity', value: humidity),
                  AddInfoCard(icon: Icons.air_rounded, label: 'Wind Speed', value: windSpeed),
                  AddInfoCard(icon: Icons.beach_access, label: 'Pressure', value: pressure),
                ],
               )
              
            ],
          ),
        );
      }
    ) ,
    );
  }
}




