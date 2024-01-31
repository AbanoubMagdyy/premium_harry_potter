import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/shared/register_bloc/states.dart';
import '../../models/profile_lists_model.dart';
import '../../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool hidePassword = true;

  changeIcon() {
    hidePassword = !hidePassword;
    emit(ChangePasswordIcon());
  }

  DateTime date = DateTime.now();
  bool putDate = false;

  void showTheDate({
    required context,
  }) {
    showDatePicker(
            context: context,
            initialDate: DateTime(1980, 07, 31),
            firstDate: DateTime(1950),
            lastDate: DateTime(DateTime.now().year))
        .then((value) {
      date = value!;
      putDate = true;
      emit(SuccessChooseDate());
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      emit(ErrorChooseDate());
    });
  }

  ImagePicker imagePicker = ImagePicker();
  File? profileImage;

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SuccessPutImage());
    } else {
      emit(ErrorPutImage());
    }
  }


  late String profilePath;


  Future<void> uploadProfileImage({
    required String email,
  }) async {
      emit(LeadingUploadProfile());
   await  firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/$email/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profilePath = value;
        if (!isClosed) {
          emit(SuccessUploadProfile());
        }
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        if (!isClosed) {
          emit(ErrorUploadProfile());
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUploadProfile());
    });
  }


  Future<void> userRegister({
  required String email,
  required String password,
  required String name,
  required String birthday,
  required String code,
}) async {
    emit(LeadingRegister());
   await  FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
         await createUser(password: password, email: email, name: name, birthday: birthday,code: code);
         if (!isClosed) {
           emit(SuccessRegister());
         }
    })
        .catchError((error) {
          if (kDebugMode) {
            print(error.toString());
          }
          if (!isClosed) {
            emit(ErrorRegister());
          }
    });
  }


  Future<void> createUser({
    required String password,
    required String email,
    required String name,
    required String birthday,
    required String code,
  }) async {
    UserModel model = UserModel(
      isDisabled: false,
      name: name,
      password: password,
      bio: 'Hello I\'m a new here',
      email: email,
      profile: profilePath,
      birthday: birthday,
      theDateOfJoin: DateFormat('dd-MM-yyyy h:mm a').format(DateTime.now()),
      maximumSizeOfImagesInGB: maximumSizeImagesInGB,
      totalSizeOfImagesUsed: totalSizeImagesInGB,
      code: code
    );
   await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .set(model.toMap())
        .then((value) {
     if (!isClosed) {
       emit(SuccessCreateUser());
     }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      if (!isClosed) {
        emit(ErrorCreateUser());
      }
    },
   );
  }


  Future<void> createProfileLists(email) async {
    emit(LeadingCreateProfileLists());
    for(var i in profileLists){
      ProfileListsModel model =ProfileListsModel(note: i.note, title: i.title,lastUpdate: 'new');
      FirebaseFirestore.instance
          .collection('Notes')
          .doc(email)
          .collection('Profile Lists').doc(i.title).set(model.toMap()).then(
            (result) async {
              if (!isClosed) {
                emit(SuccessCreateProfileLists());
              }
        },
      ).catchError(
            (error) {
          if (kDebugMode) {
            print(error.toString());
          }
          if (!isClosed) {
            emit(ErrorCreateProfileLists());
          }
        },
      );
}
    emit(SuccessCreateProfileLists());
  }



  Future<bool> checkTheCode(String code,email) async {
    bool isTheCodeAvailable = false;
    emit(LeadingCheckTheCode());

    // Create a DocumentReference to the document with the name.
    DocumentReference documentReference = FirebaseFirestore.instance.collection('Account creation codes').doc(code);

    // Call the get() method on the DocumentReference to retrieve the document.
    DocumentSnapshot documentSnapshot = await documentReference.get();

  //  Check if the hasData property of the DocumentSnapshot is true.
    if(documentSnapshot.exists){
    await documentSnapshot.reference.get().then((value) {
        if(value.get('Has the code been used')){
          isTheCodeAvailable = false;
        }else{
          try{
            documentSnapshot.reference.update({
              'Has the code been used' : true,
              'Email' : email,
              'Number of times log in' : 0
            }
            );
            isTheCodeAvailable = true;
            emit(SuccessUpdateValueCode());
          } catch(error) {
            if (kDebugMode) {
              print(error.toString());
            }
            emit(ErrorUpdateValueCode());
          }
        }
      },
    );

    }
    emit(SuccessUpdateValueCode());
    return isTheCodeAvailable;
  }

}