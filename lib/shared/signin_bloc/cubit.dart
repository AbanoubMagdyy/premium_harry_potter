import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/shared/signin_bloc/states.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(InitialSignInState());

  static SignInCubit get(context) => BlocProvider.of(context);

  bool hidePassword = true;

  changeIcon() {
    hidePassword = !hidePassword;
    emit(ChangeSignInPasswordIcon());
  }


  Future<void> userLogin({
  required String email,
  required String password,
}) async {
    emit(LeadingSignIn());
   await   FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          emit(SuccessSignIn());
    })
        .catchError((error) {
          if (kDebugMode) {
            print(error.toString());
          }
          emit(ErrorSignIn());
    });
  }


  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      emit(SuccessResetPassword());
    },)
        .catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorResetPassword());
    },);
  }


  Future<bool> checkTheNumberCode(String code,email) async {
    bool isTheCodeAvailable = false;
    emit(LeadingCheckTheNumberCode());

    // Create a DocumentReference to the document with the name.
    DocumentReference documentReference = FirebaseFirestore.instance.collection('Account creation codes').doc(code);

    // Call the get() method on the DocumentReference to retrieve the document.
    DocumentSnapshot documentSnapshot = await documentReference.get();

    //  Check if the hasData property of the DocumentSnapshot is true.
    if(documentSnapshot.exists){
      await documentSnapshot.reference.get().then((value) {

        if(value.get('Has the code been used')){
          if( value.get('Email') == email){
            if(value.get('Number of times log in') < maximumNumberOfLogins){
              try{
                documentSnapshot.reference.update({
                  'Number of times log in' : value.get('Number of times log in') + 1
                }
                );
                isTheCodeAvailable = true;
                emit(SuccessCheckTheNumberCode());
              } catch(error) {
                if (kDebugMode) {
                  print(error.toString());
                }
                isTheCodeAvailable = false;

                emit(ErrorCheckTheNumberCode());
              }
            }
          }else{
            isTheCodeAvailable = false;
          }
        }else{
          isTheCodeAvailable = false;
        }
      },
      );
    }

    emit(SuccessCheckTheNumberCode());
    return isTheCodeAvailable;
  }

  //
  // Future<bool> checkTheNumberCode(String code, String email) async {
  //   bool isTheCodeAvailable = false;
  //   emit(LeadingCheckTheNumberCode());
  //
  //   DocumentReference documentReference =
  //   FirebaseFirestore.instance.collection('Account creation codes').doc(code);
  //
  //   DocumentSnapshot documentSnapshot = await documentReference.get();
  //
  //   if (documentSnapshot.exists) {
  //     Map<String, dynamic>? data = documentSnapshot.data();
  //     if (data != null && data.containsKey('Has the code been used')) {
  //       bool hasCodeBeenUsed = data['Has the code been used'];
  //       if (hasCodeBeenUsed && data.containsKey('Email')) {
  //         String storedEmail = data['Email'];
  //         if (storedEmail == email && data.containsKey('Number of times log in')) {
  //           int numberOfTimesLoggedIn = data['Number of times log in'];
  //           if (numberOfTimesLoggedIn < maximumNumberOfLogins) {
  //             try {
  //               await documentReference.update({
  //                 'Number of times log in': numberOfTimesLoggedIn + 1,
  //               });
  //               isTheCodeAvailable = true;
  //               emit(SuccessCheckTheNumberCode());
  //             } catch (error) {
  //               if (kDebugMode) {
  //                 print(error.toString());
  //               }
  //               isTheCodeAvailable = false;
  //               emit(ErrorCheckTheNumberCode());
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //
  //   if (!isTheCodeAvailable) {
  //     emit(ErrorCheckTheNumberCode());
  //   } else {
  //     emit(SuccessCheckTheNumberCode());
  //   }
  //
  //   return isTheCodeAvailable;
  // }
}
