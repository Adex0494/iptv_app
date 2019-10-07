import 'package:flutter/material.dart';
import 'package:iptv_app/utils/database_helper.dart';
import 'package:iptv_app/models/link.dart';
import 'package:sqflite/sqflite.dart';

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
  TextEditingController urlController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int listCount = 0; //Count of list Items
  static List<String> _linkTypes = ['Canales','Películas','Música'];
  String _selectedLinkType = _linkTypes[0];
  int _bottomNavigationBarIndex = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Link> linkList; 

  @override
  Widget build(BuildContext context) {
    if(linkList == null){
      linkList = List<Link>();
      updateLisView();
    }
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
         title: Text('Inicio'), 
        ),
        backgroundColor: Colors.black,
        body: getScaffoldBody(textStyle),
       
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

  Widget getScaffoldBody(TextStyle textStyle){
    if (_bottomNavigationBarIndex == 0){
      return homeWidget(textStyle);
    }
    else {
      updateLisView();
      return getLinkList(_bottomNavigationBarIndex);}
  }

  Widget homeWidget(TextStyle textStyle){
    return Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(15.0),  
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //First Element: 'Nuevo Enlace' Text
              TextField(
                style: textStyle,
                controller: urlController,
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
                onChanged: (value){
                  updateUrl();
                },
              ),
              //Second element: 'Descripcion' Text
              Padding
              (padding: EdgeInsets.only(top: 3, bottom: 3),
                child:TextField(
                  style: textStyle,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripcion',
                    labelStyle: textStyle,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                  onChanged: (value){
                    updateDescription();
                  },
                ) 
              ),
              
              //Second Element: Dropdonw types of link
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Tipo de enlace',
                      style: textStyle,
                    )
                  ),
                  Expanded(
                    child: ListTile(
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
                    )
                  )
                ]
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
                      _saveLink();
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              )
             
            ],),
            ),
        );
  }

  Widget getLinkList(int index){
    TextStyle  titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: listCount,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation :2.0,
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.play_arrow),
            ),
            title: Text(linkList[position].description,style: titleStyle),
            subtitle: Text(linkList[position].url,),
            trailing:GestureDetector(
              child: Icon(Icons.delete,color: Colors.grey),
              onTap: (){
                //Delete Action Code 
              }
            ),
            onTap: (){
              //Code when List item is tapped
            },
          )
        );
      },
    );
  }

  void updateLisView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Link>> futureLinkList = databaseHelper.getLinkListByType(_bottomNavigationBarIndex);
      futureLinkList.then((linkList){
        setState(() {
          this.linkList = linkList;
          this.listCount = linkList.length; 
        });
      });
    });
  }

  int _getLinkTypeInt(){
        switch (_selectedLinkType){
      case 'Canales': 
        return 1;
        break;
      case 'Películas':
        return 2;
        break;
      case 'Música':
        return 3;
        break;
      default:
        return 1;
    }
  }

  void _saveLink()async{


    int result;
    Link link = Link(urlController.text,descriptionController.text,_getLinkTypeInt());
    result = await databaseHelper.insertLink(link);
        if (result !=0){
      _showAlertDialog('Estado', 'Enlace guardado exitosamente');
       updateLisView();
    }
    else{
       _showAlertDialog('Estado', 'Ocurrió un problema al salvar');
    }

  }

    void _showAlertDialog(String title, String message){

    AlertDialog alertDialog = AlertDialog(
      title: Text(title, 
        style: TextStyle(color: Colors.black),
      ),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_)=> alertDialog
    );
  }

  void updateUrl(){
    debugPrint(urlController.text);
  }

  void updateDescription(){
    debugPrint(descriptionController.text);
  }
}
