import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/models/user_model.dart';
import 'package:premium_fivver_note_app/screens/bottom_navigation_bar_screens/birthday_screen.dart';
import 'package:premium_fivver_note_app/screens/bottom_navigation_bar_screens/home_screen.dart';
import 'package:premium_fivver_note_app/screens/bottom_navigation_bar_screens/settings_screen.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../screens/bottom_navigation_bar_screens/category_screen.dart';

class NotesCubit extends Cubit<NotesStates> {
  NotesCubit() : super(InitState());

  static NotesCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const HomeScreen(),
    const BirthdayScreen(),
    const CategoryScreen(),
    const SettingsScreen(),
  ];

  int currantIndex = 0;

  void changeBNB(int index) {
    currantIndex = index;
    emit(ChangeBNB());
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
          if(value != null){
            date = value;
            putDate = true;
          }
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

  UserModel model = UserModel(
      password: 'password',
      email: 'email',
      name: 'Harry',
      profile: 'profile',
      bio: 'bio',
      birthday: 'birthday',
      theDateOfJoin: 'theDateOfJoin',
      maximumSizeOfImagesInGB: maximumSizeImagesInGB,
      totalSizeOfImagesUsed: 0,
    code: 'code',
    isDisabled: false
  );

  getUserData() {
    emit(LeadingGetUserDate());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .get()
        .then((value) {
      model = UserModel.fromJson(value.data()!);
      totalSizeImagesInGB = model.totalSizeOfImagesUsed;
      emit(SuccessGetUserDate());
    }).catchError(
      (error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetUserDate());
      },
    );
  }

  updateData(
      {required String name,
      required String birthday,
      required String bio}) async {
    emit(LeadingUpdateData());
    if (profileImage == null) {
      FirebaseFirestore.instance.collection('Users').doc(email).update(
        {'Name': name, 'Birthday': birthday, 'Bio': bio},
      ).then(
        (value) {
          emit(SuccessUpdateData());
          getUserData();
        },
      ).catchError(
        (error) {
          if (kDebugMode) {
            print(error.toString());
          }
          emit(ErrorUpdateData());
        },
      );
    } else {
      await updateProfileImage();
      await FirebaseFirestore.instance.collection('Users').doc(email).update(
        {
          'Name': name,
          'Birthday': birthday,
          'Profile': profilePath,
          'Bio': bio,
          'Total size of images used' : totalSizeImagesInGB
        },
      ).then(
        (value) {
          emit(SuccessUpdateData());
          getUserData();
        },
      ).catchError(
        (error) {
          if (kDebugMode) {
            print(error.toString());
          }
          emit(ErrorUpdateData());
        },
      );
    }
  }

  String profilePath = '';

  Future<void> updateProfileImage() async {
    String imagePath =
        'users/$email/${Uri.file(profileImage!.path).pathSegments.last}';
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(imagePath)
          .putFile(profileImage!);

      final downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(imagePath)
          .getDownloadURL();

      profilePath = downloadURL;
      emit(SuccessUpdateProfileImage());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateProfileImage());
    }
  }





  bool isThisMyBirthday = false;

  void birthday() {
    isThisMyBirthday = !isThisMyBirthday;
    emit(Birthday());
  }
}
