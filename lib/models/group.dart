class Group {
  Map<String, String> notes = new Map();

  late String Name;

  late String creatorUID;

  // Group();

  Group({required this.Name,required this.notes,required this.creatorUID});

  toMap(){
    var ans = Map<String,dynamic>();

    ans['notes'] = notes;

    ans['name'] = Name;

    ans['creator'] = creatorUID;

    return ans;
  }
  Group.fromMap(Map<String,dynamic> map){
    
    notes = Map<String, String>.from(map['notes']);
    Name = map['name'];
    creatorUID = map["creator"];
  }




}

