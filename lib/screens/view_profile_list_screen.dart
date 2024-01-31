import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_fivver_note_app/models/profile_lists_model.dart';
import 'package:premium_fivver_note_app/screens/background_image.dart';
import 'package:premium_fivver_note_app/screens/settings_screens/profile_screen.dart';
import 'package:premium_fivver_note_app/shared/profile_bloc/cubit.dart';
import '../components/components.dart';
import '../components/constants.dart';
import '../shared/profile_bloc/states.dart';
import '../style/colors.dart';

class ViewProfileListScreen extends StatelessWidget {
  final ProfileListsModel model;
  final double requiredWidth = 400;

  final note = TextEditingController();

  ViewProfileListScreen(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileListNote(model.title),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = ProfileCubit.get(context);
            note.text = cubit.model.note;
            return WillPopScope(
              onWillPop: () async {
                if (note.text != cubit.model.note) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: secondColor,
                        contentPadding: const EdgeInsetsDirectional.all(50),
                        content: Text(
                          'Do you want to update the change?'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              checkInternetConnectivity();
                              if (isConnect) {
                                cubit.updateProfileListNote(
                                  note: note.text,
                                  title: model.title,
                                );
                              } else {
                                toast(
                                  msg: 'Please check the Internet',
                                  isError: true,
                                );
                              }
                            },
                            child: Text(
                              'update'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              navigateTo(context, const ProfileScreen());
                            },
                            child: Text(
                              'cancel'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return true;
              },
              child: Scaffold(
                body: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  final double availableWidth = constraints.maxWidth;
                  return BackgroundImage(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            /// APPBAR
                            if(requiredWidth <= availableWidth)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: defAppBar(
                                      context: context,
                                      screenName: model.title,
                                    ),
                                  ),

                                  /// item
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: defColor,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  30),
                                        ),
                                        child: Row(
                                          children: [
                                            /// text
                                            Container(
                                              margin: const EdgeInsetsDirectional
                                                  .symmetric(horizontal: 10),
                                              child: Text(
                                                model.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: secondColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                ),
                                              ),
                                            ),

                                            ///image
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      model.image!),
                                              radius: 22,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// save icon
                                  defIconButton(
                                      icon: Icons.save,
                                      onTap: () {
                                        checkInternetConnectivity();
                                        if (isConnect) {
                                          if (note.text != cubit.model.note) {
                                            cubit.updateProfileListNote(
                                              note: note.text,
                                              title: model.title,
                                            );
                                          } else {
                                            toast(
                                                msg: 'Nothing changed',
                                                isError: false);
                                          }
                                        } else {
                                          toast(
                                            msg: 'Please check the Internet',
                                            isError: true,
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),


                            if (state is LeadingUpdateProfileListNote ||
                                state is LeadingGetProfileListNotes)
                              defLinearProgress(),

                            /// note
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  maxLines: 10000000000000,
                                  controller: note,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    wordSpacing: 5,
                                    height: 1.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type Something ...',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                ),
              ),
            );
          },
      ),
    );
  }
}
