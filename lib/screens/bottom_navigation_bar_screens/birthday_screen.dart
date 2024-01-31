import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:premium_fivver_note_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:slide_countdown/slide_countdown.dart';

class BirthdayScreen extends StatelessWidget {
  final double requiredWidth  = 240;
  final double requiredHeight  = 190;
  const BirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NotesCubit.get(context);
        DateTime parseBirthday = DateTime.parse(cubit.model.birthday);

        final now = DateTime.now();

        late int nextYear;
        int calculateTheYears() {
          if (now.month == parseBirthday.month &&
                  now.day >= parseBirthday.day ||
              now.month > parseBirthday.month) {
            nextYear = now.year + 1;
          } else {
            nextYear = now.year;
          }

          return nextYear;
        }

        DateTime birthday = DateTime(
            calculateTheYears(), parseBirthday.month, parseBirthday.day);

        Duration currentDiff = birthday.difference(DateTime.now());

        DateTime birthdayCelebration =
            DateTime(now.year, parseBirthday.month, parseBirthday.day + 1);
        DateTime birthdayWithThisYear =
            DateTime(now.year, parseBirthday.month, parseBirthday.day);

        Duration currentDiffCelebration =
            birthdayCelebration.difference(DateTime.now());
        DateTime today = DateTime(now.year, now.month, now.day);

        double percent = currentDiff.inSeconds / 31708800;

        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double radius = constraints.maxWidth / 3;
              final double availableWidth = constraints.maxWidth;
              final double availableHeight = constraints.maxHeight;


              return Column(
            children: [
              /// countdown
              if (!cubit.isThisMyBirthday)
                Expanded(
                  child: Column(
                    children: [
                      /// text
                      if(65 <= availableHeight)
                        const Text(
                        'My Next Birthday',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// countdown
                      if(requiredHeight <= availableHeight)
                        Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    /// image
                                    CircularPercentIndicator(
                                      radius: radius,
                                      lineWidth: 13.0,
                                      animation: true,
                                      percent: percent,
                                      center: Center(
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(cubit.model.profile),
                                          radius: radius - 10,
                                        ),
                                      ),
                                      circularStrokeCap: CircularStrokeCap.round,
                                      progressColor: defColor,
                                      backgroundColor: secondColor,
                                    ),


                                    /// count down
                                    if(requiredWidth <= availableWidth)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: SlideCountdownSeparated(
                                        onDone: () {
                                          cubit.birthday();
                                        },
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: defColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        textStyle:
                                            const TextStyle(color: secondColor),
                                        duration: currentDiff,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (today == birthdayWithThisYear)
                              Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: defColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    cubit.birthday();
                                  },
                                  child: const Text(
                                    'Celebration !',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              /// celebration
              if (cubit.isThisMyBirthday)
                Expanded(
                  child: Column(
                    children: [
                      ///  happy birthday text and skip button
                      if(450 <= availableHeight)
                        Expanded(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Lottie.network(
                                'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/json%2FHappy%20Birhday.json?alt=media&token=ebfd3208-ab72-46f9-8f59-5e3f4839e9bf',
                                width: double.infinity),

                            /// skip bottom
                            Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 5),
                              decoration: const BoxDecoration(
                                color: defColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              width: 60,
                              child: TextButton(
                                onPressed: () {
                                  cubit.birthday();
                                },
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// image
                      Expanded(
                        flex: 2,
                        child: Lottie.network(
                            'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/json%2FBirthday.json?alt=media&token=c35ad661-a953-4630-9bdc-94acf7085b79'),
                      ),

                      const SizedBox(height: 10),

                      /// massage
                      if(100 <= availableHeight)
                        Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SingleChildScrollView(
                              child: Text(
                                'Dear ${cubit.model.name}, \nHappy Birthday to you! Wishing you an amazing year filled with joy, happiness, and success. May all your dreams come true and may this special day bring you lots of love and laughter.\n\nEnjoy your special day to the fullest and let\'s celebrate this milestone together. Cheers to another year of growth and happiness!\n\nBest regards,\nAbanoub',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Color(0xff92786a),
                                ),
                              ),
                            ),

                            /// countdown
                            SlideCountdownSeparated(
                              onDone: () {
                                cubit.birthday();
                              },
                              height: 50,
                              width: MediaQuery.of(context).size.width / 9,
                              decoration: const BoxDecoration(
                                color: defColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              textStyle: const TextStyle(color: secondColor),
                              duration: currentDiffCelebration,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
        );
      },
    );
  }
}
