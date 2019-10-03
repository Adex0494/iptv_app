import 'package:flutter/material.dart';
import 'package:iptv_app/link_list.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPTVapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
        hintColor: Colors.white,
        canvasColor: Colors.purpleAccent.withOpacity(0.87),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  static List<String> _linkTypes = ['Canales','Películas','Música'];
  String _selectedLinkType = _linkTypes[0];
  int _bottomNavigationBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
         title: Text('Inicio'), 
        ),
        backgroundColor: Colors.black,
        body: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(15.0),  
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //First Element: 'Nuevo Enlace' Text
              TextField(
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Nuevo Enlace',
                  labelStyle: textStyle,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),
              
              //Second Element: Dropdonw types of link
              ListTile(
                title: DropdownButton(
                  items: _linkTypes.map((String dropDownStringItem){
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem)
                    );
                  }).toList(),
                  style: textStyle,
                  value:_selectedLinkType,
                  onChanged: (valueSelectedByUser){
                    setState(() {
                      _selectedLinkType = valueSelectedByUser; 
                    });
                  },
                  
                )
              ),

              //Third Element: Save Button
              Padding (
                padding: EdgeInsets.only(top: 15.0),
                child:  RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    'Guardar',
                    textScaleFactor: 1.5,
                  ),
                  onPressed: (){
                    setState(() {
                      //When the Save button is pressed... 
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              )
             
            ],),
            ),
        ),
       
        //Bottom Navigation Bar...
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          //Inicio
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio',style: textStyle,),
          ),
          //Canales
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text(_linkTypes[0],style: textStyle,),
          ),
          //Peliculas
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            title: Text(_linkTypes[1],style: textStyle,),
          ),
          //Musica
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            title: Text(_linkTypes[2],style: textStyle,),
          ),
        ],

        currentIndex: _bottomNavigationBarIndex,
        onTap: onBottomNavBarItemTapped,
      ),
      );
  }

  void onBottomNavBarItemTapped (int indexTapped){
    setState(() {
      _bottomNavigationBarIndex = indexTapped; 
    });
  }
}