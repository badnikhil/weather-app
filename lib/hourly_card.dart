


import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyCard({super.key,required this.icon,required this.time,required this.temp});

  @override
  Widget build(BuildContext context) {
    return  Card(elevation: 6,
                child:  Container( width: 100,height: 110,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child:   Column(
                    children: [
                      Text(time,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                       const SizedBox(height: 8),
                      Icon(icon,size: 32,),
                      const SizedBox(height: 8),
                      Text('$temp K')
                    ],
                  ),
                )) ;
  }
}