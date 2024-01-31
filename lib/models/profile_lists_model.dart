class ProfileListsModel {
 late String title;
  late String note;
   String? image;
  String? lastUpdate;

  ProfileListsModel({required this.note,required this.title,this.image,this.lastUpdate});




  ProfileListsModel.fromJson(Map<String,dynamic> json){
    title = json['Title'];
    note = json['Note'];
    lastUpdate = json['Last update'];
  }



  Map<String,dynamic> toMap(){
    return {
      'Title' : title,
      'Note' : note,
      'Last update' : lastUpdate,
    };
  }

}