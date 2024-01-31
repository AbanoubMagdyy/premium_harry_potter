import 'dart:io';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/screens/view_image_screen.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/layout_screen.dart';
import '../../shared/bloc/cubit.dart';
import '../../style/colors.dart';
import '../background_image.dart';


class AddNoteScreen extends StatelessWidget {
  final title = TextEditingController();
  final note = TextEditingController();
  final double requiredWidth = 285;
  final double requiredHeight = 750;


  AddNoteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    AddNoteCubit.get(context).isFavorite = false;
    AddNoteCubit.get(context).category = '';
    AddNoteCubit.get(context).imageFiles = [];
    AddNoteCubit.get(context).imageUrls = [];
    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {
        if(state is SuccessGetNotes){
          toast(msg: 'add note success', isError: false);
          navigateTo(context, const LayoutScreen());
        }
      },
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            if (note.text.isNotEmpty ||
                title.text.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: secondColor,
                      contentPadding: const EdgeInsetsDirectional.all(50),
                      content: Text(
                        'Do you want to save this note'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () async {
                            toast(
                              msg: 'Please wait',
                              isError: false,);
                               checkInternetConnectivity();
                            if(isConnect){
                              var  image = calculateTotalFileSizeInGB(cubit.imageFiles, false);
                              if(image <= NotesCubit.get(context).model.maximumSizeOfImagesInGB){
                                  calculateTotalFileSizeInGB(cubit.imageFiles, true);
                                  cubit.createNote(
                                    title: title.text,
                                    note: note.text,
                                  );
                              }else{
                                toast(msg: 'You have exceeded the maximum available space. You need to delete some images or increase the space if you wish, contact the programmer', isError: true);
                              }
                            }else {
                              toast(
                                msg: 'Please check the Internet',
                                isError: true,);
                            }
                          },
                          child: Text(
                            'save'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            navigateTo(context, const LayoutScreen());
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
            } else {
            }
            return true;
          },
          child: Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double availableWidth = constraints.maxWidth;
                final double availableHeight = constraints.maxHeight;
                return BackgroundImage(
                  sigma: 23,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 10),
                    child: SafeArea(
                      child: Column(
                        children: [
                          ///appBar
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if(450 <= availableWidth)
                                  Expanded(child: defAppBar(context: context, screenName: 'Add Note',),),
                                if(requiredWidth<=availableWidth)
                                Row(
                                  children: [
                                    ///  add note
                                    defIconButton(
                                        icon: Icons.check,
                                        onTap: () async {
                                          toast(
                                            msg: 'Please wait',
                                            isError: false,);
                                          double  image = calculateTotalFileSizeInGB(cubit.imageFiles, false);
                                          if(image<= NotesCubit.get(context).model.maximumSizeOfImagesInGB){
                                            checkInternetConnectivity();
                                            if(isConnect){
                                              if (note.text.isNotEmpty ||
                                                  title.text.isNotEmpty ) {
                                                calculateTotalFileSizeInGB(cubit.imageFiles, true);
                                                cubit.createNote(
                                                  title: title.text,
                                                  note: note.text,
                                                );

                                              } else {
                                                toast(msg: 'the note is empty', isError: false);
                                              }
                                            } else {
                                              toast(
                                                msg: 'Please check the Internet',
                                                isError: true,);
                                            }
                                          }else{
                                            toast(msg: 'You have exceeded the maximum available space. You need to delete some images or increase the space if you wish, contact the programmer', isError: true);
                                          }

                                        }

                                    ),

                                    /// choose images
                                    defIconButton(
                                      icon: Icons.photo_library_outlined,
                                      onTap: () {
                                        cubit.selectImages(cubit.imageFiles);
                                      },
                                    ),


                                    /// add to category
                                    defIconButton(
                                      icon: Icons.add,
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: defColor,
                                          builder: (context) {
                                            return Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsetsDirectional.all(10),
                                                  padding: const EdgeInsetsDirectional.all(15),
                                                  decoration: BoxDecoration(
                                                    color: secondColor,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text('Add to category'.toUpperCase(),style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemBuilder: (context, index) =>
                                                        categoryItem(categories[index],context),
                                                    itemCount: categories.length,
                                                    physics: const BouncingScrollPhysics(),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),


                                    /// favorite
                                    defIconButton(
                                      icon:cubit.isFavorite ? Icons.favorite : Icons.favorite_outline,
                                      onTap: () {
                                        cubit.changeFavourites();
                                      },
                                    ),
                                  ],
                                )
                              ],
                          ),
                            ),
                          if(state is LeadingCreatePost || state is LeadingGetNotes || state is LeadingInsertImagesInNote || state is LeadingUploadImages)
                            defLinearProgress(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  /// title
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        wordSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some information';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Title',
                                      ),
                                    ),
                                  ),

                                  /// note
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      enabled: true,
                                      readOnly: false,
                                      minLines: 1,
                                      maxLines: 1000,
                                      controller: note,
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some information';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontSize: 24,
                                        wordSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Type Something ...',
                                      ),
                                    ),
                                  ),

                                  /// images
                                  if (cubit.imageFiles.isNotEmpty)
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: ListView.separated(
                                          itemCount: cubit.imageFiles.length,
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) =>
                                          const SizedBox(width: 5),
                                          itemBuilder: (context, index) {
                                            File? imageFile =
                                            cubit.imageFiles[index];
                                            return InkWell(
                                              onTap: () {
                                                navigateTo(
                                                  context,
                                                  FullScreenImage(
                                                      imagePath: imageFile.path),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Image.file(imageFile),
                                                  if(availableHeight >= 750)
                                                    Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 8.0),
                                                    child: defIconButton(
                                                      height: 40,
                                                      icon: Icons.delete_outline,
                                                      onTap: () => cubit.removeImage(cubit.imageFiles,imageFile),
                                                    ),
                                                  ),
                                                  if(requiredHeight > availableHeight && availableHeight > 350)
                                                    IconButton(
                                                      icon:const Icon(Icons.remove_circle_outline_sharp),
                                                      onPressed: () =>
                                                          cubit.removeImage(cubit.imageFiles,imageFile),
                                                      alignment: Alignment.topLeft,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        );
      },
    );
  }
}

