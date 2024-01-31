import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/category_model.dart';
import '../models/profile_lists_model.dart';
import '../shared/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'components.dart';


String email = '';
Widget? screen;
int maximumNumberOfLogins = 5;



Future<bool> checkUserAccountStatus() async {

  if(email != ''){
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .get();

    bool isDisabled = snapshot.get('Is Disabled') ?? false;

    if (isDisabled) {
      return true;
    }else{
      return false;
    }
  }
return false;
}

double totalSizeImagesInGB = 0;
double sizeNoteImagesInGB = 0;
double sizeProfileImageInGB = 0;
 int maximumSizeImagesInGB = 10;



double calculateTotalFileSizeInGB(image,bool addToTotalSizeImagesInMB) {

  if(image is File){
    sizeProfileImageInGB = 0;
    if (image.existsSync()) {
      final fileSizeInBytes = image.lengthSync();
      final fileSizeInGB = fileSizeInBytes / 1000 / 1000 / 1000;
      sizeProfileImageInGB = totalSizeImagesInGB + fileSizeInGB;
      if(addToTotalSizeImagesInMB) {
        totalSizeImagesInGB += fileSizeInGB;
      }
    } else {
      throw Exception('File does not exist.');
    }
    return sizeProfileImageInGB;
  }else{
    sizeNoteImagesInGB = 0;
    for (final file in image) {
      if(file is File){
        if (file.existsSync()) {
          final fileSizeInBytes = file.lengthSync();
          final fileSizeInGB = fileSizeInBytes / 1000 / 1000 / 1000;
            sizeNoteImagesInGB += fileSizeInGB;
        } else {
          throw Exception('File does not exist.');
        }
      }
    }
    sizeNoteImagesInGB += totalSizeImagesInGB;
    if(addToTotalSizeImagesInMB) {
      totalSizeImagesInGB += sizeNoteImagesInGB;
    }
    return sizeNoteImagesInGB;
  }
}



Future<void> wait() async {
  await Future.delayed(const Duration(seconds: 3));
}


void logout(context) {
  Shared.deleteData('email')?.then((value) {
    Restart.restartApp();
  },
  );
}

gmail()async{
  final Uri uri = Uri(
      scheme: 'mailto',
      path: 'noteapps31@gmail.com'
  );
  if(await canLaunchUrl(uri)){
    await launchUrl(uri);
  } else{
    throw 'could font $uri';
  }
}

facebook()async{
  final Uri url = Uri.parse('fb://facewebmodal/f?href=https://www.facebook.com/abanoub.magdy.129');
  if (await launchUrl(url,)) {
    throw 'Could not launch $url';
  }else {
    // Launch the Facebook website in the browser.
    await launchUrl(Uri.parse('https://www.facebook.com/my-facebook-account'));
  }
}

Future<void> telegram() async {
  final Uri url = Uri.parse('tg://resolve?domain=AbanoubMagdy15');
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

Future<void> linkedIn() async {
  final Uri url = Uri.parse('https://www.linkedin.com/in/magdy-mouris-a8376a244/');
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

Future<void> whatsApp() async {
  final Uri url = Uri.parse('whatsapp://send?phone=+201278803223');
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}


bool isConnect = false;
Future<void> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    isConnect = true;
  } else {
    // Wait for a brief moment to allow the package to update its status
    await Future.delayed(const Duration(seconds: 2));
    connectivityResult = await Connectivity().checkConnectivity();
    isConnect =
    connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    toast(
      msg: 'You are offline. If you want any change, you must connect to the Internet',
      isError: false,);
  }
}

Future<bool> checkEmailAvailability(String email) async {
  try {
    List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return signInMethods.isEmpty;
  } catch (error) {
    if (kDebugMode) {
      print(error.toString());
    }
    return false;
  }
}


final List<CategoryModel> categories = [
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1GDaF511dMmkF69NAjKluTnq9v2VAFOI0',
    name: 'Harry Potter',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1jommcRhcLR0bCvhNePl3ewCzx4H-Psu9',
    name: 'Albus Dumbledore',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1soxx2vMHuoj-Sw31k_1yrIzaAmE3wdbs',
    name: 'Ginny Weasley',),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1p2Y2GougQiZQ6yUfd_qc8k04q-2givb-',
    name: 'Hermione Granger',),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1VSL4P3dPaAoc04c5xADLitHb6j-EOAet',
    name: 'Lord Voldemort',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1f-55GlVI5Gzpe98m8gKY6ExbvjQfWDg5',
    name: 'Neville Longbottom',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1z4S_rdbsvAfdfWjZYG6p4Nf5xHBir24O',
    name: 'Ron Weasley',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1EcqYm4MpFZzvvBMdCyEZnusa2uZ-2v9B',
    name: 'Rubeus Hagrid',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1kb4oFhVTZpC-VkUoSaQVcI4rMuvM2mPu',
    name: 'Severus Snape',
  ),
  CategoryModel(
    image: 'https://drive.google.com/uc?export=view&id=1W6YDJSnONjjTNeK3np9Z_yx3dPgM9oYt',
    name: 'Sirius Black',
  ),
];

final List<ProfileListsModel> profileLists =[
  /// NAMES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fnames.jpg?alt=media&token=160b8f48-327e-4a75-a4df-bb97d9b1119b',
    title: 'Names',
    note: 'Write the names you prefer in this note',
  ),
  /// HOBBIES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fhobbies.jpg?alt=media&token=d1bf3a62-1f73-4646-b190-76f8fd8a2083',
    title: 'Hobbies',
    note: 'Write the hobbies that you like in this note',
  ),
  /// SINGERS
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fsingers.jpg?alt=media&token=a2a67eb9-df96-4d2c-b55c-66323d680de9',
    title: 'Singers',
    note: 'Write the best singers you like to hear in this note',
  ),
  /// ACTORS
  ProfileListsModel(
    image: 'https://drive.google.com/uc?export=view&id=1GDaF511dMmkF69NAjKluTnq9v2VAFOI0',
    title: 'Actors',
    note: 'Write the top actors you like to watch in this note',
  ),
  ///SPORTS
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FSports.jpg?alt=media&token=a913fc2c-5d4e-4101-bd67-7eb054c1c56a&_gl=1*1mta5ea*_ga*MzAxMDkxNzQuMTY5MTA5NDI1Mg..*_ga_CW55HF8NVT*MTY5ODUyMDkzMC4xNjAuMS4xNjk4NTIyNzA4LjI4LjAuMA..',
    title: 'Sports',
    note: 'Write the best sports you like to practice in this note',
  ),
  ///MOVIES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fmovies.jpg?alt=media&token=89c28cc5-67b3-4bbd-8802-176506149c67',
    title: 'Moves',
    note: 'Write the best movies you like to watch in this note',
  ),
  /// SONGS
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fsonges.jpg?alt=media&token=4f77bbdb-0ae5-4ce9-a87e-36228c9251b1',
    title: 'Songs',
    note: 'Write the best songs that you like to hear in this note',
  ),
  /// SERIES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FSeries.jpg?alt=media&token=fc430db0-8d34-409e-beca-7d70564380db&_gl=1*1ozhfkv*_ga*MzAxMDkxNzQuMTY5MTA5NDI1Mg..*_ga_CW55HF8NVT*MTY5ODUyMDkzMC4xNjAuMS4xNjk4NTIyNjc2LjYwLjAuMA..',
    title: 'Series',
    note: 'Write the best series that you like to follow in this note',
  ),
  /// YOUTUBE
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fyoutube.jpg?alt=media&token=e2362266-6e50-4229-bce5-7f68ecc8fe0b',
    title: 'Youtube',
    note: 'Write the top YouTube channels you follow in this note',
  ),
  /// TIKTOK
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Ftiktok.jpg?alt=media&token=03437bb6-9aa7-493f-b687-68e80f467e54',
    title: 'Tiktok',
    note: 'Write the top TikTok accounts you follow in this note',
  ),
  /// FACEBOOK
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ffacebook.png?alt=media&token=331b93cd-7382-4210-9b6a-c77fd58bcb3f',
    title: 'Facebook',
    note: 'Write the best Facebook accounts and pages you like to follow in this note',
  ),
  /// INSTAGRAM
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Finstgram.jpg?alt=media&token=36385a8d-0b6d-476a-b827-ef412a4cb8b6',
    title: 'Instagram',
    note: 'Write the top Instagram accounts you want to follow in this note',
  ),
  /// X
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FX.jpg?alt=media&token=a12f2a74-bda5-4c14-9c38-8af15ab72cda&_gl=1*1tt1nrt*_ga*MzAxMDkxNzQuMTY5MTA5NDI1Mg..*_ga_CW55HF8NVT*MTY5ODUyMDkzMC4xNjAuMS4xNjk4NTIzMDA4LjYwLjAuMA..',
    title: 'X',
    note: 'Write your top favorite X accounts in this note',
  ),
  /// CHARACTERS
  ProfileListsModel(
    image: 'https://drive.google.com/uc?export=view&id=1p2Y2GougQiZQ6yUfd_qc8k04q-2givb-',
    title: 'Characters',
    note: 'Write the best characters you have seen and liked in this note',
  ),
  /// COUNTRIES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FCountries.jpg?alt=media&token=05db3ec7-e2ba-4c2e-b5e9-b0fa55e75bbb',
    title: 'Countries',
    note: 'Write the best countries or cities you have visited or are looking forward to visiting Someday',
  ),
  /// PEOPLES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FPeoples.jpg?alt=media&token=ca9141bb-cd62-4b02-9cdf-61c23b7da0c0',
    title: 'Peoples',
    note: 'Write the best people you deal with and love in this note',
  ),
  /// STARS
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FStars.jpg?alt=media&token=4d243ac7-6c8c-4ce5-a03e-61480aed83c5',
    title: 'Stars',
    note: 'Write the name of your favorite star here, whether they are a scientist, footballer, singer, or anything else, on this note.',
  ),
  /// BOOKS
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FBooks.jpg?alt=media&token=4dd0b696-7811-4f3d-bbb8-c1c31d3186b0&_gl=1*1yal8ja*_ga*MzAxMDkxNzQuMTY5MTA5NDI1Mg..*_ga_CW55HF8NVT*MTY5ODUyMDkzMC4xNjAuMS4xNjk4NTIyNjA0LjYwLjAuMA..',
    title: 'Books',
    note: 'Write the best books and novels that you like to read in this note',
  ),
  /// FAVORITE DATES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2Fpreferred%20dates.jpg?alt=media&token=c2acf0bb-5d46-468f-86d0-ce3c2d66fbf5&_gl=1*kg49fy*_ga*MzAxMDkxNzQuMTY5MTA5NDI1Mg..*_ga_CW55HF8NVT*MTY5NjQ0MTk5My4xMzQuMS4xNjk2NDQyMDM1LjE4LjAuMA..',
    title: 'Favorite dates',
    note: 'Write your favorite dates that mean something to you in this note',
  ),
  /// WEBSITES
  ProfileListsModel(
    image: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/favorite%20lists%2FWebsites.jpg?alt=media&token=557d30d8-3d72-4bc1-bc42-e45030eef1d9&_gl=1*1t55ijn*_ga*MzAxMDkxNzQuMTY5MTA5NDI1Mg..*_ga_CW55HF8NVT*MTY5ODUyMDkzMC4xNjAuMS4xNjk4NTIyNzc4LjYwLjAuMA..',
    title: 'Websites',
    note: 'Write your favorite websites that you like to visit in this note',
  ),
];

///  format images
// https://drive.google.com/uc?export=view&id=1BGhuYnxO2tqu1apYjnnoveCXrANlzZw6
