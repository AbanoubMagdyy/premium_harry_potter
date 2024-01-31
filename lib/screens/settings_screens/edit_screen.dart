import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/constants.dart';
import '../../style/colors.dart';
import '../background_image.dart';

class EditScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final double requiredWidth = 250;


  EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotesCubit.get(context).profileImage = null;
    emailController.text = NotesCubit.get(context).model.email;
    nameController.text = NotesCubit.get(context).model.name;
    birthdayController.text = NotesCubit.get(context).model.birthday;
    bioController.text = NotesCubit.get(context).model.bio;
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {
        if (state is SuccessUpdateData) {
          toast(msg: 'Success Update Data', isError: false);
        }
      },
      builder: (context, state) {
        NotesCubit cubit = NotesCubit.get(context);
        var profileImage = cubit.profileImage;
        String month = cubit.date.month.toString();
        String day = cubit.date.day.toString();
        if (cubit.date.month < 10) {
          month = '0${cubit.date.month}';
        }
        if (cubit.date.day < 10) {
          day = '0${cubit.date.day}';
        }

        if (cubit.putDate) {
          birthdayController.text = "${cubit.date.year.toString()}-$month-$day";
        }
        return Scaffold(
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            double radius = constraints.maxWidth / 4;

            return BackgroundImage(
              sigma: 15,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        /// APPBAR
                        if(requiredWidth <= availableWidth)
                        defAppBar(context: context, screenName: 'edit profile'),
                        if (state is LeadingUpdateData) defLinearProgress(),

                        /// body
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  /// image
                                  Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      if (profileImage == null)
                                        InkWell(
                                          onTap: () {
                                            cubit.getImageFromGallery();
                                          },
                                          child: CircleAvatar(
                                            radius: radius,
                                            backgroundColor: secondColor,
                                            child: CircleAvatar(
                                              backgroundImage: CachedNetworkImageProvider(
                                                cubit.model.profile,
                                              ),
                                              radius: radius -10,
                                            ),
                                          ),
                                        ),
                                      if (profileImage != null)
                                        InkWell(
                                          onTap: () {
                                            cubit.getImageFromGallery();
                                          },
                                          child: CircleAvatar(
                                            radius: radius,
                                            backgroundColor: secondColor,
                                            child: CircleAvatar(
                                              backgroundImage: FileImage(
                                                  cubit.profileImage!),
                                              radius: radius-10,
                                            ),
                                          ),
                                        ),
                                      if(requiredWidth + 140 <= availableWidth)
                                        Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: CircleAvatar(
                                          radius: radius - (radius - 30),
                                          backgroundColor: secondColor,
                                          child: IconButton(
                                            onPressed: () {
                                              cubit.getImageFromGallery();
                                            },
                                            icon: const Icon(
                                              Icons.photo,
                                              size: 30,
                                              color: defColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// email
                                  defTextField(
                                    controller: emailController,
                                    leftIcon: Icons.lock_outline,
                                    rightIcon: Icons.email_outlined,
                                    hideKeyboard: true,
                                  ),

                                  /// name edit
                                  defTextField(
                                    controller: nameController,
                                    rightIcon: Icons
                                        .drive_file_rename_outline_outlined,
                                    text: 'Enter a new name',
                                  ),

                                  /// BIO EDIT
                                  defTextField(
                                      controller: bioController,
                                      rightIcon: Icons.list_alt,
                                      text: 'Enter a new bio',
                                      maxLines: 4,
                                      keyboard: TextInputType.multiline,
                                      maxLength: 4 * 35,
                                  ),

                                  /// birthday edit
                                  defTextField(
                                    hideKeyboard: true,
                                    onTap: () {
                                      cubit.showTheDate(context: context);
                                    },
                                    fontSize: 20,
                                    controller: birthdayController,
                                    rightIcon: Icons.cake_outlined,
                                    text: 'Enter a new birthday',
                                  ),

                                  /// update button
                                  InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        checkInternetConnectivity();
                                        if (isConnect) {
                                          if (cubit.profileImage != null) {
                                            double image =
                                                calculateTotalFileSizeInGB(
                                                    cubit.profileImage, false);
                                            if (image <=
                                                cubit.model
                                                    .maximumSizeOfImagesInGB) {
                                              calculateTotalFileSizeInGB(
                                                  cubit.profileImage, true);
                                              cubit.updateData(
                                                  name: nameController.text,
                                                  birthday:
                                                      birthdayController.text,
                                                  bio: bioController.text);
                                            } else {
                                              toast(
                                                  msg:
                                                      'You have exceeded the maximum available space. You need to increase the space if you wish, contact the programmer',
                                                  isError: true);
                                            }
                                          } else {
                                            cubit.updateData(
                                                name: nameController.text,
                                                birthday:
                                                    birthdayController.text,
                                                bio: bioController.text);
                                          }
                                        } else {
                                          toast(
                                            msg: 'Please check the Internet',
                                            isError: true,
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 230,
                                      padding:
                                          const EdgeInsetsDirectional.all(10),
                                      margin:
                                          const EdgeInsetsDirectional.symmetric(
                                        vertical: 15,
                                      ),
                                      decoration:
                                          const BoxDecoration(color: defColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          const Icon(
                                            Icons.cake_outlined,
                                            color: secondColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'update Date'.toUpperCase(),
                                            style: const TextStyle(
                                              color: secondColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
