import 'package:flutter/material.dart';

class LinkList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return LinkListState();
  }
}

class LinkListState extends State<LinkList>{
  String appBarTitle ='Inicio';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(appBarTitle) ,
      )
    );
  }
}