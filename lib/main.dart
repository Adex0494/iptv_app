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
  GlobalKey<FormState> _formState = GlobalKey<FormState>(); 
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

  void onBottomNavBarItemTapped (int indexTapped)async{
       _bottomNavigationBarIndex = indexTapped; 
      if (_bottomNavigationBarIndex !=0){
        await updateLisView();
        if (listCount==0){
          _showAlertDialog('Mensaje', 'No ha añadido enlaces de este tipo.' 
          'Puede hacerlo en la ventana de Inicio.');
        }
      }
    setState((){
   
    });
  }

  Widget getScaffoldBody(TextStyle textStyle){
    if (_bottomNavigationBarIndex == 0){
      return homeWidget(textStyle);
    }
    else {
      return getLinkList(_bottomNavigationBarIndex);}
  }

  Widget homeWidget(TextStyle textStyle){
    return Container(
          alignment: Alignment.center,
          child: 
            Form(
              key: _formState,
              child: ListView(children: <Widget>[
                Padding(
                padding: EdgeInsets.all(15.0),  
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //First Element: 'Nuevo Enlace' Text
                  TextFormField(
                    style: textStyle,
                    controller: urlController,
                    validator: (String value){
                      if (value.isEmpty){
                        return 'Ponga el URL';
                      }
                    },
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
                      //updateUrl();
                    },
                  ),
                  //Second element: 'Descripcion' Text
                  Padding
                  (padding: EdgeInsets.only(top: 3, bottom: 3),
                    child:TextFormField(
                      style: textStyle,
                      controller: descriptionController,
                      validator: (String value){
                        if (value.isEmpty){
                          return 'Ponga la descripción';
                      }
                      },
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: textStyle,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        )
                      ),
                      onChanged: (value){
                        //updateDescription();
                      },
                    ) 
                  ),
                  
                  //Third Element: Dropdonw types of link
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
                  //Forth Element: Save Button
                  Padding (
                    padding: EdgeInsets.only(top: 15.0),
                    child:  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        'Añadir',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          //When the Save button is pressed... 
                          if (_formState.currentState.validate()){
                            _saveLink();
                          }

                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  )
                
                ],),
                )
              ],)
            )
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
                setState(() {
                   _delete(linkList[position].id);
                });
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

  void updateLisView()async{
      await databaseHelper.initializeDatabase();
      List<Link> theLinkList = await databaseHelper.getLinkListByType(_bottomNavigationBarIndex);
        setState(() {
          this.linkList = theLinkList;
          this.listCount = theLinkList.length; 
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
      urlController.text ='';
      descriptionController.text = '';
    }
    else{
       _showAlertDialog('Estado', 'Ocurrió un problema al salvar');
    }

  }

  void _delete(int id)async{
    int result;
    result = await databaseHelper.deleteLink(id);
    if (result !=0){
      _showAlertDialog('Estado', 'Enlace eliminado exitosamente');
      updateLisView();
    }
    else{
       _showAlertDialog('Estado', 'Ocurrió un problema al eliminar');
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

}
