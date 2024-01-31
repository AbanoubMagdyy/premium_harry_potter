class NoteModel {
  late String title;
  late String id;
  late String note;
  late String date;
  late String time;
  late String category;
  late String lastUpdate;
  late bool isFavorite;
  late List<dynamic> images;

  NoteModel({
    required this.title,
    required this.note,
    required this.date,
    required this.time,
    required this.images,
    required this.id,
    required this.category,
    required this.isFavorite,
    required this.lastUpdate,
    });



  NoteModel.fromJson(Map<String,dynamic> json){
    title = json['Title'];
    note = json['Note'];
    date = json['Date'];
    time = json['Time'];
    images = json['Images'];
    id = json['Id'];
    category = json['Category'];
    isFavorite = json['Is favorite'];
    lastUpdate = json['Last update'];
  }



  Map<String,dynamic> toMap(){
    return {
      'Title' : title,
      'Note' : note,
      'Date' : date,
      'Time' : time,
      'Images' : images,
      'Id' : id,
      'Is favorite' : isFavorite,
      'Category' : category,
      'Last update' : lastUpdate,
    };
  }
}
