import 'package:flutter/material.dart';
import '../components/components.dart';
import '../components/constants.dart';

class AccountDisabledScreen extends StatelessWidget {
  final double requiredHeight = 380;

  const AccountDisabledScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7c7676),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double availableHeight = constraints.maxHeight;
        double radius = constraints.maxWidth / 23;

        return Center(
          child: Column(
            children: [
              Expanded(
                child: networkImage(
                    'https://drive.google.com/uc?export=view&id=1BGhuYnxO2tqu1apYjnnoveCXrANlzZw6',
                    height: 200.0,
                    width: 400.0,
                    fit: BoxFit.fill),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          'Sorry Potterhead, Your account has been enchanted with a temporary Disabling Charm, rendering it inaccessible at the moment.Contact the programmer to find out why.',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.5),
                        ),
                      ),
                    ),
                    if (requiredHeight <= availableHeight)
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xff686464),
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
              )),
            ],
          ),
        );
      }),
    );
  }

}
