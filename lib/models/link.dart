class Link {
  int _id;
  String _url;
  String _description;
  int _type;

  //Constructor without id
  Link(this._url,this._description,this._type);
  //Constructor with id
  Link.withId(this._id,this._url,this._description,this._type);

  //getters
  int get id => _id;
  String get url => _url;
  String get description => _description;
  int get type => _type;

  //setters
  set url (String newUrl){
    if (newUrl.length <=2048){
      this._url = newUrl;
    }
  }

  set description (String newDescription){
    if (newDescription.length <=255){
      this._description = newDescription;
    }
  }

  set type (int newType){
    if (type >0 && type <4){
      this._type = newType;
    }
  }

  //Convert a Link object into a Map object
  Map<String,dynamic> toMap (){
    Map<String,dynamic> map = Map<String,dynamic>();
    if (_id != null){
      map['id'] = _id;
    }
    map['url'] = _url;
    map['description'] = _description;
    map['type'] = _type; 
    return map;
  }
  //Convert Map object into Link
  Link.toLink(Map<String,dynamic> map){
    this._id = map['id'];
    this._url = map['url'];
    this._description = map['description'];
    this._type  = map['type'];
  }

}