import 'package:flutter/cupertino.dart';

class CategoriesModel{
  String id;
  String name;
  final Widget route;
  final AssetImage icon;

  //constructor
  CategoriesModel({required this.icon,required this.id, required this.name, required this.route});

/* factory to convert json string to model data
   factory PeopleOne.fromJSON(Map<String, dynamic> json){
     return PeopleOne(
       id: json["id"],
       name: json["name"],
       address: json["address"]
     );
   } */
}