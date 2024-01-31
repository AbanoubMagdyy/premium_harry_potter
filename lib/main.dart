import 'package:premium_fivver_note_app/screens/first_screens/on_boarding_screen.dart';
import 'package:premium_fivver_note_app/screens/account_disabled_screen.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc_observer.dart';
import 'package:premium_fivver_note_app/shared/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/constants.dart';
import 'firebase_options.dart';
import 'layout/layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Shared.init();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  email = await Shared.getDate('email') ?? '';
  await checkInternetConnectivity();
  Widget screen;
  if (email != '') {
    screen = const LayoutScreen();
  } else {
    screen = const OnBoardingScreen();
  }
bool isDisabled = await checkUserAccountStatus();

  runApp(MyApp(screen,isDisabled));
}

class MyApp extends StatelessWidget {
  final Widget screen;
  final bool isDisabled;
   const MyApp(this.screen,this.isDisabled,{super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesCubit()..getUserData(),
        ),
        BlocProvider(
          create: (context) => AddNoteCubit()..getNotes(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Harry',
          primarySwatch: Colors.grey,
        ),
        debugShowCheckedModeBanner: false,
        home: isDisabled ? const AccountDisabledScreen() : screen
      ),
    );
  }
}
