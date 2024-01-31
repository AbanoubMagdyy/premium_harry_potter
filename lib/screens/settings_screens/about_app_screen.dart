import 'package:cached_network_image/cached_network_image.dart';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/constants.dart';

class AboutAppScreen extends StatelessWidget {
  final double requiredWidth = 390;

  const AboutAppScreen({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff564638),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            double radius = constraints.maxWidth / 25;
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/background%2Fthanks.png?alt=media&token=cd11fcae-3afc-49ef-8789-1d0d32c1c95b'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        const SizedBox(height: 20,),
                        /// body
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              /// text
                              BlocConsumer<NotesCubit,NotesStates>(
                                listener: (context,state){},
                                builder: (context,state){

                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        'Dear ${NotesCubit.get(context).model.name.toUpperCase().split(' ')[0]}, \n\ni wanted to take this opportunity to wish you all the happiness and success in your life. May all your dreams come true and may you continue to achieve great things.\n\nIf you ever encounter any problems while using application, please do not hesitate to contact me. i am always here to help and provide support. Your feedback is important to me and i committed to providing the best possible experience for you.\n\nThank you for choosing my application and hope that you continue to enjoy using it.\n\nBest regards,\nAbanoub',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 25),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              /// ITEMS
                              if(requiredWidth <= availableWidth)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  /// facebook and gmail
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: item(
                                      image1: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ffacebook.png?alt=media&token=331b93cd-7382-4210-9b6a-c77fd58bcb3f',
                                      name1: 'Facebook',
                                      onTap1: facebook,
                                      image2: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Fgmail.png?alt=media&token=efcd2f31-0bc1-46eb-9fb7-f928c67787f2',
                                      name2: 'Gmail',
                                      onTap2: gmail,
                                    ),
                                  ),

                                  /// whats app and telegram
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: item(
                                      image1: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Fwhatsapp.png?alt=media&token=a1b8fe0f-8c7e-45da-baf8-c99d565f5e6b',
                                      name1: 'What\'s App',
                                      onTap1: whatsApp,
                                      image2: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ftelegram.png?alt=media&token=1f52a294-1414-44cb-8f4b-f233f8bb10bb',
                                      name2: 'Telegram',
                                      onTap2: telegram,
                                    ),
                                  ),

                                  /// linkedin and fivver
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: item(
                                      image1: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ffivver.png?alt=media&token=dd94ffc5-4a01-42f6-b152-741eabc5c7de',
                                      name1: 'Fivver',
                                      image2: 'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Flinkedin.png?alt=media&token=f7586d92-9269-4734-85be-0af495c2ce87',
                                      name2: 'Linkedin', onTap1: () {  },
                                      onTap2: linkedIn,
                                    ),
                                  ),
                                ],
                              ),
                              if(requiredWidth > availableWidth)
                                Container(
                                height: 80,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xffa18848),
                                  borderRadius: BorderRadius.circular(20),

                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    /// telegram
                                    socialMediaItem(
                                      image:
                                      'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ftelegram.png?alt=media&token=1f52a294-1414-44cb-8f4b-f233f8bb10bb',
                                      onTap: telegram,
                                      radius: radius,
                                    ),

                                    /// whats app
                                    socialMediaItem(
                                      image:
                                      'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Fwhatsapp.png?alt=media&token=a1b8fe0f-8c7e-45da-baf8-c99d565f5e6b',
                                      onTap: whatsApp,
                                      radius: radius,
                                    ),

                                    /// facebook
                                    socialMediaItem(
                                      image:
                                      'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ffacebook.png?alt=media&token=331b93cd-7382-4210-9b6a-c77fd58bcb3f',
                                      onTap: facebook,
                                      radius: radius,
                                    ),

                                    /// gmail
                                    socialMediaItem(
                                      image:
                                      'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Fgmail.png?alt=media&token=efcd2f31-0bc1-46eb-9fb7-f928c67787f2',
                                      onTap: gmail,
                                      radius: radius,
                                    ),

                                    /// fivver
                                    socialMediaItem(
                                      image:
                                      'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Ffivver.png?alt=media&token=dd94ffc5-4a01-42f6-b152-741eabc5c7de',
                                      onTap: () {},
                                      radius: radius,
                                    ),

                                    /// linkedin
                                    socialMediaItem(
                                      image:
                                      'https://firebasestorage.googleapis.com/v0/b/premium-note-app.appspot.com/o/social%20media%2Flinkedin.png?alt=media&token=f7586d92-9269-4734-85be-0af495c2ce87',
                                      onTap: linkedIn,
                                      radius: radius,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  Widget item({
    required String image1,
    required String name1,
    required String image2,
    required String name2,
    required Function() onTap1,
    required  Function() onTap2,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// icon 1
          Expanded(
            child: InkWell(
              onTap: onTap1,
              child: Container(
                height: 55,
                padding: const EdgeInsetsDirectional.all(10),
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                decoration: const BoxDecoration(color: Color(0xffa18848)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    networkImage(image1),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,),
                    )
                  ],
                ),
              ),
            ),
          ),

          /// icon 2
          Expanded(
            child: InkWell(
              onTap:onTap2 ,
              child: Container(
                height: 55,
                padding: const EdgeInsetsDirectional.all(10),
                decoration: const BoxDecoration(color: Color(0xffa18848)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    networkImage(image2),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name2,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

}
