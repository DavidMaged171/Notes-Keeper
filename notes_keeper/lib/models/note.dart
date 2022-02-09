class Note
{
  int _id,_priority;
  String _title,_description,_date;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id =>_id;
  int get priority =>_priority;
  String get title =>_title;
  String get description =>_description;
  String get date =>_date;

  set title(String newTitle)
  {
    if(newTitle.length<=255)
      this._title=newTitle;
  }
  set description(String newdescription)
  {
    if(newdescription.length<=255)
      this._description=newdescription;
  }
  set priority(int newPriority)
  {
    if(newPriority==1 || newPriority==2)
      this._priority=newPriority;
  }

  set date(String newDate)
  {
    this._date=newDate;
  }
  // Convert a Note object into a map object
Map<String,dynamic>toMap(){
    var map= Map<String,dynamic>();
    if(id!=null)
      map['id']=_id;

    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['date']=_date;
    return map;
  }
  Note.fromMapObject(Map<String,dynamic>map)
  {
    this._id=map['id'];
    this._date=map['date'];
    this._title=map['title'];
    this._description=map['description'];
    this._priority=map['priority'];

  }
}