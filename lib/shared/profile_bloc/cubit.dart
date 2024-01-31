import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:premium_fivver_note_app/models/profile_lists_model.dart';
import 'package:premium_fivver_note_app/shared/profile_bloc/states.dart';

import '../../components/constants.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  ProfileCubit() : super(InitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);


  CollectionReference notesCollection = FirebaseFirestore.instance
      .collection('Notes')
      .doc(email)
      .collection('Profile Lists');





  Future<void> getProfileListNote(title) async {
    emit(LeadingGetProfileListNotes());
    await   FirebaseFirestore.instance
        .collection('Notes')
        .doc(email)
        .collection('Profile Lists')
        .doc(title)
        .get()
        .then(
          (value) {
            model = ProfileListsModel.fromJson(value.data()!);
        emit(SuccessGetProfileListNotes());
      },
    ).catchError(
          (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetProfileListNotes());
      },
    );
  }



   ProfileListsModel model = ProfileListsModel(note: 'note', title: 'title');
  Future<void> updateProfileListNote({
    required String note,
    required String title,
  }) async {
    emit(LeadingUpdateProfileListNote());

    await notesCollection.doc(title).update(
      {
        'Note' : note,
        'Last update' : DateFormat('dd-MM-yyyy h:mm a').format(DateTime.now()),
      },
    ).then((value) {
      emit(SuccessUpdateProfileListNote());
      getProfileListNote(title);
    },).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateProfileListNote());
    },);
  }


}
