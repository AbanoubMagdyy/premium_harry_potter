import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/models/note_model.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddNoteCubit extends Cubit<AddNotesStates> {
  AddNoteCubit() : super(InitState());

  static AddNoteCubit get(context) => BlocProvider.of(context);

  CollectionReference notesCollection = FirebaseFirestore.instance
      .collection('Notes')
      .doc(email)
      .collection('Notes');

  List<File> imageFiles = [];
  List<dynamic> noteImages = [];


  List<NoteModel> notes = [];
  List<NoteModel> favoriteNotes = [];

  bool isFavorite = false;

  void changeFavourites(){
    isFavorite = !isFavorite;
    emit(ChangeFavourite());
  }


  String category = '' ;
  selectCategory(input){
    category = input;
    emit(SelectCategory());
  }

  Future<void>  updateFavouriteField({
  required String id,
  required bool isFavorite,
}) async {
    emit(LeadingUpdateFavoriteField());
    await notesCollection.doc(id).update(
      {'Is favorite': isFavorite},
    ).then((value) async {
      await getNotes();
      emit(SuccessUpdateFavoriteField());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateFavoriteField());
    });
  }

  Future<void> selectImages(list) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
    );
    list.addAll(
        pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
    emit(SuccessPutImages());
  }

  removeImage(list,file) {
    list.remove(file);
    emit(RemoveImages());
  }



  removeSearch() {
    searchNotes = [];
    emit(RemoveSearch());
  }
  List<String> imageUrls = [];

  Future<void> createNote({
    required String title,
    required String note,
  }) async {
    emit(LeadingCreatePost());
    NoteModel model = NoteModel(
      category: category,
      isFavorite: isFavorite,
      title: title,
      note: note,
      date: DateFormat.yMMMMd().format(DateTime.now()),
      time: DateFormat.jm().format(DateTime.now()),
      lastUpdate: DateFormat('dd-MM-yyyy h:mm a').format(DateTime.now()),
      images: [],
      id: 'id',
    );
    notesCollection.add(model.toMap()).then(
      (result) async {
        await updateNoteID(result.id);
        if (imageFiles.isNotEmpty) {
          await uploadImages(result.id);
          await insertImagesInNote(result.id);
          await FirebaseFirestore.instance.collection('Users').doc(email).update({
            'Total size of images used' : totalSizeImagesInGB
          });
        }
        emit(SuccessCreatePost());

        await getNotes();
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorCreatePost());
      },
    );
  }

  Future<void> uploadImages(String id) async {
    emit(LeadingUploadImages());

    final uploadTasks = imageFiles.map((image) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      return FirebaseStorage.instance
          .ref()
          .child('notes/$email/$id/$fileName')
          .putFile(image)
          .then((p0) => p0.ref.getDownloadURL());
    }).toList();

    try {
      // Wait for all upload tasks to complete
      final List<String> downloadUrls = await Future.wait(uploadTasks);

      // Add the download URLs to the imageUrls list
      imageUrls.addAll(downloadUrls);

      emit(SuccessUploadImages());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUploadImages());
    }
  }



  Future<void> insertImagesInNote(String id) async {
    emit(LeadingInsertImagesInNote());
    await FirebaseFirestore.instance
        .collection('Notes')
        .doc(email)
        .collection('Notes')
        .doc(id)
        .update(
      {
        'Images': imageUrls,
      },
    ).then((value) {
      emit(SuccessInsertImagesInNote());
    },
    ).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorInsertImagesInNote());
    },
    );
  }

  Future<void> getNotes() async {
    emit(LeadingGetNotes());
    notes = [];
    favoriteNotes = [];
    harryPotter = [];
    hermioneGranger = [];
    ronWeasley = [];
    albusDumbledore = [];
    lordVoldemort = [];
    severusSnape = [];
    siriusBlack = [];
    rubeusHagrid = [];
    ginnyWeasley = [];
    nevilleLongbottom  = [];
  await   FirebaseFirestore.instance
        .collection('Notes')
        .doc(email)
        .collection('Notes')
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          switch (element['Category']) {
            case 'Harry Potter':
              harryPotter.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Hermione Granger':
              hermioneGranger.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Ron Weasley':
              ronWeasley.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Albus Dumbledore':
              albusDumbledore.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Lord Voldemort':
              lordVoldemort.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Severus Snape':
              severusSnape.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Sirius Black':
              siriusBlack.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Rubeus Hagrid':
              rubeusHagrid.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Ginny Weasley':
              ginnyWeasley.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            case 'Neville Longbottom':
              nevilleLongbottom.add(NoteModel.fromJson(element.data()));
              notes.add(NoteModel.fromJson(element.data()));
              break;
            default:
              notes.add(NoteModel.fromJson(element.data()));
          }
        }
        for (var note in notes) {
          if(note.isFavorite) {
            favoriteNotes.add(note);
          }
        }
        await wait();
        emit(SuccessGetNotes());
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetNotes());
      },
    );
  }

  Future<void> updateNoteID(String id) async {
    await notesCollection.doc(id).update(
      {'Id': id},
    ).then((value) {
      emit(SuccessUpdateNoteID());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateNoteID());
    });
  }


  void deleteNote(noteID){
    emit(LeadingDeleteNote());
 FirebaseFirestore.instance
        .collection('Notes')
        .doc(email)
        .collection('Notes')
    .doc(noteID)
    .delete().then((value) {
      emit(SuccessDeleteNote());
      getNotes();
 }).catchError((error){
   if (kDebugMode) {
     print(error.toString());
   }
   emit(ErrorDeleteNote());
 });
  }

   List<NoteModel> searchNotes = [];

  void findTheNote(String query) {
    searchNotes = [];
     searchNotes = notes.where((note) {
      return note.title.contains(query) || note.note.contains(query);
    }).toList();
    emit(SuccessSearchNote());
  }


  Future<void> updateNote({
  required String id,
  required String title,
  required String note,
}) async {
    emit(LeadingUpdateNote());
    await formatNoteList();
    if(imageFiles.isNotEmpty) {
      await uploadImages(id);
    }
    await notesCollection.doc(id).update(
      {
        'Title' : title,
        'Note' : note,
        'Category' : category,
        'Images' : imageUrls,
        'Is favorite' : isFavorite,
        'Last update' : DateFormat('dd-MM-yyyy h:mm a').format(DateTime.now()),
        'Total size of images used' : totalSizeImagesInGB
      },
    ).then((value) {
      emit(SuccessUpdateNote());
      getNotes();
    },).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateNote());
    },);
  }


 Future <void> formatNoteList()async {
    for(var i in noteImages){
      if(i is String){
        imageUrls.add(i);
      }else{
        imageFiles.add(i);
      }
    }
    emit(FormatNoteImages());
  }

  /// categories
  List<NoteModel> harryPotter = [];
  List<NoteModel> hermioneGranger = [];
  List<NoteModel> ronWeasley = [];
  List<NoteModel> albusDumbledore = [];
  List<NoteModel> lordVoldemort = [];
  List<NoteModel> severusSnape = [];
  List<NoteModel> siriusBlack = [];
  List<NoteModel> rubeusHagrid = [];
  List<NoteModel> ginnyWeasley = [];
  List<NoteModel> nevilleLongbottom  = [];


  Future<void>  updateCategoryField({
    required String id,
    required String category,
  }) async {
    emit(LeadingUpdateCategoryField());
    await notesCollection.doc(id).update(
      {'Category': category},
    ).then((value) {
      getNotes();
      emit(SuccessUpdateCategoryField());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateCategoryField());
    });
  }


}
